import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Widget child;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _onItemTapped(int index) {
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        // context.go('/home');
        context.go('/');
        break;
      case 1:
        context.go('/wallet');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedItemColor: isDarkMode ? Colors.white : Colors.black,
        unselectedItemColor: theme.colorScheme.onSurface.withAlpha(
          (0.6 * 255).toInt(),
        ),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              widget.currentIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              widget.currentIndex == 1 ? Icons.wallet : Icons.wallet_outlined,
            ),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              widget.currentIndex == 2 ? Icons.person : Icons.person_outline,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
