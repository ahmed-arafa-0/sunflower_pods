import 'package:flutter/material.dart';

class EarbudDisplay extends StatelessWidget {
  final int batteryLeft;
  final int batteryRight;
  final int batteryCase;
  final bool isAnimating;

  const EarbudDisplay({
    Key? key,
    required this.batteryLeft,
    required this.batteryRight,
    required this.batteryCase,
    this.isAnimating = false,
  }) : super(key: key);

  Color _getBatteryColor(int level) {
    if (level > 50) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                _buildBatteryBadge(batteryLeft),
              ],
            ),
          ),
          // Case
          _buildCaseVisual(),
          // Right Earbud
          Positioned(
            right: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEarbudVisual(),
                const SizedBox(height: 8),
                _buildBatteryBadge(batteryRight),
              ],
            ),
          ),
        ],
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

  Widget _buildCaseVisual() {
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
          '$batteryCase%',
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
}
