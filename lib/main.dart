import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:couple_timeline/screens/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Couple Timeline',

      // Language and localization settings
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],

      theme: ThemeData.light(useMaterial3: true), // Modo claro base
      darkTheme: ThemeData.dark(useMaterial3: true), // Modo oscuro base
      themeMode: ThemeMode.system, // Se adapta al sistema
      home: const LoginScreen(),
    );
  }
}
