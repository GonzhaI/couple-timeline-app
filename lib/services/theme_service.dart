import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  // Inicializamos con un valor seguro por defecto
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);
  static const String _themeKey = "theme_mode";

  static Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? themeString = prefs.getString(_themeKey);

      if (themeString == 'light') {
        themeNotifier.value = ThemeMode.light;
      } else if (themeString == 'dark') {
        themeNotifier.value = ThemeMode.dark;
      } else {
        themeNotifier.value = ThemeMode.system;
      }
    } catch (e) {
      debugPrint("Error cargando tema: $e");
      // Si falla, nos quedamos con el valor por defecto (system)
    }
  }

  static Future<void> setTheme(ThemeMode mode) async {
    // 1. Actualizamos la UI inmediatamente
    themeNotifier.value = mode;

    // 2. Guardamos en disco de forma asíncrona "fire and forget"
    try {
      final prefs = await SharedPreferences.getInstance();
      if (mode == ThemeMode.light) {
        await prefs.setString(_themeKey, 'light');
      } else if (mode == ThemeMode.dark) {
        await prefs.setString(_themeKey, 'dark');
      } else {
        await prefs.remove(_themeKey);
      }
    } catch (e) {
      debugPrint("Error guardando tema: $e");
    }
  }
}
