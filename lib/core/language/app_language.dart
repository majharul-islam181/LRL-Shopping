import 'package:flutter/material.dart';

// for demo purposes using single language file but we can add more language
enum Language {
  english,bengali
}

extension LanguageExtension on Language {
String get code {
    switch (this) {
      case Language.english:
        return 'en';
      case Language.bengali:
        return 'bn';
      default:
        return 'en';
    }
  }
 Locale get locale {
    switch (this) {
      case Language.english:
        return AppLanguage.english;
      case Language.bengali:
        return AppLanguage.bengali;
      default:
        return AppLanguage.english;
    }
  }
String get text {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.bengali:
        return 'বাংলা';
      default:
        return 'English';
    }
  }
}

class AppLanguage {
  static final all = [
    const Locale('en'),
    const Locale('bn'),
  ];
  static const path = 'assets/language';
  static const english = Locale('en', '');
  static const bengali = Locale('bn', '');
  static const englishCode = 'en';
  static const bengaliCode = 'bn';
}

/*
#? flutter pub run easy_localization:generate -S assets/language -f keys -O lib/core/language/generated -o locale_keys.g.dart

#? flutter pub run easy_localization:generate

#? flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart
*/