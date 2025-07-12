import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ticker/theme/theme.dart';
import 'package:ticker/routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carrega as variáveis de ambiente
  await dotenv.load(fileName: ".env");

  runApp(const MainApp());
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
