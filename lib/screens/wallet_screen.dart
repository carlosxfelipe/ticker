import 'package:flutter/material.dart';
import 'package:ticker/widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1, // Índice correspondente à página de "Carteira"
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Carteira', onIconPressed: () {}),
        body: WalletBody(),
      ),
    );
  }
}

class WalletBody extends StatelessWidget {
  const WalletBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16, top: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text('Tela de Carteira', style: TextStyle(fontSize: 17.0)),
      ),
    );
  }
}
