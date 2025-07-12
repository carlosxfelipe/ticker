import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticker/theme/theme.dart';

class PortfolioSummary extends StatelessWidget {
  final double totalInvested;
  final double totalCurrent;

  const PortfolioSummary({
    super.key,
    required this.totalInvested,
    required this.totalCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final profit = totalCurrent - totalInvested;
    final variationPercent =
        totalInvested > 0 ? (profit / totalInvested) * 100 : 0.0;

    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    final variationColor =
        profit >= 0
            ? AppTheme.successColor(context)
            : AppTheme.errorColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Resumo da Carteira',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildItem('Investido', formatter.format(totalInvested)),
            _buildItem('Atual', formatter.format(totalCurrent)),
            _buildItem(
              'Variação',
              '${variationPercent.toStringAsFixed(2)}%',
              color: variationColor,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
