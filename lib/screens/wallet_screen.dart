import 'package:flutter/material.dart';
import 'package:ticker/database/database_helper.dart';
import 'package:ticker/theme/card_colors.dart';
import 'package:ticker/widgets.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final GlobalKey<WalletBodyState> walletBodyKey = GlobalKey<WalletBodyState>();

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1, // Índice correspondente à página de "Carteira"
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Carteira', onIconPressed: () {}),
        body: WalletBody(key: walletBodyKey),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(
              context: context,
              builder:
                  (_) => AddAssetDialog(
                    onSaved: () => walletBodyKey.currentState?.refreshAssets(),
                  ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class WalletBody extends StatefulWidget {
  const WalletBody({super.key});

  @override
  State<WalletBody> createState() => WalletBodyState();
}

class WalletBodyState extends State<WalletBody> {
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

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: cardColors[index % cardColors.length],
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            asset['ticker'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder:
                                    (_) => EditAssetDialog(
                                      asset: asset,
                                      onSaved: refreshAssets,
                                    ),
                              );
                            },
                          ),
                          IconButton(
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
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
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
                        ],
                      ),
                      const Divider(thickness: 1, height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantidade',
                            style: theme.textTheme.labelMedium,
                          ),
                          Text('$quantity'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Preço Médio',
                            style: theme.textTheme.labelMedium,
                          ),
                          Text('R\$ ${averagePrice.toStringAsFixed(2)}'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Investido',
                            style: theme.textTheme.labelMedium,
                          ),
                          Text(
                            'R\$ ${totalInvested.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
    // final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Adicionar Ativo'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tickerController,
                decoration: const InputDecoration(
                  labelText: 'Ticker',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Campo obrigatório'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Campo obrigatório'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Preço Médio',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Campo obrigatório'
                            : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final ticker = _tickerController.text.trim().toUpperCase();
              final quantity = int.tryParse(_quantityController.text.trim());
              final averagePrice = double.tryParse(
                _priceController.text.trim().replaceAll(',', '.'),
              );

              if (quantity == null || averagePrice == null) {
                if (!context.mounted) return;
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

                if (!context.mounted) return;
                widget.onSaved();
                Navigator.of(context).pop();
              } catch (e) {
                if (!context.mounted) return;
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
