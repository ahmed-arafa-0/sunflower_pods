import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  String _currentThemeId = 'sunflower';
  bool _isLoading = false;

  String get currentThemeId => _currentThemeId;
  AppTheme get currentTheme => AppTheme.themes[_currentThemeId]!;
  Map<String, AppTheme> get allThemes => AppTheme.themes;
  bool get isLoading => _isLoading;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _currentThemeId = prefs.getString('theme') ?? 'sunflower';
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setTheme(String themeId) async {
    if (!AppTheme.themes.containsKey(themeId)) return;

    _currentThemeId = themeId;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', themeId);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  String getLowBatteryMessage() {
    switch (_currentThemeId) {
      case 'sunflower':
        return 'Sunflower needs some sunlight! (Low battery)';
      case 'sea':
        return 'The sea is getting calm... battery low';
      case 'mango':
        return 'Mango is getting sleepy... time to recharge';
      case 'violet':
        return 'Violet dreams need more energy 💜';
      default:
        return 'Battery low';
    }
  }

  String getConnectedMessage() {
    switch (_currentThemeId) {
      case 'sunflower':
        return 'Your sunshine is connected, Veuolla! 🌻';
      case 'sea':
        return 'Dive into your sea of music! 🌊';
      case 'mango':
        return 'Mango magic in the air! ✨';
      case 'violet':
        return 'Violet frequencies aligned! 💫';
      default:
        return 'Connected!';
    }
  }
}
