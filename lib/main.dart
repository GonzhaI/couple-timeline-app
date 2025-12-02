import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true), // Modo claro base
      darkTheme: ThemeData.dark(useMaterial3: true), // Modo oscuro base
      themeMode: ThemeMode.system, // Se adapta al sistema
      home: const Scaffold(
        body: Center(child: Text('Hola, bienvenido a nuestra línea de tiempo')),
      ),
    );
  }
}
