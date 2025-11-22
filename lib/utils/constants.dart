import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFFAFAFA);
  static const cardBackground = Colors.white;
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
}

class AppStrings {
  // Welcome Messages
  static const welcomeTitle = 'Veuolla 💜';
  static const welcomeSubtitle = 'Your Sunflower Pods';

  // Connection Messages
  static const connecting = 'Planting sunflower seeds of connection...';
  static const connected = 'Your garden of sound is blooming! 🌸';
  static const disconnected = 'Your sunshine went away... 🌻';

  // Greetings
  static const List<String> greetings = [
    'Hello Veuolla ☀️',
    'Your sunshine is connected, Veuolla! 🌻',
    'Ready to bloom with you today!',
    'The sea misses your rhythm, Veuolla 🌊',
    'Mango vibes activated for you! 🥭',
    'Violet dreams are connected 💜',
  ];

  // Battery Warnings
  static const lowBatterySunflower =
      'Sunflower needs some sunlight! (Low battery)';
  static const lowBatteryMango = 'Mango is getting sleepy... time to recharge';
  static const lowBatteryViolet = 'Violet dreams need more energy 💜';
  static const lowBatterySea = 'The sea is getting calm... battery low';

  // Find Messages (removed feature but keeping for compatibility)
  static const findHot = '🔥 Hot! Very Close!';
  static const findWarm = '🌡️ Warm... Getting closer';
  static const findCold = '❄️ Cold... Keep searching';
}

class BLEConstants {
  // Standard GATT Services
  static const batteryServiceUUID = '0000180f-0000-1000-8000-00805f9b34fb';
  static const deviceInfoServiceUUID = '0000180a-0000-1000-8000-00805f9b34fb';

  // Standard Characteristics
  static const batteryLevelUUID = '00002a19-0000-1000-8000-00805f9b34fb';
  static const modelNumberUUID = '00002a24-0000-1000-8000-00805f9b34fb';
  static const firmwareRevisionUUID = '00002a26-0000-1000-8000-00805f9b34fb';

  // Device Name Patterns - Updated with Joyroom
  static const List<String> deviceNamePatterns = [
    'Funpods',
    'Jayroom',
    'Joyroom', // Added this
    'Fun pods',
    'FN2', // Added this for your specific model
  ];
}
