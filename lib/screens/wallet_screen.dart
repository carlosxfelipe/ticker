import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ticker/theme/card_colors.dart';

// import 'package:ticker/theme/theme.dart';
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
    futureAssets = loadMockAssetsFromJson();
  }

  Future<List<Map<String, dynamic>>> loadMockAssetsFromJson() async {
    final jsonString = await rootBundle.loadString('assets/mock_assets.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
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
          return Center(child: Text('Erro ao carregar ativos'));
        }

        final assets = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assets.length,
          itemBuilder: (context, index) {
            final asset = assets[index];
            final totalInvested = asset['quantity'] * asset['averagePrice'];

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
      },
    );
  }
}
