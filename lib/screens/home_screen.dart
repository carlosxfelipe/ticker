import 'package:flutter/material.dart';

import 'package:ticker/database/database_helper.dart';
import 'package:ticker/services/asset_service.dart';
import 'package:ticker/widgets.dart';
import 'package:ticker/widgets/pie_chart_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 0,
      child: Scaffold(
        appBar: SearchAppBar(
          iconName: 'refresh',
          onIconPressed: () async {
            final count = await AssetService.updateAllAssetsPricesFromBrapi();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$count ativos atualizados com sucesso'),
                ),
              );
            }
          },
        ),
        body: const HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late Future<List<Map<String, dynamic>>> futureAssets;

  @override
  void initState() {
    super.initState();
    futureAssets = DatabaseHelper().getAllAssets();
  }

  Map<String, double> _calculatePortfolioTotals(
    List<Map<String, dynamic>> assets,
  ) {
    double totalInvested = 0;
    double totalCurrent = 0;

    for (final asset in assets) {
      final quantity = (asset['quantity'] as num).toDouble();
      final averagePrice = (asset['average_price'] as num).toDouble();
      final currentPrice = (asset['current_price'] as num?)?.toDouble();

      totalInvested += quantity * averagePrice;
      totalCurrent += quantity * (currentPrice ?? averagePrice);
    }

    return {'totalInvested': totalInvested, 'totalCurrent': totalCurrent};
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder<List<Map<String, dynamic>>>(
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

          final totals = _calculatePortfolioTotals(assets);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PortfolioSummary(
                totalInvested: totals['totalInvested']!,
                totalCurrent: totals['totalCurrent']!,
              ),
              Row(
                children: [
                  Icon(
                    Icons.pie_chart,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Distribuição da Carteira',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Expanded(child: Center(child: AssetsPieChart())),
            ],
          );
        },
      ),
    );
  }
}
