import 'package:flutter/material.dart';
import 'package:ticker/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 2, // Índice correspondente à página de "Perfil"
      child: Scaffold(appBar: ProfileAppBar(), body: ProfileBody()),
    );
  }
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16, top: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text('Tela de Perfil', style: TextStyle(fontSize: 17.0)),
      ),
    );
  }
}
