import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ticker/shared/privacy_settings.dart';
import 'package:ticker/database/database_helper.dart';
import 'package:ticker/services/backup_service.dart';
import 'package:ticker/services/settings_service.dart';
import 'package:ticker/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 2,
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Configurações', onIconPressed: () {}),
        body: const SettingsBody(),
      ),
    );
  }
}

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  final ValueNotifier<bool> biometricEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    SettingsService.isBiometricEnabled().then((enabled) {
      biometricEnabled.value = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonBackground = isDark ? Colors.white : Colors.black;
    final buttonForeground = isDark ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storage, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Gerenciamento de Dados',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Button(
            label: 'Apagar Base de Dados',
            icon: Icons.delete_forever,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Apagar tudo'),
                      content: const Text(
                        'Deseja apagar todos os ativos da base de dados? Esta ação não pode ser desfeita.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Apagar'),
                        ),
                      ],
                    ),
              );
              if (confirm == true) {
                await DatabaseHelper().clearDatabase();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todos os dados foram apagados.'),
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 12),
          Button(
            label: 'Compartilhar Banco de Dados',
            icon: Icons.share,
            onPressed: () => BackupService.exportDatabase(context),
          ),
          const SizedBox(height: 12),
          Button(
            label: 'Importar Banco de Dados',
            icon: Icons.upload_file,
            onPressed: () => BackupService.importDatabase(context),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Icon(
                Icons.privacy_tip,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Privacidade',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ocultar valores sensíveis',
                style: TextStyle(fontSize: 16),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: PrivacySettings.of(context).hideValues,
                builder: (context, value, _) {
                  return Switch(
                    value: value,
                    onChanged: (newValue) {
                      PrivacySettings.of(context).hideValues.value = newValue;
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Solicitar biometria ao iniciar',
                style: TextStyle(fontSize: 16),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: biometricEnabled,
                builder: (context, value, _) {
                  return Switch(
                    value: value,
                    onChanged: (newValue) async {
                      await SettingsService.setBiometricEnabled(newValue);
                      biometricEnabled.value = newValue;
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.heart,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Apoie o Projeto',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Este projeto é open-source! Que tal contribuir com o desenvolvimento? 🙂',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Button(
            label: 'github.com/carlosxfelipe',
            icon: FontAwesomeIcons.github,
            backgroundColor: buttonBackground,
            foregroundColor: buttonForeground,
            onPressed: () async {
              const url = 'https://github.com/carlosxfelipe';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.platformDefault,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
