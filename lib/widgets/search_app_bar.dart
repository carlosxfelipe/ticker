import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showIcon;
  final ValueChanged<String>? onChanged;

  const SearchAppBar({super.key, this.showIcon = true, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      // automaticallyImplyLeading: false,
      title: Row(
        children: [
          Expanded(flex: 7, child: SearchAppBarContent(onChanged: onChanged)),
          if (showIcon)
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchAppBarContent extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchAppBarContent({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 45,
      child: TextField(
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
