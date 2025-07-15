// Ticker - Financial asset management application
// Copyright (C) 2025 Carlos Felipe Araújo
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ticker/shared/privacy_settings.dart';
import 'package:ticker/theme/theme.dart';
import 'package:ticker/routes/router.dart';
import 'package:ticker/services/settings_service.dart';
import 'package:ticker/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final biometricEnabled = await SettingsService.isBiometricEnabled();

  if (biometricEnabled) {
    final authenticated = await AuthService.authenticate();
    if (!authenticated) {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const Scaffold(
            body: Center(
              child: Text(
                'Autenticação necessária para continuar',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      );
      return;
    }
  }

  runApp(
    PrivacySettings(hideValues: ValueNotifier(false), child: const MainApp()),
  );
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
