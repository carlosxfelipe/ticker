import 'package:flutter/material.dart';
import 'package:ticker/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 0, // Índice correspondente à página de "Início"
      child: Scaffold(appBar: SearchAppBar(), body: HomeBody()),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;
    // final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tela de Início', style: TextStyle(fontSize: 17.0)),
          SizedBox(height: 16),
          Button(label: 'Botão 1', onPressed: () {}, icon: Icons.home),
          SizedBox(height: 12),
          StatefulButton(
            label: 'Botão com Estado',
            pressedLabel: 'Concluído',
            onPressed: () {},
            icon: Icons.check,
            pressedIcon: Icons.check_circle,
          ),
        ],
      ),
    );
  }
}
