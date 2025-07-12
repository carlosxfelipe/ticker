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
      splashFactory: InkSparkle.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
        surface: AppColors.surfaceLight,
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      splashFactory: InkSparkle.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
        surface: AppColors.surfaceDark,
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white10,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        labelStyle: const TextStyle(color: Colors.white70),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
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
