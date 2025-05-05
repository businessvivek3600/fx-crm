import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentBanner: true,
      defaultPresentList: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      notificationCategories:<DarwinNotificationCategory>[
        DarwinNotificationCategory(
          'call_actions', // a unique identifier
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('ACCEPT', 'Accept'),
            DarwinNotificationAction.plain('DECLINE', 'Decline'),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.customDismissAction,
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
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
      'default_channel',
      'Default Notifications',
      channelDescription: 'For general notifications',
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
    return await _firebaseMessaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}
