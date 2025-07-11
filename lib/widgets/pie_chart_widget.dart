import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ticker/theme/card_colors.dart';

class AssetsPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> assets;

  const AssetsPieChart({super.key, required this.assets});

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return const Center(child: Text('Nenhum ativo disponível.'));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColors = isDark ? darkCardColorsBold : lightCardColorsBold;

    // Calcular total
    final total = assets.fold<double>(
      0.0,
      (sum, item) =>
          sum +
          ((item['quantity'] as num) * (item['averagePrice'] as num))
              .toDouble(),
    );

    // Calcular valor por ativo
    final List<MapEntry<String, double>> entries =
        assets
            .map(
              (e) => MapEntry(
                e['ticker'] as String,
                ((e['quantity'] as num) * (e['averagePrice'] as num))
                    .toDouble(),
              ),
            )
            .toList();

    // Ordenar por valor
    entries.sort((a, b) => b.value.compareTo(a.value));

    // Gerar seções do gráfico
    int colorIndex = 0;
    final chartSections =
        entries.map((entry) {
          final color = cardColors[colorIndex % cardColors.length];
          colorIndex++;
          return PieChartSectionData(
            value: entry.value,
            title: '',
            color: color,
            radius: 80,
          );
        }).toList();

    // Legenda dos 20 maiores
    colorIndex = 0;
    final legendItems =
        entries.take(20).map((entry) {
          final percent = (entry.value / total) * 100;
          final color = cardColors[colorIndex % cardColors.length];
          colorIndex++;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, color: color),
                const SizedBox(width: 6),
                Text('${entry.key} (${percent.toStringAsFixed(1)}%)'),
              ],
            ),
          );
        }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 340,
              child: PieChart(
                PieChartData(
                  sections: chartSections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 16, runSpacing: 8, children: legendItems),
        ],
      ),
    );
  }
}
