// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginSubtitle => 'Sign in to connect with your partner';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get loginButton => 'Log In';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get noAccountText => 'Don\'t have an account?';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Start your story together';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get loginLink => 'Log in here';

  @override
  String get fieldUnfilledError => 'Please fill in all fields';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get loginSuccessMessage => 'Login successful!';

  @override
  String get homeTitle => 'Our Story';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get defaultHomeMessage =>
      'This is where your story together will begin.';

  @override
  String get userNotFoundError => 'User not found';

  @override
  String get wrongPasswordError => 'Incorrect password';

  @override
  String get invalidEmailError => 'Invalid email address';

  @override
  String get genericLoginError => 'Error logging in. Please try again.';

  @override
  String get weakPasswordError => 'The password is too weak.';

  @override
  String get emailAlreadyInUseError => 'The email is already in use.';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get nameError => 'Please enter your full name';
}
