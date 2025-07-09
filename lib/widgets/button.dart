import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

enum IconPosition { left, right }

enum ButtonState { normal, completed }

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.iconPosition = IconPosition.left,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final IconPosition iconPosition;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = backgroundColor ?? colorScheme.primary;
    final fgColor = foregroundColor ?? colorScheme.onPrimary;
    final effectiveFgColor =
        onPressed == null ? Theme.of(context).disabledColor : fgColor;

    final ButtonStyle style =
        outlined
            ? OutlinedButton.styleFrom(
              foregroundColor: fgColor,
              side: BorderSide(color: fgColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: kIsWeb ? const Size.fromHeight(60) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            )
            : FilledButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: fgColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: kIsWeb ? const Size.fromHeight(60) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            );

    Widget content =
        icon == null
            ? Text(label)
            : iconPosition == IconPosition.right
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
                const SizedBox(width: 8),
                Icon(icon, color: effectiveFgColor),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: effectiveFgColor),
                const SizedBox(width: 8),
                Text(label),
              ],
            );

    return SizedBox(
      width: double.infinity,
      child:
          outlined
              ? OutlinedButton(
                onPressed: onPressed,
                style: style,
                child: content,
              )
              : FilledButton(
                onPressed: onPressed,
                style: style,
                child: content,
              ),
    );
  }
}

class StatefulButton extends StatefulWidget {
  const StatefulButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.pressedLabel,
    this.icon,
    this.pressedIcon,
    this.backgroundColor,
    this.pressedBackgroundColor,
    this.foregroundColor,
    this.pressedForegroundColor,
    this.iconPosition = IconPosition.left,
    this.outlined = false,
    this.resetDuration = const Duration(seconds: 2),
  });

  final String label;
  final String? pressedLabel;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? pressedIcon;
  final Color? backgroundColor;
  final Color? pressedBackgroundColor;
  final Color? foregroundColor;
  final Color? pressedForegroundColor;
  final IconPosition iconPosition;
  final bool outlined;
  final Duration resetDuration;

  @override
  State<StatefulButton> createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {
  ButtonState _state = ButtonState.normal;

  Future<void> _handleTap() async {
    if (widget.onPressed != null) {
      widget.onPressed!();

      setState(() {
        _state = ButtonState.completed;
      });

      await Future.delayed(widget.resetDuration);

      if (mounted) {
        setState(() {
          _state = ButtonState.normal;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bool isCompleted = _state == ButtonState.completed;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultPressedBackgroundColor = isDark ? Colors.white : Colors.black;
    final defaultPressedForegroundColor = isDark ? Colors.black : Colors.white;

    final bgColor =
        isCompleted
            ? widget.pressedBackgroundColor ?? defaultPressedBackgroundColor
            : widget.backgroundColor ?? colorScheme.primary;

    final fgColor =
        isCompleted
            ? widget.pressedForegroundColor ?? defaultPressedForegroundColor
            : widget.foregroundColor ?? colorScheme.onPrimary;

    final icon = isCompleted ? widget.pressedIcon ?? widget.icon : widget.icon;

    final label =
        isCompleted ? widget.pressedLabel ?? widget.label : widget.label;

    final ButtonStyle style =
        widget.outlined
            ? OutlinedButton.styleFrom(
              foregroundColor: fgColor,
              side: BorderSide(color: fgColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: kIsWeb ? const Size.fromHeight(60) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            )
            : FilledButton.styleFrom(
              backgroundColor: bgColor,
              foregroundColor: fgColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: kIsWeb ? const Size.fromHeight(60) : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            );

    final Widget content =
        icon == null
            ? Text(label)
            : widget.iconPosition == IconPosition.right
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
                const SizedBox(width: 8),
                Icon(icon, color: fgColor),
              ],
            )
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fgColor),
                const SizedBox(width: 8),
                Text(label),
              ],
            );

    final button =
        widget.outlined
            ? OutlinedButton(
              onPressed: _handleTap,
              style: style,
              child: content,
            )
            : FilledButton(onPressed: _handleTap, style: style, child: content);

    return SizedBox(width: double.infinity, child: button);
  }
}
