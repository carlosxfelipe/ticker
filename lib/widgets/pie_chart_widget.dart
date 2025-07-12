import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ticker/database/database_helper.dart';
import 'package:ticker/theme/card_colors.dart';

class AssetsPieChart extends StatelessWidget {
  const AssetsPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getAllAssets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar ativos.'));
        }

        final assets = snapshot.data ?? [];

        if (assets.isEmpty) {
          return const Center(child: Text('Nenhum ativo disponível.'));
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColors = isDark ? darkCardColorsBold : lightCardColorsBold;

        final total = assets.fold<double>(
          0.0,
          (sum, item) =>
              sum +
              ((item['quantity'] as num) * (item['average_price'] as num))
                  .toDouble(),
        );

        final totalFormatted = NumberFormat.currency(
          locale: 'pt_BR',
          symbol: 'R\$',
        ).format(total);

        final entries =
            assets.map((e) {
              final ticker = e['ticker'] as String;
              final value =
                  ((e['quantity'] as num) * (e['average_price'] as num))
                      .toDouble();
              return MapEntry(ticker, value);
            }).toList();

        entries.sort((a, b) => b.value.compareTo(a.value));

        int colorIndex = 0;
        final chartSections =
            entries.asMap().entries.map((entry) {
              final index = entry.key;
              final ticker = entry.value.key;
              final value = entry.value.value;
              final color = cardColors[colorIndex % cardColors.length];
              colorIndex++;

              final percent = (value / total) * 100;
              final showLabel = index < 20;

              return PieChartSectionData(
                value: value,
                title:
                    showLabel ? '$ticker\n${percent.toStringAsFixed(1)}%' : '',
                titleStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                titlePositionPercentageOffset: showLabel ? 1.3 : 0.0,
                color: color,
                radius: 80,
              );
            }).toList();

        return Center(
          child: SizedBox(
            height: 360,
            width: 360,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: chartSections,
                    centerSpaceRadius: 60,
                    sectionsSpace: 2,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      totalFormatted,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
