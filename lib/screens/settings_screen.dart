import 'package:flutter/material.dart';

import 'package:ticker/database/database_helper.dart';
import 'package:ticker/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 2, // Índice correspondente à página de "Configurações"
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
          // const Text('Tela de Perfil', style: TextStyle(fontSize: 17.0)),
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Configurações',
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
        ],
      ),
    );
  }
}
