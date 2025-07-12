import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ticker/database/database_helper.dart';
import 'package:ticker/theme/card_colors.dart';
import 'package:ticker/widgets.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});

  final GlobalKey<WalletBodyState> walletBodyKey = GlobalKey<WalletBodyState>();

  Future<void> updateAllCurrentPrices(BuildContext context) async {
    final assets = await DatabaseHelper().getAllAssets();
    final dio = Dio();
    int updatedCount = 0;

    for (final asset in assets) {
      final ticker = asset['ticker'];
      try {
        final response = await dio.get('https://brapi.dev/api/quote/$ticker');
        final results = response.data['results'];
        if (results != null && results.isNotEmpty) {
          final currentPrice =
              (results[0]['regularMarketPrice'] as num?)?.toDouble();
          if (currentPrice != null) {
            await DatabaseHelper().updateAsset({
              ...asset,
              'current_price': currentPrice,
            });
            updatedCount++;
          }
        }
      } catch (e) {
        debugPrint('Erro ao atualizar $ticker: $e');
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$updatedCount ativos atualizados com sucesso')),
      );
      walletBodyKey.currentState?.refreshAssets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1,
      child: Scaffold(
        appBar: CustomAppBar(
          titleText: 'Carteira',
          iconData: Icons.refresh,
          onIconPressed: () async {
            await updateAllCurrentPrices(context);
          },
        ),
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
            final currentPrice = (asset['current_price'] as num?)?.toDouble();
            final totalInvested = quantity * averagePrice;
            final totalCurrent =
                currentPrice != null ? quantity * currentPrice : null;
            final profit =
                totalCurrent != null ? totalCurrent - totalInvested : null;
            final variationPercent =
                profit != null && totalInvested > 0
                    ? (profit / totalInvested) * 100
                    : null;
            final isGain = variationPercent != null && variationPercent >= 0;
            final variationColor = isGain ? Colors.green : Colors.red;
            final variationIcon =
                isGain ? Icons.arrow_upward : Icons.arrow_downward;

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
                      if (currentPrice != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Preço Atual',
                              style: theme.textTheme.labelMedium,
                            ),
                            Text('R\$ ${currentPrice.toStringAsFixed(2)}'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Valor Atual',
                              style: theme.textTheme.labelMedium,
                            ),
                            Text('R\$ ${totalCurrent!.toStringAsFixed(2)}'),
                          ],
                        ),
                      ],
                      if (profit != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Resultado',
                              style: theme.textTheme.labelMedium,
                            ),
                            Text(
                              'R\$ ${profit.toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: variationColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (variationPercent != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Variação',
                              style: theme.textTheme.labelMedium,
                            ),
                            Row(
                              children: [
                                Icon(
                                  variationIcon,
                                  size: 16,
                                  color: variationColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${variationPercent.toStringAsFixed(2)}%',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: variationColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
