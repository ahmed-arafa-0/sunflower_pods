import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class EQScreen extends StatefulWidget {
  const EQScreen({Key? key}) : super(key: key);

  @override
  State<EQScreen> createState() => _EQScreenState();
}

class _EQScreenState extends State<EQScreen> {
  String _selectedPreset = 'balanced';

  final Map<String, Map<String, dynamic>> _presets = {
    'bass': {
      'name': 'Bass Boost',
      'emoji': '🔊',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFEC407A)],
      ),
    },
    'vocal': {
      'name': 'Vocal Clarity',
      'emoji': '🎤',
      'gradient': const LinearGradient(
        colors: [Color(0xFFAB47BC), Color(0xFFEC407A)],
      ),
    },
    'mango': {
      'name': 'Mango Warmth',
      'emoji': '🥭',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
      ),
    },
    'sea': {
      'name': 'Sea Breeze',
      'emoji': '🌊',
      'gradient': const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
      ),
    },
    'balanced': {
      'name': 'Sunflower Balance',
      'emoji': '🌻',
      'gradient': const LinearGradient(
        colors: [Color(0xFFFFEB3B), Color(0xFFFDD835)],
      ),
    },
  };

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
                      'Sound Profiles',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _presets.length,
                  itemBuilder: (context, index) {
                    final entry = _presets.entries.elementAt(index);
                    final isSelected = _selectedPreset == entry.key;

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedPreset = entry.key);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${entry.value['emoji']} ${entry.value['name']} activated!',
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
                          gradient: entry.value['gradient'],
                          borderRadius: BorderRadius.circular(25),
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
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
                            Text(
                              entry.value['emoji'],
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                entry.value['name'],
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 30,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
