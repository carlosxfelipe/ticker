import 'package:flutter/material.dart';

class PrivacySettings extends InheritedWidget {
  final ValueNotifier<bool> hideValues;

  const PrivacySettings({
    super.key,
    required this.hideValues,
    required super.child,
  });

  static PrivacySettings of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<PrivacySettings>();
    assert(result != null, 'No PrivacySettings found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(PrivacySettings oldWidget) {
    return oldWidget.hideValues != hideValues;
  }
}
