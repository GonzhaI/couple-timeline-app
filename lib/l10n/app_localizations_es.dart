// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginTitle => '¡Bienvenido!';

  @override
  String get loginSubtitle => 'Inicia sesión para conectar con tu pareja';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get loginButton => 'Iniciar Sesión';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get noAccountText => '¿No tienes cuenta?';

  @override
  String get registerTitle => 'Crear Cuenta';

  @override
  String get registerSubtitle => 'Comienza tu historia juntos';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get loginLink => 'Inicia sesión aquí';

  @override
  String get fieldUnfilledError => 'Por favor, completa todos los campos';

  @override
  String get passwordMismatchError => 'Las contraseñas no coinciden';

  @override
  String get loginSuccessMessage => '¡Inicio de sesión exitoso!';

  @override
  String get homeTitle => 'Nuestra Historia';

  @override
  String get welcomeMessage => 'Bienvenido';

  @override
  String get defaultHomeMessage => 'Aquí comenzará su historia juntos.';

  @override
  String get userNotFoundError => 'Usuario no encontrado';

  @override
  String get wrongPasswordError => 'Contraseña incorrecta';

  @override
  String get invalidEmailError => 'Correo electrónico inválido';

  @override
  String get genericLoginError =>
      'Error al iniciar sesión. Por favor, inténtalo de nuevo.';

  @override
  String get weakPasswordError => 'La contraseña es demasiado débil.';

  @override
  String get emailAlreadyInUseError => 'El correo electrónico ya está en uso.';

  @override
  String get nameLabel => 'Nombre completo';

  @override
  String get nameError => 'Por favor, ingresa tu nombre completo';

  @override
  String get homeErrorLoadingData => 'Error cargando perfil';

  @override
  String get homePairedMessage => '¡Estás emparejado!';

  @override
  String get pairingTitle => 'Conecta con tu pareja';

  @override
  String get pairingSubtitle =>
      'Comparte tu código o ingresa el de tu pareja para vincular las cuentas.';

  @override
  String get myCodeLabel => 'Mi Código de Invitación';

  @override
  String get codeCopiedMessage => 'Código copiado al portapapeles';

  @override
  String get enterPartnerCodeLabel => 'Ingresa el código de tu pareja';

  @override
  String get linkPartnerButton => 'Vincular Pareja';

  @override
  String get idLabel => 'ID:';

  @override
  String get errorLinkSelf => 'No puedes vincularte contigo mismo';

  @override
  String get errorLinkAlreadyPaired => 'Este usuario ya tiene pareja';

  @override
  String get errorLinkInvalid => 'Código de invitación inválido';
}
