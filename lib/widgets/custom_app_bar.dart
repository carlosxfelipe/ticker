import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final IconData? iconData;
  final VoidCallback? onIconPressed;

  const CustomAppBar({
    super.key,
    required this.titleText,
    this.iconData,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      elevation: 0,
      centerTitle: true,
      title: Text(
        titleText,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions:
          iconData != null
              ? [
                IconButton(
                  icon: Icon(iconData),
                  color: theme.colorScheme.onSurface,
                  onPressed: onIconPressed ?? () {},
                ),
              ]
              : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
