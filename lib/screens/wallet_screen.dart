import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ticker/database/database_helper.dart';
import 'package:ticker/services/asset_service.dart';
import 'package:ticker/shared/privacy_settings.dart';
import 'package:ticker/theme/card_colors.dart';
import 'package:ticker/theme/theme.dart';
import 'package:ticker/widgets.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final GlobalKey<WalletBodyState> walletBodyKey = GlobalKey<WalletBodyState>();
  final TextEditingController _searchController = TextEditingController();

  Future<void> updateAllCurrentPrices(BuildContext context) async {
    final updatedCount = await AssetService.updateAllAssetsPricesFromBrapi();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$updatedCount ativos atualizados com sucesso')),
      );
      walletBodyKey.currentState?.refreshAssets();
    }
  }

  void _onSearchChanged(String query) {
    walletBodyKey.currentState?.setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1,
      child: Scaffold(
        appBar: SearchAppBar(
          iconName: 'refresh',
          onIconPressed: () async => await updateAllCurrentPrices(context),
          onChanged: _onSearchChanged,
          controller: _searchController,
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
  String _searchQuery = '';

  Map<String, Color> _generateColorMap(
    List<Map<String, dynamic>> assets,
    List<Color> colorPalette,
  ) {
    final tickers = assets.map((asset) => asset['ticker'] as String).toList();

    final Map<String, Color> map = {};
    for (int i = 0; i < tickers.length; i++) {
      final ticker = tickers[i];
      map[ticker] = colorPalette[i % colorPalette.length];
    }
    return map;
  }

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

  void setSearchQuery(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
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
        final filteredAssets =
            _searchQuery.isEmpty
                ? assets
                : assets.where((asset) {
                  final ticker =
                      (asset['ticker'] as String?)?.toLowerCase() ?? '';
                  return ticker.contains(_searchQuery);
                }).toList();

        if (filteredAssets.isEmpty) {
          return const Center(child: Text('Nenhum ativo encontrado.'));
        }

        final colorMap = _generateColorMap(assets, cardColors);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredAssets.length,
          itemBuilder: (context, index) {
            final asset = filteredAssets[index];
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
            final variationColor =
                isGain
                    ? AppTheme.successColor(context)
                    : AppTheme.errorColor(context);
            final variationIcon =
                isGain ? Icons.arrow_upward : Icons.arrow_downward;

            final ticker = asset['ticker'] as String;
            final cardColor = colorMap[ticker] ?? cardColors[0];

            final currencyFormat = NumberFormat.currency(
              locale: 'pt_BR',
              symbol: 'R\$',
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Material(
                color: cardColor,
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
                          ValueListenableBuilder<bool>(
                            valueListenable:
                                PrivacySettings.of(context).hideValues,
                            builder: (context, hide, _) {
                              return Text(hide ? '****' : '$quantity');
                            },
                          ),
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
                          Text(currencyFormat.format(averagePrice)),
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
                          ValueListenableBuilder<bool>(
                            valueListenable:
                                PrivacySettings.of(context).hideValues,
                            builder: (context, hide, _) {
                              return Text(
                                hide
                                    ? 'R\$ ****'
                                    : currencyFormat.format(totalInvested),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
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
                            Text(currencyFormat.format(currentPrice)),
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
                            ValueListenableBuilder<bool>(
                              valueListenable:
                                  PrivacySettings.of(context).hideValues,
                              builder: (context, hide, _) {
                                return Text(
                                  hide
                                      ? 'R\$ ****'
                                      : currencyFormat.format(totalCurrent),
                                );
                              },
                            ),
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
                            ValueListenableBuilder<bool>(
                              valueListenable:
                                  PrivacySettings.of(context).hideValues,
                              builder: (context, hide, _) {
                                return Text(
                                  hide
                                      ? 'R\$ ****'
                                      : currencyFormat.format(profit),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: variationColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
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
