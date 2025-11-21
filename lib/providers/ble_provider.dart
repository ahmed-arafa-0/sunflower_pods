import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import '../models/earbud_data.dart';
import '../utils/constants.dart';

class BLEProvider extends ChangeNotifier {
  BluetoothDevice? _connectedDevice;
  List<BluetoothService>? _services;
  bool _isScanning = false;
  bool _isConnected = false;
  int _batteryLeft = 0;
  int _batteryRight = 0;
  int _batteryCase = 0;
  int _rssi = -100;
  List<ScanResult> _scanResults = [];
  List<ScanResult> _allScanResults = []; // All scanned devices for debugging
  List<BluetoothDevice> _systemConnectedDevices = []; // System-paired devices
  Timer? _rssiTimer;
  String _deviceModel = '';
  String _firmwareVersion = '';

  // Getters
  BluetoothDevice? get connectedDevice => _connectedDevice;
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  int get batteryLeft => _batteryLeft;
  int get batteryRight => _batteryRight;
  int get batteryCase => _batteryCase;
  int get rssi => _rssi;
  List<ScanResult> get scanResults => _scanResults;
  List<ScanResult> get allScanResults => _allScanResults; // For debugging
  List<BluetoothDevice> get systemConnectedDevices => _systemConnectedDevices;
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

  // Check if Bluetooth is available
  Future<bool> isBluetoothAvailable() async {
    try {
      return await FlutterBluePlus.isAvailable;
    } catch (e) {
      debugPrint('Error checking Bluetooth: $e');
      return false;
    }
  }

  // Get system-connected (bonded/paired) devices
  Future<void> getSystemConnectedDevices() async {
    try {
      debugPrint('🔍 Checking for system-connected devices...');

      // Get bonded devices (devices paired through system settings)
      final bondedDevices = await FlutterBluePlus.bondedDevices;

      debugPrint('📱 Found ${bondedDevices.length} system-paired devices:');
      for (var device in bondedDevices) {
        debugPrint('  - Name: "${device.platformName}"');
        debugPrint('    ID: ${device.remoteId}');
      }

      _systemConnectedDevices = bondedDevices;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error getting bonded devices: $e');
    }
  }

  // Start scanning for devices
  Future<void> startScan() async {
    _isScanning = true;
    _scanResults.clear();
    _allScanResults.clear();
    notifyListeners();

    try {
      // First, check for system-connected devices
      await getSystemConnectedDevices();

      // Check if already scanning
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      debugPrint('🔍 Starting BLE scan...');

      // Start scan
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
      );

      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        _allScanResults = results; // Store all results
        debugPrint('📱 Scan found ${results.length} advertising devices');

        _scanResults = results;
        notifyListeners();
      });

      // Wait for scan to complete
      await Future.delayed(const Duration(seconds: 15));
    } catch (e) {
      debugPrint('❌ Error scanning: $e');
    }

    _isScanning = false;
    notifyListeners();
  }

  // Stop scanning
  Future<void> stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (e) {
      debugPrint('Error stopping scan: $e');
    }
    _isScanning = false;
    notifyListeners();
  }

  // Connect to device
  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      debugPrint(
        '🔗 Attempting to connect to: ${device.platformName} (${device.remoteId})',
      );

      // Disconnect from any existing device
      if (_connectedDevice != null) {
        await disconnect();
      }

      // Check if already connected
      final connectionState = await device.connectionState.first;
      debugPrint('Current connection state: $connectionState');

      if (connectionState == BluetoothConnectionState.connected) {
        debugPrint('✅ Device already connected via system!');
      } else {
        // Connect to device
        debugPrint('Connecting...');
        await device.connect(
          timeout: const Duration(seconds: 15),
          autoConnect: false,
        );
        debugPrint('✅ Connected successfully!');
      }

      _connectedDevice = device;
      _isConnected = true;
      notifyListeners();

      // Discover services
      debugPrint('🔍 Discovering services...');
      _services = await device.discoverServices();
      debugPrint('📋 Found ${_services?.length ?? 0} services');

      // Debug: Print all services
      for (var service in _services ?? []) {
        debugPrint('  Service: ${service.uuid}');
        for (var char in service.characteristics) {
          debugPrint('    Characteristic: ${char.uuid}');
          debugPrint(
            '      Properties - Read: ${char.properties.read}, Notify: ${char.properties.notify}, Write: ${char.properties.write}',
          );
        }
      }

      await _readDeviceInfo();
      await _subscribeToBatteryUpdates();
      _startRssiMonitoring();

      return true;
    } catch (e) {
      debugPrint('❌ Error connecting: $e');
      _isConnected = false;
      notifyListeners();
      return false;
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
              debugPrint('🔋 Battery value: $value');
              if (value.isNotEmpty) {
                _batteryCase = value[0];

                // Try to parse left/right if available
                if (value.length >= 3) {
                  _batteryLeft = value[1];
                  _batteryRight = value[2];
                  debugPrint(
                    '🔋 L:$_batteryLeft% R:$_batteryRight% C:$_batteryCase%',
                  );
                } else {
                  // Simulate for demo
                  _batteryLeft = value[0] - 5;
                  _batteryRight = value[0] - 3;
                  debugPrint(
                    '🔋 Simulated - L:$_batteryLeft% R:$_batteryRight% C:$_batteryCase%',
                  );
                }
              }
            }

            // Subscribe to notifications
            if (characteristic.properties.notify) {
              await characteristic.setNotifyValue(true);
              characteristic.lastValueStream.listen((value) {
                if (value.isNotEmpty) {
                  _batteryCase = value[0];
                  if (value.length >= 3) {
                    _batteryLeft = value[1];
                    _batteryRight = value[2];
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
      debugPrint('⚠️ No battery service found. Using simulated values.');
      // Use simulated values for demo
      _batteryLeft = 85;
      _batteryRight = 87;
      _batteryCase = 90;
    }

    notifyListeners();
  }

  // Monitor RSSI
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

    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.disconnect();
      } catch (e) {
        debugPrint('Error disconnecting: $e');
      }
    }

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

  // Get proximity text for Find feature
  String getProximityText() {
    if (_rssi > -50) return AppStrings.findHot;
    if (_rssi > -70) return AppStrings.findWarm;
    return AppStrings.findCold;
  }

  @override
  void dispose() {
    _rssiTimer?.cancel();
    disconnect();
    super.dispose();
  }
}
