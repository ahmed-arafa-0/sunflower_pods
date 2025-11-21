import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/ble_provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import 'find_screen.dart';
import 'controls_screen.dart';
import 'eq_screen.dart';
import 'device_info_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final bleProvider = Provider.of<BLEProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMMM d, y').format(now);

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
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: themeProvider.currentTheme.primaryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hello Sunshine ☀️',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Cursive',
                            ),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Earbuds Display Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Left Earbud
                          Positioned(
                            left: 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEarbudVisual(),
                                const SizedBox(height: 8),
                                _buildBatteryBadge(bleProvider.batteryLeft),
                              ],
                            ),
                          ),
                          // Case
                          _buildCaseVisual(bleProvider.batteryCase),
                          // Right Earbud
                          Positioned(
                            right: 20,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildEarbudVisual(),
                                const SizedBox(height: 8),
                                _buildBatteryBadge(bleProvider.batteryRight),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Signal Strength
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: bleProvider.getSignalColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${bleProvider.getSignalStrength()} Signal',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Battery Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildBatteryCard(
                        'Left',
                        bleProvider.batteryLeft,
                        Icons.headset,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBatteryCard(
                        'Right',
                        bleProvider.batteryRight,
                        Icons.headset,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildBatteryCard(
                        'Case',
                        bleProvider.batteryCase,
                        Icons.cases_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Quick Actions
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildActionCard(
                        context,
                        'Find My Pods',
                        Icons.location_on,
                        themeProvider.currentTheme.primaryGradient,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FindScreen()),
                        ),
                      ),
                      _buildActionCard(
                        context,
                        'Controls',
                        Icons.touch_app,
                        themeProvider.currentTheme.secondaryGradient,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ControlsScreen(),
                          ),
                        ),
                      ),
                      _buildActionCard(
                        context,
                        'Sound EQ',
                        Icons.graphic_eq,
                        const LinearGradient(
                          colors: [Color(0xFFEC407A), Color(0xFFAB47BC)],
                        ),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EQScreen()),
                        ),
                      ),
                      _buildActionCard(
                        context,
                        'Device Info',
                        Icons.info_outline,
                        const LinearGradient(
                          colors: [Color(0xFF757575), Color(0xFF424242)],
                        ),
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DeviceInfoScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FindScreen()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EQScreen()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: themeProvider.currentTheme.accentColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: 'Find',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.equalizer), label: 'EQ'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarbudVisual() {
    return Container(
      width: 60,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[800]!, Colors.grey[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildCaseVisual(int battery) {
    return Container(
      width: 120,
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[700]!, Colors.grey[800]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$battery%',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryBadge(int battery) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getBatteryColor(battery),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$battery%',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBatteryCard(String label, int battery, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _getBatteryColor(battery), size: 28),
          const SizedBox(height: 8),
          Text(
            '$battery%',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Gradient gradient,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBatteryColor(int battery) {
    if (battery > 50) return Colors.green;
    if (battery > 20) return Colors.orange;
    return Colors.red;
  }
}
