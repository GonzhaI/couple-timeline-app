import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión para conectar con tu pareja'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Confirmar contraseña'**
  String get confirmPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get registerButton;

  /// No description provided for @noAccountText.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta?'**
  String get noAccountText;

  /// No description provided for @registerTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Comienza tu historia juntos'**
  String get registerSubtitle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión aquí'**
  String get loginLink;

  /// No description provided for @fieldUnfilledError.
  ///
  /// In es, this message translates to:
  /// **'Por favor, completa todos los campos'**
  String get fieldUnfilledError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordMismatchError;

  /// No description provided for @loginSuccessMessage.
  ///
  /// In es, this message translates to:
  /// **'¡Inicio de sesión exitoso!'**
  String get loginSuccessMessage;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuestra Historia'**
  String get homeTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get welcomeMessage;

  /// No description provided for @defaultHomeMessage.
  ///
  /// In es, this message translates to:
  /// **'Aquí comenzará su historia juntos.'**
  String get defaultHomeMessage;

  /// No description provided for @userNotFoundError.
  ///
  /// In es, this message translates to:
  /// **'Usuario no encontrado'**
  String get userNotFoundError;

  /// No description provided for @wrongPasswordError.
  ///
  /// In es, this message translates to:
  /// **'Contraseña incorrecta'**
  String get wrongPasswordError;

  /// No description provided for @invalidEmailError.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico inválido'**
  String get invalidEmailError;

  /// No description provided for @genericLoginError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión. Por favor, inténtalo de nuevo.'**
  String get genericLoginError;

  /// No description provided for @weakPasswordError.
  ///
  /// In es, this message translates to:
  /// **'La contraseña es demasiado débil.'**
  String get weakPasswordError;

  /// No description provided for @emailAlreadyInUseError.
  ///
  /// In es, this message translates to:
  /// **'El correo electrónico ya está en uso.'**
  String get emailAlreadyInUseError;

  /// No description provided for @nameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get nameLabel;

  /// No description provided for @nameError.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa tu nombre completo'**
  String get nameError;

  /// No description provided for @homeErrorLoadingData.
  ///
  /// In es, this message translates to:
  /// **'Error cargando perfil'**
  String get homeErrorLoadingData;

  /// No description provided for @homePairedMessage.
  ///
  /// In es, this message translates to:
  /// **'¡Estás emparejado!'**
  String get homePairedMessage;

  /// No description provided for @pairingTitle.
  ///
  /// In es, this message translates to:
  /// **'Conecta con tu pareja'**
  String get pairingTitle;

  /// No description provided for @pairingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Comparte tu código o ingresa el de tu pareja para vincular las cuentas.'**
  String get pairingSubtitle;

  /// No description provided for @myCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Mi Código de Invitación'**
  String get myCodeLabel;

  /// No description provided for @codeCopiedMessage.
  ///
  /// In es, this message translates to:
  /// **'Código copiado al portapapeles'**
  String get codeCopiedMessage;

  /// No description provided for @enterPartnerCodeLabel.
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de tu pareja'**
  String get enterPartnerCodeLabel;

  /// No description provided for @linkPartnerButton.
  ///
  /// In es, this message translates to:
  /// **'Vincular Pareja'**
  String get linkPartnerButton;

  /// No description provided for @idLabel.
  ///
  /// In es, this message translates to:
  /// **'ID:'**
  String get idLabel;

  /// No description provided for @errorLinkSelf.
  ///
  /// In es, this message translates to:
  /// **'No puedes vincularte contigo mismo'**
  String get errorLinkSelf;

  /// No description provided for @errorLinkAlreadyPaired.
  ///
  /// In es, this message translates to:
  /// **'Este usuario ya tiene pareja'**
  String get errorLinkAlreadyPaired;

  /// No description provided for @errorLinkInvalid.
  ///
  /// In es, this message translates to:
  /// **'Código de invitación inválido'**
  String get errorLinkInvalid;

  /// No description provided for @noMemoriesYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay recuerdos.'**
  String get noMemoriesYet;

  /// No description provided for @addFirstMemory.
  ///
  /// In es, this message translates to:
  /// **'¡Agrega el primero con el botón +!'**
  String get addFirstMemory;

  /// No description provided for @errorPrefix.
  ///
  /// In es, this message translates to:
  /// **'Error: '**
  String get errorPrefix;

  /// No description provided for @newMemoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Nuevo Recuerdo'**
  String get newMemoryTitle;

  /// No description provided for @editMemoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Editar Recuerdo'**
  String get editMemoryTitle;

  /// No description provided for @titleLabel.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get titleLabel;

  /// No description provided for @dateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha del Recuerdo'**
  String get dateLabel;

  /// No description provided for @locationLabel.
  ///
  /// In es, this message translates to:
  /// **'Ubicación'**
  String get locationLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get descriptionLabel;

  /// No description provided for @enterTitleError.
  ///
  /// In es, this message translates to:
  /// **'Por favor ingresa un título para el recuerdo.'**
  String get enterTitleError;

  /// No description provided for @memorySavedMsg.
  ///
  /// In es, this message translates to:
  /// **'¡Recuerdo guardado con éxito!'**
  String get memorySavedMsg;

  /// No description provided for @saveError.
  ///
  /// In es, this message translates to:
  /// **'Error guardando recuerdo'**
  String get saveError;

  /// No description provided for @savingButton.
  ///
  /// In es, this message translates to:
  /// **'Guardando...'**
  String get savingButton;

  /// No description provided for @updateButton.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get updateButton;

  /// No description provided for @saveButton.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get saveButton;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar Recuerdo?'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogContent.
  ///
  /// In es, this message translates to:
  /// **'Esta acción no se puede deshacer.'**
  String get deleteDialogContent;

  /// No description provided for @cancelButton.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteButton;

  /// No description provided for @memoryDeletedMsg.
  ///
  /// In es, this message translates to:
  /// **'Recuerdo eliminado'**
  String get memoryDeletedMsg;

  /// No description provided for @editAction.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteAction;

  /// No description provided for @noTitle.
  ///
  /// In es, this message translates to:
  /// **'Sin Título'**
  String get noTitle;

  /// No description provided for @noDescription.
  ///
  /// In es, this message translates to:
  /// **'Sin Descripción'**
  String get noDescription;

  /// No description provided for @noLocation.
  ///
  /// In es, this message translates to:
  /// **'Sin Ubicación'**
  String get noLocation;

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Couple Timeline'**
  String get appTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
