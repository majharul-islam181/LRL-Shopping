import 'package:flutter/material.dart';
import 'package:lrl_shopping/core/theme/colors.dart';
import 'package:lrl_shopping/core/theme/text_theme.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Muli',
    textTheme: AppTextTheme.lightTextTheme,
    appBarTheme: const AppBarTheme(
      color: backgroundColor,
      iconTheme: IconThemeData(color: accentLightColor),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: accentLightColor,
      disabledColor: primaryColorDark,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: AppTextTheme.darkTextTheme,
  );
}