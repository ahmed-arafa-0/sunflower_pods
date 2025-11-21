import 'package:flutter/material.dart';

class BatteryCard extends StatelessWidget {
  final String label;
  final int batteryLevel;
  final IconData icon;

  const BatteryCard({
    Key? key,
    required this.label,
    required this.batteryLevel,
    required this.icon,
  }) : super(key: key);

  Color _getBatteryColor() {
    if (batteryLevel > 50) return Colors.green;
    if (batteryLevel > 20) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
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
          Icon(icon, color: _getBatteryColor(), size: 28),
          const SizedBox(height: 8),
          Text(
            '$batteryLevel%',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
