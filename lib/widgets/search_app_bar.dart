import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? iconName;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onIconPressed;
  final TextEditingController? controller;

  const SearchAppBar({
    super.key,
    this.iconName,
    this.onChanged,
    this.onIconPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValidIcon = iconName != null && _getIconByName(iconName!) != null;

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      title: Row(
        children: [
          Expanded(
            flex: hasValidIcon ? 7 : 8,
            child: SearchAppBarContent(
              onChanged: onChanged,
              controller: controller,
            ),
          ),
          if (hasValidIcon)
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    _getIconByName(iconName!)!,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: onIconPressed,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  IconData? _getIconByName(String name) {
    switch (name) {
      case 'shopping_cart_outlined':
        return Icons.shopping_cart_outlined;
      case 'favorite':
        return Icons.favorite;
      case 'search':
        return Icons.search;
      case 'home':
        return Icons.home;
      case 'refresh':
        return Icons.refresh;
      default:
        return null;
    }
  }
}

class SearchAppBarContent extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchAppBarContent({super.key, this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurface.withAlpha(153),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurface.withAlpha(179),
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
    );
  }
}
