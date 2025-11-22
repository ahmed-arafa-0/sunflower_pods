import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/ble_provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';

class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bleProvider = Provider.of<BLEProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAFAFA), Color(0xFFE0E0E0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: themeProvider.currentTheme.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      localizations.deviceInfo,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildInfoCard(
                      localizations.translate('device_name'),
                      bleProvider.connectedDevice?.platformName ?? 'Unknown',
                      Icons.headset,
                    ),
                    _buildInfoCard(
                      localizations.translate('device_id'),
                      bleProvider.connectedDevice?.remoteId.toString() ?? 'N/A',
                      Icons.fingerprint,
                    ),
                    _buildInfoCard(
                      localizations.translate('model'),
                      bleProvider.deviceModel.isEmpty
                          ? 'Jayroom Funpods 2'
                          : bleProvider.deviceModel,
                      Icons.phone_android,
                    ),
                    _buildInfoCard(
                      localizations.translate('firmware'),
                      bleProvider.firmwareVersion.isEmpty
                          ? 'Unknown'
                          : bleProvider.firmwareVersion,
                      Icons.system_update,
                    ),
                    _buildInfoCard(
                      localizations.translate('connection_status'),
                      bleProvider.isConnected
                          ? '${localizations.connected} ✅'
                          : '${localizations.disconnected} ❌',
                      Icons.bluetooth_connected,
                    ),
                    _buildInfoCard(
                      localizations.translate('signal_strength'),
                      '${bleProvider.rssi} dBm (${bleProvider.getSignalStrength()})',
                      Icons.signal_cellular_alt,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        final info =
                            '''
Device: ${bleProvider.connectedDevice?.platformName}
ID: ${bleProvider.connectedDevice?.remoteId}
Model: ${bleProvider.deviceModel}
Firmware: ${bleProvider.firmwareVersion}
RSSI: ${bleProvider.rssi} dBm
Batteries: L:${bleProvider.batteryLeft}% R:${bleProvider.batteryRight}% C:${bleProvider.batteryCase}%
                        ''';

                        Clipboard.setData(ClipboardData(text: info));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              localizations.translate('info_copied'),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: Text(localizations.translate('copy_device_info')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.currentTheme.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
