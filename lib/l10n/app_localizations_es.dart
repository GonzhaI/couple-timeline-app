// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginTitle => 'Bienvenido';

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
}
