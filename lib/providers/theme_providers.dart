

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';

// class ThemeNotifier extends StateNotifier<ThemeMode> {
//   static const String _themeKey = 'theme_mode';
//   late Box _box;

//   ThemeNotifier() : super(ThemeMode.system) {
//     _loadTheme();
//   }

//   Future<void> _loadTheme() async {
//     try {
//       _box = await Hive.openBox('settings');
//       final savedTheme = _box.get(_themeKey, defaultValue: 'system');
      
//       switch (savedTheme) {
//         case 'light':
//           state = ThemeMode.light;
//           break;
//         case 'dark':
//           state = ThemeMode.dark;
//           break;
//         default:
//           state = ThemeMode.system;
//       }
//     } catch (e) {
//       print('Error loading theme: $e');
//       state = ThemeMode.system;
//     }
//   }

//   Future<void> toggleTheme() async {
//     try {
//       switch (state) {
//         case ThemeMode.light:
//           state = ThemeMode.dark;
//           await _box.put(_themeKey, 'dark');
//           break;
//         case ThemeMode.dark:
//           state = ThemeMode.light;
//           await _box.put(_themeKey, 'light');
//           break;
//         case ThemeMode.system:
//           state = ThemeMode.light;
//           await _box.put(_themeKey, 'light');
//           break;
//       }
//     } catch (e) {
//       print('Error toggling theme: $e');
//     }
//   }

//   Future<void> setTheme(ThemeMode themeMode) async {
//     try {
//       state = themeMode;
//       String themeString;
//       switch (themeMode) {
//         case ThemeMode.light:
//           themeString = 'light';
//           break;
//         case ThemeMode.dark:
//           themeString = 'dark';
//           break;
//         case ThemeMode.system:
//           themeString = 'system';
//           break;
//       }
//       await _box.put(_themeKey, themeString);
//     } catch (e) {
//       print('Error setting theme: $e');
//     }
//   }
// }

// final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
//   return ThemeNotifier();
// });

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    switch (state) {
      case ThemeMode.light:
        state = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        state = ThemeMode.light;
        break;
      case ThemeMode.system:
        state = ThemeMode.light;
        break;
    }
  }

  void setTheme(ThemeMode themeMode) {
    state = themeMode;
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);
