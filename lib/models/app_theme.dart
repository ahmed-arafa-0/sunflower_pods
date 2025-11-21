import 'package:flutter/material.dart';

class AppTheme {
  final String id;
  final String name;
  final Gradient primaryGradient;
  final Gradient secondaryGradient;
  final Color accentColor;
  final String emoji;
  final Color backgroundColor;

  AppTheme({
    required this.id,
    required this.name,
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.accentColor,
    required this.emoji,
    required this.backgroundColor,
  });

  static final Map<String, AppTheme> themes = {
    'sunflower': AppTheme(
      id: 'sunflower',
      name: 'Sunflower',
      primaryGradient: const LinearGradient(
        colors: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      secondaryGradient: const LinearGradient(
        colors: [Color(0xFFFFEB3B), Color(0xFFFDD835)],
      ),
      accentColor: const Color(0xFFFFB800),
      emoji: '🌻',
      backgroundColor: const Color(0xFFFFFDE7),
    ),
    'sea': AppTheme(
      id: 'sea',
      name: 'Sea',
      primaryGradient: const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      secondaryGradient: const LinearGradient(
        colors: [Color(0xFF00BCD4), Color(0xFF2196F3)],
      ),
      accentColor: const Color(0xFF00B8D4),
      emoji: '🌊',
      backgroundColor: const Color(0xFFE0F7FA),
    ),
    'mango': AppTheme(
      id: 'mango',
      name: 'Mango',
      primaryGradient: const LinearGradient(
        colors: [Color(0xFFFF9800), Color(0xFFEC407A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      secondaryGradient: const LinearGradient(
        colors: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
      ),
      accentColor: const Color(0xFFFF9800),
      emoji: '🥭',
      backgroundColor: const Color(0xFFFFF3E0),
    ),
    'violet': AppTheme(
      id: 'violet',
      name: 'Violet',
      primaryGradient: const LinearGradient(
        colors: [Color(0xFFAB47BC), Color(0xFFEC407A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      secondaryGradient: const LinearGradient(
        colors: [Color(0xFF7E57C2), Color(0xFFAB47BC)],
      ),
      accentColor: const Color(0xFF9C27B0),
      emoji: '💜',
      backgroundColor: const Color(0xFFF3E5F5),
    ),
  };
}
