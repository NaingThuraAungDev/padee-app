import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/home_screen.dart';
import 'utils/translations.dart';

void main() {
  runApp(const PadeeApp());
}

class PadeeApp extends StatelessWidget {
  const PadeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Padee Counter',
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: const Locale('my', 'MM'), // Default to Myanmar
      fallbackLocale: const Locale('en', 'US'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('my', 'MM'),
      ],
    );
  }
}
