// Location: lib/services/notification_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  // 1. Create a Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 2. Main initialization method to be called at app startup
  Future<void> initialize() async {
    bool hasPermission = await requestPermission();

    if (hasPermission) {
      await subscribeToCommonTopic();
      _setupForegroundListeners();
    }
  }

  // 3. Handle Permission Request (System Dialogue)
  Future<bool> requestPermission() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('Notification permission granted.');
        return true;
      } else {
        debugPrint('Notification permission denied.');
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return false;
    }
  }

  // 4. Handle Topic Subscription
  Future<void> subscribeToCommonTopic() async {
    try {
      await _messaging.subscribeToTopic('all_users');
      debugPrint('Successfully subscribed to all_users topic.');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  // 5. Handle incoming messages when the app is open (Foreground)
  void _setupForegroundListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received a foreground message: ${message.messageId}');
      if (message.notification != null) {
        debugPrint('Message Title: ${message.notification?.title}');
        // Here you can trigger a local notification to show the UI
      }
    });
  }
}