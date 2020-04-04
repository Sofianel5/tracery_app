import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/pages/anon_signup_page.dart';
import 'package:tracery_app/pages/main_page.dart';
import 'package:tracery_app/pages/splash_screen.dart';

void main() => runApp(TraceryApp());

class TraceryApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<TraceryApp> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this.locale = locale;
      });
    });
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      return null;
    }
    return Locale(
        prefs.getString('language_code'), prefs.getString('country_code'));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (this.locale == null) {
          this.locale = deviceLocale;
        }
        return this.locale;
      },
      title: 'Tracery',
      theme: ThemeData(
        primaryColor: Color(0xFF1b4774),
        accentColor: Color(0xFF03016c),
        scaffoldBackgroundColor: Color(0xFF00c2cc),
        canvasColor: Color(0xFF5104f8),
        bottomAppBarColor: Color(0xFFF3F5F7),
      ),
      home: RootPage(),
      localizationsDelegates: [
        const TraceryLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('de'), // German
        const Locale('fr'), // French
        const Locale('it'), // Italian
        const Locale('ar'), // Arabic
      ],
    );
  }
}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Authenticated:
              return MainPage();
            case Status.Uninitialized:
              return SplashScreen();
            default:
              return DefaultAuthPage();
          }
        },
      ),
    );
  }
}
