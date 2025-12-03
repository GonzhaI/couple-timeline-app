import 'package:couple_timeline/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:couple_timeline/firebase_options.dart';

void main() async {
  // 1. Initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3. Run the app
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
      home: const AuthGate(),
    );
  }
}
