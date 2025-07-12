import 'package:flutter/material.dart';

import 'package:ticker/database/database_helper.dart';
import 'package:ticker/theme/card_colors.dart';
import 'package:ticker/widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1, // Índice correspondente à página de "Carteira"
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Carteira', onIconPressed: () {}),
        body: const WalletBody(),
        floatingActionButton: Builder(
          builder:
              (context) => FloatingActionButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder:
                        (_) => AddAssetDialog(
                          onSaved:
                              () =>
                                  context
                                      .findAncestorStateOfType<
                                        _WalletBodyState
                                      >()
                                      ?.refreshAssets(),
                        ),
                  );
                },
                child: const Icon(Icons.add),
              ),
        ),
      ),
    );
  }
}

class WalletBody extends StatefulWidget {
  const WalletBody({super.key});

  @override
  State<WalletBody> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> {
  late Future<List<Map<String, dynamic>>> futureAssets;

  @override
  void initState() {
    super.initState();
    refreshAssets();
  }

  void refreshAssets() {
    setState(() {
      futureAssets = DatabaseHelper().getAllAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColors = isDark ? darkCardColorsSoft : lightCardColorsSoft;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: futureAssets,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar ativos'));
        }

        final assets = snapshot.data ?? [];

        if (assets.isEmpty) {
          return const Center(child: Text('Nenhum ativo cadastrado.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];
            final quantity = (asset['quantity'] as int?) ?? 0;
            final averagePrice =
                (asset['average_price'] as num?)?.toDouble() ?? 0.0;
            final totalInvested = quantity * averagePrice;

            return Card(
              color: cardColors[index % cardColors.length],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset['ticker'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Quantidade: $quantity'),
                    Text('Preço Médio: R\$ ${averagePrice.toStringAsFixed(2)}'),
                    Text(
                      'Total Investido: R\$ ${totalInvested.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text('Remover ativo'),
                                  content: const Text(
                                    'Deseja remover este ativo?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Remover'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            await DatabaseHelper().deleteAsset(asset['id']);
                            refreshAssets();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class AddAssetDialog extends StatefulWidget {
  final VoidCallback onSaved;
  const AddAssetDialog({super.key, required this.onSaved});

  @override
  State<AddAssetDialog> createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tickerController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Ativo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tickerController,
              decoration: const InputDecoration(labelText: 'Ticker'),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: const TextInputType.numberWithOptions(),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Preço Médio'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? 'Campo obrigatório'
                          : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final ticker = _tickerController.text.trim().toUpperCase();
              final quantity = int.tryParse(_quantityController.text.trim());
              final averagePrice = double.tryParse(
                _priceController.text.trim().replaceAll(',', '.'),
              );

              if (quantity == null || averagePrice == null) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Valores numéricos inválidos.')),
                );
                return;
              }

              try {
                await DatabaseHelper().insertAsset({
                  'ticker': ticker,
                  'quantity': quantity,
                  'average_price': averagePrice,
                });

                if (!mounted) return;
                widget.onSaved();
                Navigator.of(context).pop();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
              }
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
