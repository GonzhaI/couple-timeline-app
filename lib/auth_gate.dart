import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:couple_timeline/screens/login_screen.dart';
import 'package:couple_timeline/screens/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listen to authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. If is waiting for data, show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. User is logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // 3. User is not logged in
        return const LoginScreen();
      },
    );
  }
}
