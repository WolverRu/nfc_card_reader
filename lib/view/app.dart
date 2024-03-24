import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_card_reader/repository/repository.dart';
import 'package:nfc_card_reader/view/common/dark%20_theme_preference.dart';
import 'package:nfc_card_reader/view/home_screen.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  static Future<Widget> withDependency() async {
    final repo = await Repository.createInstance();

    return MultiProvider(
      providers: [
        Provider<Repository>.value(
          value: repo,
        ),
        ChangeNotifierProvider<UiModel>(
          create: (context) => UiModel(),
        ),
      ],
      child: const App(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = Provider.of<UiModel>(context, listen: true).themeMode;
    return MaterialApp(
      title: 'NFC Card Reader',
      home: HomeScreen.withDependency(),
      theme: _themeData(Brightness.light),
      darkTheme: _themeData(Brightness.dark),
      themeMode: themeMode,
    );
  }
}

class UiModel extends ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _isDarkMode = false;

  UiModel() {
    _loadThemeFromPrefs();
  }

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.system;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    darkThemePreference.setDarkTheme(_isDarkMode);
    notifyListeners();
  }

  Future<void> _loadThemeFromPrefs() async {
    _isDarkMode = await darkThemePreference.getTheme();
    notifyListeners();
  }
}

ThemeData _themeData(Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    appBarTheme: AppBarTheme(
        color: const Color(0xFF001021),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: brightness == Brightness.light
                ? const Color.fromRGBO(254, 249, 230, 1)
                : const Color.fromARGB(255, 28, 28, 30)),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          shadows: [
            Shadow(
              color: Colors.grey,
            ),
          ],
        )),
    scaffoldBackgroundColor: brightness == Brightness.dark
        ? const Color.fromARGB(255, 28, 28, 30)
        : const Color.fromRGBO(254, 249, 230, 1),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF001021),
      contentTextStyle: TextStyle(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
    ),
    highlightColor: brightness == Brightness.dark
        ? const Color.fromARGB(255, 44, 44, 46)
        : const Color.fromRGBO(254, 249, 230, 1),
    splashFactory: NoSplash.splashFactory,
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(254, 249, 230, 1),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    useMaterial3: true,
  );
}
