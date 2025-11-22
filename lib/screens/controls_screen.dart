import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';

class ControlsScreen extends StatelessWidget {
  const ControlsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      localizations.touchControls,
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
                    _buildControlCard(
                      title: localizations.translate('sunflower_tap'),
                      description: localizations.translate('single_tap'),
                      action: localizations.translate('play_pause'),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlCard(
                      title: localizations.translate('mango_double'),
                      description: localizations.translate('double_tap'),
                      action: localizations.translate('next_track'),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9800), Color(0xFFEC407A)],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlCard(
                      title: localizations.translate('violet_trio'),
                      description: localizations.translate('triple_tap'),
                      action: localizations.translate('previous_track'),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFAB47BC), Color(0xFFEC407A)],
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildControlCard(
                      title: localizations.translate('sea_wave_hold'),
                      description: localizations.translate('long_press'),
                      action: localizations.translate('voice_assistant'),
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
