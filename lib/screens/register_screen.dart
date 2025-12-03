import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.person_add_alt_1_rounded, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),

              // Title Text
              Text(
                l10n.registerTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Subtitle Text
              Text(
                l10n.registerSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Name TextField
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: l10n.nameLabel,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
              const SizedBox(height: 20),

              // Email TextField
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
              const SizedBox(height: 30),

              FilledButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        // 1. Validate inputs
                        if (_nameController.text.isEmpty ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _confirmPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.fieldUnfilledError)));
                          return;
                        }

                        // 2. Check if passwords match
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(l10n.passwordMismatchError)));
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        // 3. Register user with Firebase Auth
                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );

                          if (userCredential.user != null) {
                            await userCredential.user!.updateDisplayName(_nameController.text.trim());
                            await userCredential.user!.reload();
                          }

                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        } on FirebaseAuthException catch (e) {
                          if (mounted) {
                            setState(() {
                              _isLoading = false;
                            });
                          }

                          String errorMessage;
                          switch (e.code) {
                            case 'weak-password':
                              errorMessage = l10n.weakPasswordError;
                              break;
                            case 'email-already-in-use':
                              errorMessage = l10n.emailAlreadyInUseError;
                              break;
                            case 'invalid-email':
                              errorMessage = l10n.invalidEmailError;
                              break;
                            default:
                              errorMessage = l10n.genericLoginError;
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
                        }
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(l10n.registerButton, style: const TextStyle(fontSize: 16)),
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
