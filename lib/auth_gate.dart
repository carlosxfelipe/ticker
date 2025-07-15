import 'package:flutter/material.dart';
import 'package:ticker/services/auth_service.dart';
import 'package:ticker/services/settings_service.dart';
import 'package:ticker/theme/theme.dart';
import 'package:ticker/main.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool? _authenticated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final enabled = await SettingsService.isBiometricEnabled();
      if (!enabled) {
        setState(() => _authenticated = true);
        return;
      }

      final success = await AuthService.authenticate();
      setState(() => _authenticated = success);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authenticated == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    if (!_authenticated!) {
      return MaterialApp(
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
      );
    }

    return const MainApp();
  }
}
