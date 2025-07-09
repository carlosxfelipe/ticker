import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

class OrdersAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OrdersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      elevation: 0,
      // leading: IconButton(
      //   icon: const Icon(Icons.arrow_back),
      //   color: theme.colorScheme.onSurface,
      //   onPressed: () {
      //     GoRouter.of(context).pop();
      //   },
      // ),
      centerTitle: true,
      title: Text(
        'Pedidos',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          color: theme.colorScheme.onSurface,
          onPressed: () {
            // Ação do filtro
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
