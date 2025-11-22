import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../l10n/app_localizations.dart';

class EQScreen extends StatefulWidget {
  const EQScreen({Key? key}) : super(key: key);

  @override
  State<EQScreen> createState() => _EQScreenState();
}

class _EQScreenState extends State<EQScreen> {
  String _selectedPreset = 'balanced';

  final Map<String, Map<String, dynamic>> _presets = {
    'bass': {
      'emoji': '🔊',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFEC407A)],
      ),
    },
    'vocal': {
      'emoji': '🎤',
      'gradient': const LinearGradient(
        colors: [Color(0xFFAB47BC), Color(0xFFEC407A)],
      ),
    },
    'mango': {
      'emoji': '🥭',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
      ),
    },
    'sea': {
      'emoji': '🌊',
      'gradient': const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
      ),
    },
    'balanced': {
      'emoji': '🌻',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFFEB3B), Color(0xFFFDD835)],
      ),
    },
  };

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
                      localizations.soundProfiles,
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

              // Disclaimer Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.shade400, width: 2),
                ),
                child: Column(
                  children: [
                    Text(
                      localizations.eqDisclaimer,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      localizations.eqNote,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildPresetCard(
                      'bass',
                      localizations.translate('bass_boost'),
                    ),
                    _buildPresetCard(
                      'vocal',
                      localizations.translate('vocal_clarity'),
                    ),
                    _buildPresetCard(
                      'mango',
                      localizations.translate('mango_warmth'),
                    ),
                    _buildPresetCard(
                      'sea',
                      localizations.translate('sea_breeze'),
                    ),
                    _buildPresetCard(
                      'balanced',
                      localizations.translate('sunflower_balance'),
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

  Widget _buildPresetCard(String key, String name) {
    final localizations = AppLocalizations.of(context);
    final isSelected = _selectedPreset == key;
    final preset = _presets[key]!;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPreset = key);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${preset['emoji']} $name ${localizations.translate('activated')}',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: preset['gradient'],
          borderRadius: BorderRadius.circular(25),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(preset['emoji'], style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 30),
          ],
        ),
      ),
    );
  }
}
