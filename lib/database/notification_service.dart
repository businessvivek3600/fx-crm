import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'notification_db.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage storage = GetStorage();

  Future<void> init() async {
    await _requestNotificationPermissionIfNeeded();
    final setting = await FirebaseMessaging.instance.requestPermission();
    print("🔐 iOS permissions: ${setting.authorizationStatus}");

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          _handleNotificationClick(payload);
        }
      },
    );

    _setupInteractedMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📥 Foreground notification message: ${message.data}");
      print("🔔 Notification: ${message.notification?.title} - ${message.notification?.body}");
      _showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
      // Navigate to NotificationScreen
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('Notification caused app to open from terminated state');
        // Navigate to NotificationScreen
      }
    });


    final fcmToken = await getDeviceToken();
    print("✅ FCM token: $fcmToken");

    if (Platform.isIOS) {
      String? apnsToken;
      int retry = 0;

      while (apnsToken == null && retry < 10) {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(Duration(seconds: 1));
          retry++;
        }
      }

      if (apnsToken != null) {
        print("✅ APNs token: $apnsToken");
        await subscribeToTopic('fxcrm_users');
      } else {
        print("❌ Failed to get APNs token");
      }
    } else {
      await subscribeToTopic('fxcrm_users');
    }
  }

  Future<void> _requestNotificationPermissionIfNeeded() async {
    final alreadyRequested =
        storage.read('notification_permission_requested') ?? false;
    if (!alreadyRequested) {
      final settings = await _firebaseMessaging.requestPermission();
      final granted =
          settings.authorizationStatus == AuthorizationStatus.authorized;

      storage.write('notification_permission_requested', granted);
    }
  }

  void _setupInteractedMessage() async {
    final RemoteMessage? initialMessage =
    await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      print("📤 getInitialMessage triggered ${initialMessage.data}");
      _handleNotificationClick(initialMessage.data.toString());
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📬 onMessageOpenedApp triggered${message.data.toString()}");
      _handleNotificationClick(message.data.toString());
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final String? title = notification?.title ?? data['title'];
    final String? body = notification?.body ?? data['body'];
    final String? imageUrl = data['image'] ??
        notification?.android?.imageUrl ?? // For Android
        notification?.apple?.imageUrl;

    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imageUrl != null && Platform.isAndroid) {
      final bigImagePath = await _downloadImage(imageUrl, 'bigImage');
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigImagePath),
        contentTitle: title,
        summaryText: body,
      );
    }

    final androidDetails = AndroidNotificationDetails(
      'fxcrm_channel',
      'FXCRM Notifications',
      channelDescription: 'Notifications from FXCRM app',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      notificationDetails,
      payload: data.toString(),
    );

    await NotificationDatabase().insertNotification({
      'title': title ?? '',
      'body': body ?? '',
      'image': imageUrl ?? '',
      'timestamp': DateTime.now().toIso8601String(),
    });

    print("✅ Notification saved: $title");
  }

  Future<String> _downloadImage(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName.jpg');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void _handleNotificationClick(String payload) async {
    print('Notification clicked with payload: $payload');

    final data = _parsePayloadToMap(payload);

    if (data != null) {
      await NotificationDatabase().insertNotification({
        'title': data['title'] ?? '',
        'body': data['body'] ?? '',
        'image': data['image'] ?? '',
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    // Navigate to desired screen if needed
  }

  Map<String, dynamic>? _parsePayloadToMap(String payload) {
    try {
      final cleaned = payload.replaceAll(RegExp(r'[{}]'), '');
      final entries = cleaned.split(', ').map((pair) {
        final split = pair.split(':');
        return MapEntry(split[0], split.length > 1 ? split.sublist(1).join(':') : '');
      });
      return Map.fromEntries(entries);
    } catch (e) {
      print("Failed to parse payload: $e");
      return null;
    }
  }

  Future<String?> getDeviceToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    final apnsToken =
    Platform.isIOS ? await _firebaseMessaging.getAPNSToken() : null;

    print("📱 FCM Token: $fcmToken");
    if (apnsToken != null) {
      print("🍏 APNs Token: $apnsToken");
    }

    return fcmToken;
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
