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
    // Check immediately on start
    Future.delayed(const Duration(milliseconds: 500), () {
      checkSystemConnectedDevices();
    });

    // Then check every 3 seconds
    _checkConnectionTimer?.cancel();
    _checkConnectionTimer = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) async {
      if (!_isConnected) {
        debugPrint('⏰ Checking for Funpods... (${DateTime.now().second}s)');
      }
      await checkSystemConnectedDevices();
    });
  }

  // Helper to check if device is Funpods
  bool _isFunpodsDevice(BluetoothDevice device) {
    final name = device.platformName.toLowerCase();
    final isFunpods = BLEConstants.deviceNamePatterns.any(
      (pattern) => name.contains(pattern.toLowerCase()),
    );
    return isFunpods;
  }

  // Check for system-connected Funpods (ENHANCED VERSION)
  Future<void> checkSystemConnectedDevices() async {
    if (_isConnected) {
      // Already connected, just verify it's still connected
      if (_connectedDevice != null) {
        try {
          final state = await _connectedDevice!.connectionState.first.timeout(
            const Duration(seconds: 2),
          );
          if (state != BluetoothConnectionState.connected) {
            debugPrint('⚠️ Device disconnected');
            await disconnect();
          }
        } catch (e) {
          debugPrint('⚠️ Lost connection: $e');
          await disconnect();
        }
      }
      return;
    }

    try {
      debugPrint('🔍 Checking for system-connected devices...');

      // METHOD 1: Check system devices (most reliable on some phones)
      try {
        final systemDevices = await FlutterBluePlus.systemDevices([]);
        debugPrint('📱 System devices: ${systemDevices.length}');

        for (var device in systemDevices) {
          final name = device.platformName.isNotEmpty
              ? device.platformName
              : 'Unknown';
          debugPrint('  System: "$name" (${device.remoteId})');

          if (_isFunpodsDevice(device)) {
            debugPrint('✅ Found Funpods in system devices!');
            await _connectToSystemDevice(device);
            return;
          }
        }
      } catch (e) {
        debugPrint('⚠️ System devices error: $e');
      }

      // METHOD 2: Check connected devices (most reliable on other phones)
      try {
        final connectedDevices = FlutterBluePlus.connectedDevices;
        debugPrint('📱 Connected devices: ${connectedDevices.length}');

        for (var device in connectedDevices) {
          final name = device.platformName.isNotEmpty
              ? device.platformName
              : 'Unknown';
          debugPrint('  Connected: "$name" (${device.remoteId})');

          if (_isFunpodsDevice(device)) {
            debugPrint('✅ Found Funpods in connected devices!');
            await _connectToSystemDevice(device);
            return;
          }
        }
      } catch (e) {
        debugPrint('⚠️ Connected devices error: $e');
      }

      // METHOD 3: Check bonded devices (Android)
      try {
        final bondedDevices = await FlutterBluePlus.bondedDevices;
        debugPrint('📱 Bonded/Paired devices: ${bondedDevices.length}');

        for (var device in bondedDevices) {
          final name = device.platformName.isNotEmpty
              ? device.platformName
              : 'Unknown';
          debugPrint('  Bonded: "$name" (${device.remoteId})');

          if (_isFunpodsDevice(device)) {
            debugPrint('✅ Found Funpods in bonded devices!');
            // Try to connect to the device
            try {
              final state = await device.connectionState.first.timeout(
                const Duration(seconds: 2),
              );
              debugPrint('  Current connection state: $state');

              if (state == BluetoothConnectionState.connected) {
                debugPrint('✅ Device already connected! Proceeding...');
                await _connectToSystemDevice(device);
                return;
              } else {
                debugPrint(
                  '⚠️ Device bonded but not connected, attempting to connect...',
                );
                // Try to connect it ourselves
                try {
                  await device.connect(timeout: const Duration(seconds: 10));
                  debugPrint('✅ Successfully connected! Proceeding...');
                  await _connectToSystemDevice(device);
                  return;
                } catch (connectError) {
                  debugPrint('❌ Failed to connect: $connectError');
                  debugPrint(
                    '   Please connect the device in Bluetooth settings first',
                  );
                }
              }
            } catch (e) {
              debugPrint('⚠️ Error checking/connecting: $e');
              // Try connecting anyway
              try {
                debugPrint('  Attempting direct connection...');
                await device.connect(timeout: const Duration(seconds: 10));
                debugPrint('✅ Direct connection successful!');
                await _connectToSystemDevice(device);
                return;
              } catch (directConnectError) {
                debugPrint('❌ Direct connection failed: $directConnectError');
              }
            }
          }
        }
      } catch (e) {
        debugPrint('⚠️ Bonded devices error: $e');
      }

      // If we got here, no Funpods found
      if (!_isConnected) {
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
        debugPrint('⚠️ No Funpods detected. Please ensure:');
        debugPrint('   1. Funpods are turned on');
        debugPrint('   2. Paired in phone Bluetooth settings');
        debugPrint('   3. Currently CONNECTED (not just paired)');
        debugPrint(
          '   4. Device name contains: ${BLEConstants.deviceNamePatterns.join(", ")}',
        );
        debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }
    } catch (e) {
      debugPrint('❌ Fatal error checking devices: $e');
    }
  }

  // Connect to system-paired device
  Future<void> _connectToSystemDevice(BluetoothDevice device) async {
    try {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🔗 Connecting to: ${device.platformName}');
      debugPrint('   Device ID: ${device.remoteId}');

      // Check current connection state first
      final currentState = await device.connectionState.first
          .timeout(const Duration(seconds: 2))
          .catchError((e) {
            debugPrint('⚠️ Could not get connection state: $e');
            return BluetoothConnectionState.disconnected;
          });

      debugPrint('   Current state: $currentState');

      // If not connected, try to connect
      if (currentState != BluetoothConnectionState.connected) {
        debugPrint('   Attempting connection...');
        try {
          await device.connect(
            timeout: const Duration(seconds: 15),
            autoConnect: false,
          );
          debugPrint('   ✅ Connection established!');
        } catch (connectError) {
          debugPrint('   ❌ Connection failed: $connectError');
          // Try to continue anyway in case it's a false error
        }
      }

      _connectedDevice = device;
      _isConnected = true;
      notifyListeners();

      // Discover services
      debugPrint('🔍 Discovering services...');
      try {
        _services = await device.discoverServices().timeout(
          const Duration(seconds: 15),
        );
        debugPrint('📋 Found ${_services?.length ?? 0} services');

        // Debug: Print all services
        for (var service in _services ?? []) {
          debugPrint('  📦 Service: ${service.uuid}');
        }
      } catch (serviceError) {
        debugPrint('❌ Service discovery failed: $serviceError');
        // Continue anyway, we might still be connected
      }

      await _readDeviceInfo();
      await _subscribeToBatteryUpdates();
      _startRssiMonitoring();

      debugPrint('✅ Successfully connected and initialized!');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    } catch (e) {
      debugPrint('❌ Fatal error in _connectToSystemDevice: $e');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      _isConnected = false;
      _connectedDevice = null;
      notifyListeners();
    }
  }

  // Read device information
  Future<void> _readDeviceInfo() async {
    if (_services == null) return;

    for (var service in _services!) {
      if (service.uuid.toString() == BLEConstants.deviceInfoServiceUUID) {
        debugPrint('📱 Found Device Info service');
        for (var characteristic in service.characteristics) {
          try {
            if (characteristic.properties.read) {
              final value = await characteristic.read();
              final stringValue = String.fromCharCodes(value);

              if (characteristic.uuid.toString() ==
                  BLEConstants.modelNumberUUID) {
                _deviceModel = stringValue;
                debugPrint('  Model: $_deviceModel');
              } else if (characteristic.uuid.toString() ==
                  BLEConstants.firmwareRevisionUUID) {
                _firmwareVersion = stringValue;
                debugPrint('  Firmware: $_firmwareVersion');
              }
            }
          } catch (e) {
            debugPrint('  Error reading characteristic: $e');
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
        debugPrint('🔋 Found Battery service!');
        batteryFound = true;

        for (var characteristic in service.characteristics) {
          try {
            debugPrint('  🔋 Characteristic: ${characteristic.uuid}');
            debugPrint('     Read: ${characteristic.properties.read}');
            debugPrint('     Notify: ${characteristic.properties.notify}');

            // Read current value
            if (characteristic.properties.read) {
              final value = await characteristic.read();
              debugPrint('  🔋 Raw data: $value (length: ${value.length})');

              if (value.isNotEmpty) {
                // Parse battery data
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
                  '  🔋 Parsed - L:$_batteryLeft% R:$_batteryRight% C:$_batteryCase%',
                );
              }
            }

            // Subscribe to notifications for real-time updates
            if (characteristic.properties.notify) {
              await characteristic.setNotifyValue(true);
              debugPrint('  🔔 Subscribed to battery notifications');

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
                    '🔋 Battery update - L:$_batteryLeft% R:$_batteryRight% C:$_batteryCase%',
                  );
                  notifyListeners();
                }
              });
            }
          } catch (e) {
            debugPrint('  ⚠️ Error with battery characteristic: $e');
          }
        }
      }
    }

    if (!batteryFound) {
      debugPrint('⚠️ No standard battery service found');
      debugPrint('   Trying alternative services...');
      await _tryAlternativeBatteryReading();
    }

    notifyListeners();
  }

  // Try alternative methods to read battery
  Future<void> _tryAlternativeBatteryReading() async {
    if (_services == null) return;

    for (var service in _services!) {
      for (var characteristic in service.characteristics) {
        try {
          if (characteristic.properties.read) {
            final value = await characteristic.read();
            // Look for battery-like values (0-100 range)
            if (value.isNotEmpty &&
                value.length <= 3 &&
                value.every((b) => b >= 0 && b <= 100)) {
              debugPrint(
                '🔋 Potential battery in ${characteristic.uuid}: $value',
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
          // Ignore errors for characteristics that can't be read
        }
      }
    }

    debugPrint('⚠️ No battery data found via BLE');
    debugPrint('   Note: Some earbuds don\'t expose battery over BLE');
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
    debugPrint('🔌 Disconnecting...');
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
