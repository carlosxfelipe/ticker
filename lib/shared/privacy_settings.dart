import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettings extends InheritedWidget {
  final ValueNotifier<bool> hideValues;

  const PrivacySettings({
    super.key,
    required this.hideValues,
    required super.child,
  });

  static const _key = 'hide_values';

  static PrivacySettings of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<PrivacySettings>();
    assert(result != null, 'Nenhum PrivacySettings encontrado no contexto');
    return result!;
  }

  static Future<ValueNotifier<bool>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final initialValue = prefs.getBool(_key) ?? false;

    final notifier = ValueNotifier<bool>(initialValue);
    notifier.addListener(() {
      prefs.setBool(_key, notifier.value);
    });

    return notifier;
  }

  @override
  bool updateShouldNotify(covariant PrivacySettings oldWidget) {
    return oldWidget.hideValues != hideValues;
  }
}
