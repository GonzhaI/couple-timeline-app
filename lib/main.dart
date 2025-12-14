import 'package:couple_timeline/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:couple_timeline/firebase_options.dart';
import 'package:couple_timeline/services/theme_service.dart';

void main() async {
  // Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load the saved theme mode before running the app
  await ThemeService.loadTheme();

  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // Language and localization settings
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es')],

          // Title
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

          // Theme
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)), // Morado base
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4), brightness: Brightness.dark),
            useMaterial3: true,
            brightness: Brightness.dark,
          ),

          themeMode: currentMode,
          home: const AuthGate(),
        );
      },
    );
  }
}
