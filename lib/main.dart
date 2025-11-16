import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ticker/shared/privacy_settings.dart';
import 'package:ticker/theme/theme.dart';
import 'package:ticker/routes/router.dart';
import 'package:ticker/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await dotenv.load(fileName: ".env");
  final hideValues = await PrivacySettings.loadPreferences();

  runApp(PrivacySettings(hideValues: hideValues, child: const AuthGate()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      builder: (context, child) {
        final brightness = MediaQuery.of(context).platformBrightness;
        AppTheme.setSystemUIOverlayStyle(brightness);
        return child!;
      },
    );
  }
}
