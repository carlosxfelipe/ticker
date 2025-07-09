import 'package:flutter/material.dart';
import 'package:ticker/widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1, // Índice correspondente à página de "Pedidos"
      child: Scaffold(appBar: OrdersAppBar(), body: OrdersBody()),
    );
  }
}

class OrdersBody extends StatelessWidget {
  const OrdersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16, top: 16),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text('Tela de Pedidos', style: TextStyle(fontSize: 17.0)),
      ),
    );
  }
}
