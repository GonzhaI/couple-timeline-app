import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:couple_timeline/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Aux for localization
    final l10n = AppLocalizations.of(context)!;
    // Basic scaffold for login screen
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // Allow scrolling if needed
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to full width
            children: [
              // 1. Icon or Logo
              const Icon(Icons.favorite_rounded, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),

              // 2. Welcome Text
              Text(
                l10n.loginTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.loginSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // 3. Email TextField
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    // Rounded border
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Password TextField
              TextField(
                controller: _passwordController,
                // Hide input text
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
                  border: OutlineInputBorder(
                    // Rounded border
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 5. Login Button
              FilledButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        // 1. Set loading state
                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          // 2. Attempt to sign in
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            _isLoading = false;
                          });

                          String errorMessage;
                          switch (e.code) {
                            case 'user-not-found':
                              errorMessage = l10n.userNotFoundError;
                              break;
                            case 'wrong-password':
                              errorMessage = l10n.wrongPasswordError;
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
                    : Text(l10n.loginButton, style: const TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),

              // 6. Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.noAccountText),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    child: Text(l10n.registerButton),
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
