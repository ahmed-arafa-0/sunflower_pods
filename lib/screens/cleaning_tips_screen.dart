import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CleaningTipsScreen extends StatelessWidget {
  const CleaningTipsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final tips = [
      {
        'title': 'Give your sunflowers some love 💛',
        'description':
            'Gently wipe earbuds with a soft, dry cloth after each use.',
        'icon': Icons.cleaning_services,
      },
      {
        'title': 'Keep those mango vibes crystal clear 🥭',
        'description': 'Use a cotton swab to clean the mesh screens carefully.',
        'icon': Icons.sanitizer,
      },
      {
        'title': 'Protect your violet dreams 💜',
        'description':
            'Avoid water and cleaning solutions directly on the earbuds.',
        'icon': Icons.water_drop_outlined,
      },
      {
        'title': 'Clear sea, clear sound 🌊',
        'description': 'Clean the charging case regularly with a soft brush.',
        'icon': Icons.brush,
      },
      {
        'title': 'Store with care 🌻',
        'description':
            'Always keep your Funpods in their case when not in use.',
        'icon': Icons.cases_rounded,
      },
    ];

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
                      'Cleaning & Care Tips',
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
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index];
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: themeProvider.currentTheme.accentColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              tip['icon'] as IconData,
                              color: themeProvider.currentTheme.accentColor,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tip['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tip['description'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
