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

  // Start scanning for devices
  Future<void> startScan() async {
    _isScanning = true;
    _scanResults.clear();
    notifyListeners();

    try {
      // Check if already scanning
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      // Start scan
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        androidUsesFineLocation: true,
      );

      // Listen to scan results
      FlutterBluePlus.scanResults.listen((results) {
        _scanResults = results.where((result) {
          final name = result.device.platformName.toLowerCase();
          return BLEConstants.deviceNamePatterns.any(
            (pattern) => name.contains(pattern.toLowerCase()),
          );
        }).toList();
        notifyListeners();
      });

      // Wait for scan to complete
      await Future.delayed(const Duration(seconds: 15));
    } catch (e) {
      debugPrint('Error scanning: $e');
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
      // Disconnect from any existing device
      if (_connectedDevice != null) {
        await disconnect();
      }

      // Connect to device
      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );

      _connectedDevice = device;
      _isConnected = true;
      notifyListeners();

      // Discover services
      _services = await device.discoverServices();
      await _readDeviceInfo();
      await _subscribeToBatteryUpdates();
      _startRssiMonitoring();

      return true;
    } catch (e) {
      debugPrint('Error connecting: $e');
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
              } else if (characteristic.uuid.toString() ==
                  BLEConstants.firmwareRevisionUUID) {
                _firmwareVersion = stringValue;
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

    for (var service in _services!) {
      if (service.uuid.toString() == BLEConstants.batteryServiceUUID) {
        for (var characteristic in service.characteristics) {
          try {
            // Read current value
            if (characteristic.properties.read) {
              final value = await characteristic.read();
              if (value.isNotEmpty) {
                _batteryCase = value[0];

                // Try to parse left/right if available
                if (value.length >= 3) {
                  _batteryLeft = value[1];
                  _batteryRight = value[2];
                } else {
                  // Simulate for demo
                  _batteryLeft = value[0] - 5;
                  _batteryRight = value[0] - 3;
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
