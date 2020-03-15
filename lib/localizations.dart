import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class TraceryLocalizations {
  TraceryLocalizations({this.locale});
  final Locale locale;
  static TraceryLocalizations of(BuildContext context) {
    return Localizations.of<TraceryLocalizations>(context, TraceryLocalizations);
  }
  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'welcome': 'Welcome to Tracery.',
      'sign-in': 'Authenticate to continue.',
      'email': "Email",
      "submit": "Get started.",
      'password': "Password",
      'forgot-password': "Forgot password?",
      'sign-up': "Dont have an account? Sign up.",
      'me-title': "Your ID",
    },
    'de': {
      'welcome': 'Willkommen bei Tracery.',
      'sign-in': 'Authentifizieren Sie sich, um fortzufahren.',
      'email': "Email",
      "submit": "Einreichen",
      'password': "Passwort",
      'forgot-password': "Passwort vergessen?",
      "sign-up": "Sie haben noch keinen Account? Anmelden.",
      'me-title': "Ihre ID",
    },
    'ar': {
      'welcome': 'مرحبا بكم في التريساري',
      'sign-in': 'المصادقة للمتابعة',
      "email": "البريد الإلكتروني",
      "submit": "إرسال",
      'password': "كلمه السر",
      'forgot-password': "هل نسيت كلمة المرور",
      "sign-up": "لا تملك حساب؟ سجل",
      "me-title": "هويتك",
    },
    'fr': {
      'welcome': 'Bienvenue à Tracery.',
      'sign-in': 'Authentifiez-vous pour continuer.',
      'email': "Email",
      'password': "Mot de passe",
      "submit": "S'identifier",
      'forgot-password': "mot de passe oublié?",
      "sign-up": "Vous n'avez pas de compte? S'inscrire.",
      'me-title': "Votre identifiant",
    },
    'it': {
      'welcome': 'Benvenuto in Tracery.',
      'sign-in': 'Autenticare per continuare.',
      'email': "E-mail",
      'password': "Parola d'ordine",
      "submit": "Iniziare.",
      'forgot-password': "Ha dimenticato la password?",
      "sign-up": "Non hai un account? Iscriviti.",
      'me-title': "La tua carta d'identità",
    },
  };
  String get(String id) {
    return _localizedValues[locale.languageCode][id];
  }
}
class TraceryLocalizationsDelegate extends LocalizationsDelegate<TraceryLocalizations> {
  const TraceryLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ge', 'fr', 'de', 'ar'].contains(locale.languageCode);

  @override
  Future<TraceryLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<TraceryLocalizations>(TraceryLocalizations(locale: locale));
  }

  @override
  bool shouldReload(TraceryLocalizationsDelegate old) => false;
}