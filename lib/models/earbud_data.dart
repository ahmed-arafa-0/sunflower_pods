class EarbudData {
  final int batteryLeft;
  final int batteryRight;
  final int batteryCase;
  final int rssi;
  final bool isConnected;
  final String deviceName;
  final String deviceId;
  final DateTime lastUpdated;

  EarbudData({
    required this.batteryLeft,
    required this.batteryRight,
    required this.batteryCase,
    required this.rssi,
    required this.isConnected,
    required this.deviceName,
    required this.deviceId,
    required this.lastUpdated,
  });

  EarbudData copyWith({
    int? batteryLeft,
    int? batteryRight,
    int? batteryCase,
    int? rssi,
    bool? isConnected,
    String? deviceName,
    String? deviceId,
    DateTime? lastUpdated,
  }) {
    return EarbudData(
      batteryLeft: batteryLeft ?? this.batteryLeft,
      batteryRight: batteryRight ?? this.batteryRight,
      batteryCase: batteryCase ?? this.batteryCase,
      rssi: rssi ?? this.rssi,
      isConnected: isConnected ?? this.isConnected,
      deviceName: deviceName ?? this.deviceName,
      deviceId: deviceId ?? this.deviceId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
