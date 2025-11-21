import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ControlsScreen extends StatelessWidget {
  const ControlsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
                    const Text(
                      'Touch Controls',
                      style: TextStyle(
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
                    _buildControlCard(
                      title: 'Sunflower Tap 🌻',
                      description: 'Single tap',
                      action: 'Play / Pause music',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlCard(
                      title: 'Mango Double 🥭',
                      description: 'Double tap',
                      action: 'Next track',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9800), Color(0xFFEC407A)],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlCard(
                      title: 'Violet Trio 💜',
                      description: 'Triple tap',
                      action: 'Previous track',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFAB47BC), Color(0xFFEC407A)],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlCard(
                      title: 'Sea Wave Hold 🌊',
                      description: 'Long press',
                      action: 'Voice assistant',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
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

  Widget _buildControlCard({
    required String title,
    required String description,
    required String action,
    required Gradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              '→ $action',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// 17. lib/screens/eq_screen.dart
// ============================================================================
