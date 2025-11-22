import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _notificationsEnabled = true;
  bool _lowBatteryAlerts = true;
  bool _connectionAlerts = true;
  int _lastBatteryNotification = 100;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get lowBatteryAlerts => _lowBatteryAlerts;
  bool get connectionAlerts => _connectionAlerts;

  NotificationProvider() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // For Android, you need to create notification channel
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // Will be replaced with custom icon
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);

    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'dr_veuolla_pods',
      'Dr. Veuolla\'s Pods',
      description: 'Notifications for your Funpods',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  // Show notification with theme-based message
  Future<void> showNotification({
    required String title,
    required String body,
    String? emoji,
    NotificationType type = NotificationType.general,
  }) async {
    if (!_notificationsEnabled) return;

    // Check notification type permissions
    if (type == NotificationType.lowBattery && !_lowBatteryAlerts) return;
    if (type == NotificationType.connection && !_connectionAlerts) return;

    const androidDetails = AndroidNotificationDetails(
      'dr_veuolla_pods',
      'Dr. Veuolla\'s Pods',
      channelDescription: 'Notifications for your Funpods',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher', // Custom notification icon
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      type.index, // Use type as ID to replace previous notifications
      emoji != null ? '$emoji $title' : title,
      body,
      details,
    );
  }

  // Show low battery notification (only once per session below 20%)
  Future<void> checkAndNotifyLowBattery({
    required int battery,
    required String themeMessage,
    required String themeEmoji,
  }) async {
    if (battery < 20 && _lastBatteryNotification >= 20) {
      await showNotification(
        title: 'Low Battery',
        body: themeMessage,
        emoji: themeEmoji,
        type: NotificationType.lowBattery,
      );
      _lastBatteryNotification = battery;
    } else if (battery >= 20) {
      _lastBatteryNotification = battery;
    }
  }

  // Show connection notification
  Future<void> notifyConnection({
    required bool connected,
    required String themeMessage,
    required String themeEmoji,
  }) async {
    await showNotification(
      title: connected ? 'Connected' : 'Disconnected',
      body: themeMessage,
      emoji: themeEmoji,
      type: NotificationType.connection,
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

enum NotificationType { general, lowBattery, connection }
