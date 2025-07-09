import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Light
  static const successLight = Color(0xFF28A745);
  static const warningLight = Color(0xFFFFC107);
  static const errorLight = Color(0xFFFF7043);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const scaffoldBackgroundLight = Color(0xFFFFFFFF);

  // Dark
  static const successDark = Color(0xFF81C784);
  static const warningDark = Color(0xFFFFD54F);
  static const errorDark = Color(0xFFFF8A65);
  static const surfaceDark = Color(0xFF1C1C1E);
  static const scaffoldBackgroundDark = Color(0xFF1C1C1E);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: Colors.blue.shade600,
        onPrimary: Colors.white,
        secondary: Colors.blue.shade400,
        surface: AppColors.surfaceLight,
        onSurface: Colors.black,
        error: AppColors.errorLight,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: Colors.blue.shade300,
        onPrimary: Colors.black,
        secondary: Colors.blue.shade200,
        surface: AppColors.surfaceDark,
        onSurface: Colors.white,
        error: AppColors.errorDark,
      ),
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  static void setSystemUIOverlayStyle(Brightness brightness, {String? route}) {
    final isDark = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor:
            isDark
                ? AppColors.scaffoldBackgroundDark
                : AppColors.scaffoldBackgroundLight,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  static Color successColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.successDark
        : AppColors.successLight;
  }

  static Color warningColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.warningDark
        : AppColors.warningLight;
  }

  static Color errorColor(BuildContext context) {
    return Theme.of(context).colorScheme.error;
  }
}
