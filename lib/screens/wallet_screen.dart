import 'package:flutter/material.dart';
import 'package:ticker/theme/card_colors.dart';

// import 'package:ticker/theme/theme.dart';
import 'package:ticker/widgets.dart';
import 'package:ticker/data/mock_assets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1, // Índice correspondente à página de "Carteira"
      child: Scaffold(
        appBar: CustomAppBar(titleText: 'Carteira', onIconPressed: () {}),
        body: const WalletBody(),
      ),
    );
  }
}

class WalletBody extends StatelessWidget {
  const WalletBody({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockAssets.length,
      itemBuilder: (context, index) {
        final asset = mockAssets[index];
        final totalInvested = asset['quantity'] * asset['averagePrice'];

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColors = isDark ? darkCardColors : lightCardColors;

        return Card(
          color: cardColors[index % cardColors.length],
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                Text('Quantidade: ${asset['quantity']}'),
                Text(
                  'Preço Médio: R\$ ${asset['averagePrice'].toStringAsFixed(2)}',
                ),
                Text(
                  'Total Investido: R\$ ${totalInvested.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
