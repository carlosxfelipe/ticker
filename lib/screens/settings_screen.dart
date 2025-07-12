import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ticker/database/database_helper.dart';
import 'package:ticker/services/backup_service.dart';
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

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 32),
          // NOVO TÍTULO: Apoio ao projeto
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
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            onPressed: () async {
              const url = 'https://github.com/carlosxfelipe';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
