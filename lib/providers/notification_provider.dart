import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = true;
  bool _lowBatteryAlerts = true;
  bool _connectionAlerts = true;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get lowBatteryAlerts => _lowBatteryAlerts;
  bool get connectionAlerts => _connectionAlerts;

  NotificationProvider() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? emoji,
  }) async {
    if (!_notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      'sunflower_pods',
      'Sunflower Pods',
      channelDescription: 'Notifications for Sunflower Pods app',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      0,
      emoji != null ? '$emoji $title' : title,
      body,
      details,
    );
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void toggleLowBatteryAlerts(bool value) {
    _lowBatteryAlerts = value;
    notifyListeners();
  }

  void toggleConnectionAlerts(bool value) {
    _connectionAlerts = value;
    notifyListeners();
  }
}
