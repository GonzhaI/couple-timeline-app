import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    // Aux for localization
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // Transparent app bar for a clean look
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      // Extend the body behind the app bar for a seamless look
      extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              const Icon(
                Icons.person_add_alt_1_rounded,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 20),

              // Title Text
              Text(
                l10n.registerTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle Text
              Text(
                l10n.registerSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Email TextField
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.passwordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password TextField
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.confirmPasswordLabel,
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              FilledButton(
                onPressed: () {
                  // TODO: Handle registration logic here FIREBASE
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  l10n.registerButton,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              // Return to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.alreadyHaveAccount),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.loginLink),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
