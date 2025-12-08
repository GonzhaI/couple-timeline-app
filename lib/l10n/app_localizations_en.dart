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

  @override
  String get homeErrorLoadingData => 'Error loading profile';

  @override
  String get homePairedMessage => 'You are paired!';

  @override
  String get pairingTitle => 'Connect with your partner';

  @override
  String get pairingSubtitle =>
      'Share your invite code or enter your partner\'s code to link accounts.';

  @override
  String get myCodeLabel => 'My Invite Code';

  @override
  String get codeCopiedMessage => 'Invite code copied to clipboard';

  @override
  String get enterPartnerCodeLabel => 'Enter Partner\'s Invite Code';

  @override
  String get linkPartnerButton => 'Link Partner';

  @override
  String get idLabel => 'ID:';

  @override
  String get errorLinkSelf => 'Cannot link with yourself';

  @override
  String get errorLinkAlreadyPaired => 'Partner is already linked';

  @override
  String get errorLinkInvalid => 'Invalid invite code';

  @override
  String get noMemoriesYet => 'No memories yet.';

  @override
  String get addFirstMemory =>
      'Add your first memory using the + button below!';

  @override
  String get errorPrefix => 'Error: ';

  @override
  String get newMemoryTitle => 'New Memory';

  @override
  String get editMemoryTitle => 'Edit Memory';

  @override
  String get titleLabel => 'Title';

  @override
  String get dateLabel => 'Date of Memory';

  @override
  String get locationLabel => 'Location';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get enterTitleError => 'Please enter a title for the memory.';

  @override
  String get memorySavedMsg => 'Memory saved successfully!';

  @override
  String get saveError => 'Error saving memory';

  @override
  String get savingButton => 'Saving...';

  @override
  String get updateButton => 'Update';

  @override
  String get saveButton => 'Save';

  @override
  String get deleteDialogTitle => 'Delete Memory?';

  @override
  String get deleteDialogContent => 'This action can\'t be undone.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get memoryDeletedMsg => 'Memory Deleted';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get noTitle => 'No Title';

  @override
  String get noDescription => 'No Description';

  @override
  String get noLocation => 'No Location';

  @override
  String get appTitle => 'Couple Timeline';

  @override
  String get categoryLabel => 'Category';

  @override
  String get dateCategory => 'Date';

  @override
  String get travelCategory => 'Travel';

  @override
  String get milestoneCategory => 'Milestone';

  @override
  String get dailyCategory => 'Daily Life';

  @override
  String get partyCategory => 'Party';

  @override
  String daysCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Days',
      one: '1 Day',
    );
    return '$_temp0 together';
  }

  @override
  String get setStartDate => 'Set Start Date';

  @override
  String get editDate => 'Edit Date';
}
