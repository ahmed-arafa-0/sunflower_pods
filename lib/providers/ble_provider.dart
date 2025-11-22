import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import '../models/earbud_data.dart';
import '../utils/constants.dart';

class BLEProvider extends ChangeNotifier {
  BluetoothDevice? _connectedDevice;
  List<BluetoothService>? _services;
  bool _isConnected = false;
  int _batteryLeft = 0;
  int _batteryRight = 0;
  int _batteryCase = 0;
  int _rssi = -100;
  Timer? _rssiTimer;
  Timer? _checkConnectionTimer;
  String _deviceModel = '';
  String _firmwareVersion = '';

  // Getters
  BluetoothDevice? get connectedDevice => _connectedDevice;
  bool get isConnected => _isConnected;
  int get batteryLeft => _batteryLeft;
  int get batteryRight => _batteryRight;
  int get batteryCase => _batteryCase;
  int get rssi => _rssi;
  String get deviceModel => _deviceModel;
  String get firmwareVersion => _firmwareVersion;

  EarbudData get earbudData => EarbudData(
    batteryLeft: _batteryLeft,
    batteryRight: _batteryRight,
    batteryCase: _batteryCase,
    rssi: _rssi,
    isConnected: _isConnected,
    deviceName: _connectedDevice?.platformName ?? '',
    deviceId: _connectedDevice?.remoteId.toString() ?? '',
    lastUpdated: DateTime.now(),
  );

  BLEProvider() {
    _startConnectionMonitoring();
  }

  // Check if Bluetooth is available
  Future<bool> isBluetoothAvailable() async {
    try {
      return await FlutterBluePlus.isAvailable;
    } catch (e) {
      debugPrint('Error checking Bluetooth: $e');
      return false;
    }
  }

  // Monitor system-connected devices automatically
  void _startConnectionMonitoring() {
    _checkConnectionTimer?.cancel();
    _checkConnectionTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      await checkSystemConnectedDevices();
    });
  }

  // Check for system-connected Funpods
  Future<void> checkSystemConnectedDevices() async {
    try {
      // Get connected devices through system Bluetooth
      final connectedDevices = FlutterBluePlus.connectedDevices;

      // Check for Funpods in connected devices
      for (var device in connectedDevices) {
        final name = device.platformName.toLowerCase();
        final isFunpods = BLEConstants.deviceNamePatterns.any(
          (pattern) => name.contains(pattern.toLowerCase()),
        );

        if (isFunpods && !_isConnected) {
          debugPrint(
            '✅ Found system-connected Funpods: ${device.platformName}',
          );
          await _connectToSystemDevice(device);
          return;
        }
      }

      // If no Funpods found and we were connected, mark as disconnected
      if (_isConnected && !connectedDevices.contains(_connectedDevice)) {
        debugPrint('⚠️ Funpods disconnected');
        await disconnect();
      }
    } catch (e) {
      debugPrint('Error checking system devices: $e');
    }
  }

  // Connect to system-paired device
  Future<void> _connectToSystemDevice(BluetoothDevice device) async {
    try {
      _connectedDevice = device;
      _isConnected = true;
      notifyListeners();

      // Discover services
      debugPrint('🔍 Discovering services...');
      _services = await device.discoverServices();
      debugPrint('📋 Found ${_services?.length ?? 0} services');

      await _readDeviceInfo();
      await _subscribeToBatteryUpdates();
      _startRssiMonitoring();

      debugPrint('✅ Successfully connected to system device!');
    } catch (e) {
      debugPrint('❌ Error connecting to system device: $e');
      _isConnected = false;
      notifyListeners();
    }
  }

  // Read device information
  Future<void> _readDeviceInfo() async {
    if (_services == null) return;

    for (var service in _services!) {
      if (service.uuid.toString() == BLEConstants.deviceInfoServiceUUID) {
        for (var characteristic in service.characteristics) {
          try {
            if (characteristic.properties.read) {
              final value = await characteristic.read();
              final stringValue = String.fromCharCodes(value);

              if (characteristic.uuid.toString() ==
                  BLEConstants.modelNumberUUID) {
                _deviceModel = stringValue;
                debugPrint('📱 Model: $_deviceModel');
              } else if (characteristic.uuid.toString() ==
                  BLEConstants.firmwareRevisionUUID) {
                _firmwareVersion = stringValue;
                debugPrint('🔧 Firmware: $_firmwareVersion');
              }
            }
          } catch (e) {
            debugPrint('Error reading characteristic: $e');
          }
        }
      }
    }
    notifyListeners();
  }

  // Subscribe to battery updates
  Future<void> _subscribeToBatteryUpdates() async {
    if (_services == null) return;

    bool batteryFound = false;

    for (var service in _services!) {
      if (service.uuid.toString() == BLEConstants.batteryServiceUUID) {
        debugPrint('🔋 Found battery service!');
        batteryFound = true;

        for (var characteristic in service.characteristics) {
          try {
            // Read current value
            if (characteristic.properties.read) {
              final value = await characteristic.read();
              debugPrint('🔋 Raw battery data: $value');

              if (value.isNotEmpty) {
                // Parse battery data correctly
                // Most TWS earbuds return: [Case, Left, Right] or just [Case]
                _batteryCase = value[0];

                if (value.length >= 3) {
                  _batteryLeft = value[1];
                  _batteryRight = value[2];
                } else if (value.length == 2) {
                  _batteryLeft = value[1];
                  _batteryRight = value[1];
                } else {
                  // If only case battery, set pods to same value
                  _batteryLeft = value[0];
                  _batteryRight = value[0];
                }

                debugPrint(
                  '🔋 Battery - L:$_batteryLeft% R:$_batteryRight% C:$_batteryCase%',
                );
              }
            }

            // Subscribe to notifications for real-time updates
            if (characteristic.properties.notify) {
              await characteristic.setNotifyValue(true);
              characteristic.lastValueStream.listen((value) {
                if (value.isNotEmpty) {
                  _batteryCase = value[0];
                  if (value.length >= 3) {
                    _batteryLeft = value[1];
                    _batteryRight = value[2];
                  } else if (value.length == 2) {
                    _batteryLeft = value[1];
                    _batteryRight = value[1];
                  } else {
                    _batteryLeft = value[0];
                    _batteryRight = value[0];
                  }
                  debugPrint(
                    '🔋 Battery updated - L:$_batteryLeft% R:$_batteryRight% C:$_batteryCase%',
                  );
                  notifyListeners();
                }
              });
            }
          } catch (e) {
            debugPrint('Error subscribing to battery: $e');
          }
        }
      }
    }

    if (!batteryFound) {
      debugPrint('⚠️ No standard battery service found');
      // Try to find battery in other services
      await _tryAlternativeBatteryReading();
    }

    notifyListeners();
  }

  // Try alternative methods to read battery
  Future<void> _tryAlternativeBatteryReading() async {
    if (_services == null) return;

    for (var service in _services!) {
      debugPrint('Checking service: ${service.uuid}');
      for (var characteristic in service.characteristics) {
        try {
          if (characteristic.properties.read) {
            final value = await characteristic.read();
            // Look for battery-like values (0-100 range)
            if (value.isNotEmpty && value.every((b) => b >= 0 && b <= 100)) {
              debugPrint(
                '🔋 Found potential battery data: $value in ${characteristic.uuid}',
              );
              _batteryCase = value[0];
              if (value.length >= 3) {
                _batteryLeft = value[1];
                _batteryRight = value[2];
              } else {
                _batteryLeft = value[0];
                _batteryRight = value[0];
              }
              notifyListeners();
              return;
            }
          }
        } catch (e) {
          // Ignore read errors for characteristics that can't be read
        }
      }
    }
    debugPrint(
      '⚠️ No battery data found - device may not expose battery info via BLE',
    );
  }

  // Monitor RSSI (signal strength)
  void _startRssiMonitoring() {
    _rssiTimer?.cancel();
    _rssiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_isConnected && _connectedDevice != null) {
        try {
          _rssi = await _connectedDevice!.readRssi();
          notifyListeners();
        } catch (e) {
          debugPrint('Error reading RSSI: $e');
        }
      } else {
        timer.cancel();
      }
    });
  }

  // Disconnect
  Future<void> disconnect() async {
    _rssiTimer?.cancel();

    _connectedDevice = null;
    _isConnected = false;
    _services = null;
    _batteryLeft = 0;
    _batteryRight = 0;
    _batteryCase = 0;
    _rssi = -100;

    notifyListeners();
  }

  // Get signal strength text
  String getSignalStrength() {
    if (_rssi > -50) return 'Strong';
    if (_rssi > -70) return 'Medium';
    return 'Weak';
  }

  // Get signal color
  Color getSignalColor() {
    if (_rssi > -50) return Colors.green;
    if (_rssi > -70) return Colors.orange;
    return Colors.red;
  }

  @override
  void dispose() {
    _rssiTimer?.cancel();
    _checkConnectionTimer?.cancel();
    disconnect();
    super.dispose();
  }
}
