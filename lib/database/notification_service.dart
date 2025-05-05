import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage storage = GetStorage();
  // Add this for Platform check

  Future<void> init() async {
    await _requestNotificationPermissionIfNeeded();

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
      _showNotification(message);
    });
    await subscribeToTopic('fxcrm_users');
    // ✅ Wait for APNs token if iOS before subscribing to topic
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

    // Log the FCM token
    final fcmToken = await getDeviceToken();
    if (fcmToken != null) {
      print("✅ FCM token: $fcmToken");
    }
  }


  ///user Permission
  Future<void> _requestNotificationPermissionIfNeeded() async {
    final alreadyRequested = storage.read('notification_permission_requested') ?? false;
    if (!alreadyRequested) {
      final settings = await _firebaseMessaging.requestPermission();
      final granted = settings.authorizationStatus == AuthorizationStatus.authorized;

      storage.write('notification_permission_requested', granted);
    }
  }


  void _setupInteractedMessage() async {
    final RemoteMessage? initialMessage =
    await _firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationClick(initialMessage.data.toString());
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message.data.toString());
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = notification?.android;
    final data = message.data;

    final String? imageUrl = android?.imageUrl ?? data['image'];
    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imageUrl != null) {
      final bigImagePath = await _downloadImage(imageUrl, 'bigImage');
      bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigImagePath),
        contentTitle: notification?.title,
        summaryText: notification?.body,
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
      iOS: const DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification?.title,
      notification?.body,
      notificationDetails,
      payload: data.toString(),
    );
  }

  Future<String> _downloadImage(String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName.jpg');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void _handleNotificationClick(String payload) {
    print('Notification clicked with payload: $payload');
    // Navigate to a screen or perform an action
  }

  Future<String?> getDeviceToken() async {
    final fcmToken = await _firebaseMessaging.getToken();
    final apnsToken = Platform.isIOS ? await _firebaseMessaging.getAPNSToken() : null;

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
