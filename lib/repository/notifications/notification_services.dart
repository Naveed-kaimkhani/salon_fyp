import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/index.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxInt unreadCount = 0.obs; // Observable badge count

  NotificationService() {
    initializeNotifications();
    _setupFCMListeners();
  }

  /// Initialize Local Notifications
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _navigateToAppointmentsScreen(); // Navigate to Appointments Screen
      },
    );
  }

  /// Show Local Notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      // sound: 'notification_sound.wav',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(
      Duration.zero,
      () async => await _flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        title,
        body,
        notificationDetails,
        payload: payload ?? RouteName.appointmentScreen,
      ),
    );
  }

  /// Schedule Local Notification
  Future<void> simulateScheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      // Check if reminders are enabled by the admin
      final doc = await _firestore
          .collection('settings')
          .doc('notification_settings')
          .get();

      if (doc.exists && !(doc.data()?['isReminderEnabled'] ?? false)) {
        Get.snackbar(
          'notifications_disabled'.tr,
          'notifications_stopped_by_admin'.tr,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final DateTime currentTime = DateTime.now();

      if (scheduledTime.isAfter(currentTime)) {
        final delay = scheduledTime.difference(currentTime);
        log("Scheduling notification for: $scheduledTime");
        Future.delayed(delay, () async {
          await showNotification(title: title, body: body);
        });
      } else {
        await showNotification(title: title, body: body);
      }
    } catch (e) {
      log("Error in simulateScheduledNotification: $e");
    }
  }

  /// Listen to Firestore Notifications for Real-Time Badge Updates
  void listenToFirestoreNotifications() {
    final String? userUid = FirebaseAuth.instance.currentUser?.uid;

    if (userUid == null) {
      log("No user logged in. Cannot listen for notifications.");
      return;
    }

    FirebaseFirestore.instance
        .collection('notifications')
        .where('userUid', isEqualTo: userUid)
        .where('isRead', isEqualTo: false) // Only count unread notifications
        .snapshots()
        .listen((snapshot) {
      unreadCount.value = snapshot.docs.length;
    });
  }

  /// Save Notification to Firestore
  Future<void> saveNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String userUid,
  }) async {
    try {
      final notificationData = {
        'title': title,
        'body': body,
        'scheduledTime': Timestamp.fromDate(scheduledTime),
        'userUid': userUid,
        'isRead': false,
        'createdAt': Timestamp.now(),
      };

      await _firestore.collection('notifications').add(notificationData);
    } catch (e) {
      log("Error saving notification: $e");
    }
  }

  /// Setup Firebase Cloud Messaging Listeners
  void _setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("FCM Message in foreground: ${message.notification?.title}");
      showNotification(
        title: message.notification?.title ?? 'no_title'.tr,
        body: message.notification?.body ?? 'no_body'.tr,
        payload: RouteName.appointmentScreen,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification opened: ${message.notification?.title}");
      _navigateToAppointmentsScreen();
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log("Notification from terminated state: ${message.notification?.title}");
        _navigateToAppointmentsScreen();
      }
    });
  }

  /// Navigate to Appointments Screen
  void _navigateToAppointmentsScreen() {
    Get.toNamed(RouteName.appointmentScreen); // Adjust this route as needed
  }

  /// Save FCM Device Token
  Future<void> saveDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        String userUid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
        await _firestore.collection('users').doc(userUid).update({
          'deviceToken': token,
        });
      }
    } catch (e) {
      log("Error saving FCM token: $e");
    }
  }

  /// Request Notification Permissions
  Future<void> requestPermissions() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User granted notification permissions");
    } else {
      log("User denied notification permissions");
    }
  }

  /// Clear Badge Count
  void clearBadgeCount() {
    unreadCount.value = 0;
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }
}