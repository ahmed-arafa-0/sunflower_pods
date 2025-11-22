// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/ble_provider.dart';
// import '../providers/theme_provider.dart';
// import '../providers/notification_provider.dart';
// import 'home_screen.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ConnectionScreen extends StatefulWidget {
//   const ConnectionScreen({Key? key}) : super(key: key);

//   @override
//   State<ConnectionScreen> createState() => _ConnectionScreenState();
// }

// class _ConnectionScreenState extends State<ConnectionScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   bool _isSearching = false;
//   bool _showAllDevices = false; // Toggle to show all devices

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 2),
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _requestPermissions() async {
//     await [
//       Permission.bluetooth,
//       Permission.bluetoothScan,
//       Permission.bluetoothConnect,
//       Permission.location,
//       Permission.notification,
//     ].request();
//   }

//   Future<void> _startSearch() async {
//     await _requestPermissions();

//     setState(() => _isSearching = true);

//     final bleProvider = Provider.of<BLEProvider>(context, listen: false);
//     await bleProvider.startScan();

//     setState(() => _isSearching = false);
//   }

//   Future<void> _connectToDevice(device) async {
//     final bleProvider = Provider.of<BLEProvider>(context, listen: false);
//     final notificationProvider = Provider.of<NotificationProvider>(
//       context,
//       listen: false,
//     );
//     final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

//     final success = await bleProvider.connectToDevice(device);

//     if (success) {
//       await notificationProvider.showNotification(
//         title: 'Connected!',
//         body: themeProvider.getConnectedMessage(),
//         emoji: themeProvider.currentTheme.emoji,
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to connect. Please try again.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final bleProvider = Provider.of<BLEProvider>(context);

//     // Use filtered or all devices based on toggle
//     final devicesToShow = _showAllDevices
//         ? bleProvider.allScanResults
//         : bleProvider.scanResults;

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: themeProvider.currentTheme.primaryGradient,
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 60),
//               AnimatedBuilder(
//                 animation: _controller,
//                 builder: (context, child) {
//                   return Transform.scale(
//                     scale: _isSearching ? 1.0 + (_controller.value * 0.2) : 1.0,
//                     child: Text(
//                       themeProvider.currentTheme.emoji,
//                       style: const TextStyle(fontSize: 120),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 40),
//               Text(
//                 _isSearching
//                     ? 'Planting sunflower seeds of connection...'
//                     : 'Ready to Connect',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 40),
//                 child: Text(
//                   'Looking for your Jayroom Funpods 2',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Debug toggle
//               if (bleProvider.allScanResults.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           'Show All Devices',
//                           style: TextStyle(color: Colors.white, fontSize: 14),
//                         ),
//                         Switch(
//                           value: _showAllDevices,
//                           onChanged: (value) {
//                             setState(() => _showAllDevices = value);
//                           },
//                           activeColor: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 20),
//               if (!_isSearching && devicesToShow.isEmpty)
//                 ElevatedButton.icon(
//                   onPressed: _startSearch,
//                   icon: const Icon(Icons.bluetooth_searching),
//                   label: const Text('Start Searching'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.grey[800],
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 20,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     elevation: 8,
//                   ),
//                 ),
//               if (_isSearching)
//                 const CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               const SizedBox(height: 20),
//               if (devicesToShow.isNotEmpty)
//                 Expanded(
//                   child: Container(
//                     margin: const EdgeInsets.all(20),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.95),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${themeProvider.currentTheme.emoji} ${_showAllDevices ? "All" : "Matched"} Devices (${devicesToShow.length})',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             if (!_isSearching)
//                               IconButton(
//                                 icon: const Icon(Icons.refresh),
//                                 onPressed: _startSearch,
//                                 tooltip: 'Refresh',
//                               ),
//                           ],
//                         ),
//                         const SizedBox(height: 15),
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: devicesToShow.length,
//                             itemBuilder: (context, index) {
//                               final result = devicesToShow[index];
//                               final deviceName =
//                                   result.device.platformName.isNotEmpty
//                                   ? result.device.platformName
//                                   : 'Unknown Device';

//                               return Card(
//                                 margin: const EdgeInsets.only(bottom: 10),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: ListTile(
//                                   leading: const Icon(
//                                     Icons.headset,
//                                     size: 40,
//                                     color: Colors.blue,
//                                   ),
//                                   title: Text(
//                                     deviceName,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   subtitle: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Signal: ${result.rssi} dBm',
//                                         style: TextStyle(
//                                           color: Colors.grey[600],
//                                           fontSize: 12,
//                                         ),
//                                       ),
//                                       Text(
//                                         'ID: ${result.device.remoteId.toString().substring(0, 17)}...',
//                                         style: TextStyle(
//                                           color: Colors.grey[500],
//                                           fontSize: 10,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   trailing: ElevatedButton(
//                                     onPressed: () =>
//                                         _connectToDevice(result.device),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: themeProvider
//                                           .currentTheme
//                                           .accentColor,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(20),
//                                       ),
//                                     ),
//                                     child: const Text('Connect'),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
