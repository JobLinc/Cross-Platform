import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/services/navigation_service.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:joblinc/features/notifications/data/services/device_token_service.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final DeviceTokenService _deviceTokenService;

  // Use a callback instead of direct dependency
  final Function(NotificationModel) onNewNotification;

  FirebaseMessagingService(
    this._deviceTokenService,
    this.onNewNotification,
  );

  Future<void> initialize() async {
    // Request permission
    await _requestPermission();

    // Configure local notifications
    await _configureLocalNotifications();

    // Configure FCM handlers
    _configureFirebaseMessaging();

    // Register token with backend
    await getAndRegisterToken();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint('FCM: User permission status: ${settings.authorizationStatus}');
  }

  Future<void> _configureLocalNotifications() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS initialization
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    // Initialize local notifications
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(response.payload);
      },
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'job_notifications_channel',
      'Job Notifications',
      importance: Importance.high,
      playSound: true,
      showBadge: true,
      enableVibration: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _configureFirebaseMessaging() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle messages opened when app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('FCM: onMessageOpenedApp: ${message.data}');
      // Navigate to notifications tab when notification is tapped in background
      _handleNotificationNavigation(message.data);
    });

    // DON'T try to handle initial message here - it needs to be done in main.dart
    // after app is fully initialized
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('FCM: Got foreground message: ${message.data}');

    // Parse notification data
    Map<String, dynamic> notificationData = message.data;
    String title = message.notification?.title ?? 'JobLinc Notification';
    String body = message.notification?.body ?? '';

    // Show local notification when app is in foreground
    await _showLocalNotification(
      title: title,
      body: body,
      payload: json.encode(notificationData),
    );

    // Add notification to cubit state
    _addNotificationToState(message);
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'job_notifications_channel',
      'Job Notifications',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond, // Unique ID
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void _handleRemoteMessage(RemoteMessage message) {
    // Add notification to cubit state
    _addNotificationToState(message);

    // Navigate to appropriate screen based on notification type
    // This will depend on your app's navigation structure
  }

  void _addNotificationToState(RemoteMessage message) {
    try {
      Map<String, dynamic> data = message.data;

      // Create a notification model from the FCM message
      NotificationModel notification = NotificationModel(
        id: data['entityId'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        type: data['type'] ?? 'notification',
        content: message.notification?.body ?? data['text'] ?? '',
        imageUrl: data['imageURL'],
        isRead: "pending",
        createdAt: DateTime.now(),
      );

    } catch (e) {
      debugPrint('FCM: Error processing notification: $e');
    }
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        Map<String, dynamic> data = json.decode(payload);
        debugPrint('FCM: Notification tapped with data: $data');
        
        _handleNotificationNavigation(data);
      } catch (e) {
        debugPrint('FCM: Error handling notification tap: $e');
      }
    }
  }

  // New method to centralize navigation logic
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    try {
      // Get the navigation service
      final navigationService = getIt<NavigationService>();

      // Handle navigation based on notification type
      String type = data['type'] ?? '';
      String entityId = data['entityId'] ?? '';

      debugPrint('FCM: Navigating for notification type: $type, entityId: $entityId');

      // Navigate to the notifications tab in MainContainerScreen (tab index 3)
      navigationService.navigateToMainContainerSafely(3);
    } catch (e) {
      debugPrint('FCM: Error during notification navigation: $e');
    }
  }

  // Add this method to handle initial notification that launched the app
  Future<void> checkInitialMessage() async {
    try {
      RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        debugPrint('FCM: App launched from notification: ${initialMessage.data}');
        // Wait a short time for app to be fully initialized before navigating
        await Future.delayed(const Duration(milliseconds: 500));
        _handleNotificationNavigation(initialMessage.data);
      }
    } catch (e) {
      debugPrint('FCM: Error checking initial message: $e');
    }
  }

  Future<String?> getAndRegisterToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        debugPrint('FCM: Token: $token');

        // Register token with backend
        await _deviceTokenService.registerDeviceToken(token);
      }

      // Setup token refresh listener
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM: Token refreshed: $newToken');
        _deviceTokenService.registerDeviceToken(newToken);
      });

      return token;
    } catch (e) {
      debugPrint('FCM: Error getting token: $e');
      return null;
    }
  }

  Future<void> unregisterToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _deviceTokenService.unregisterDeviceToken(token);
        await _firebaseMessaging.deleteToken();
      }
    } catch (e) {
      debugPrint('FCM: Error unregistering token: $e');
    }
  }
}

// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to ensure Firebase is initialized
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint("FCM: Handling a background message: ${message.messageId}");
  // We don't need to show a notification here as FCM will automatically show it
}
