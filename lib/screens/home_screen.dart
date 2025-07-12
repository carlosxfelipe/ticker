import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ticker/widgets.dart';
import 'package:ticker/widgets/pie_chart_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 0, // Índice correspondente à página de "Início"
      child: Scaffold(
        appBar: SearchAppBar(iconName: 'refresh'),
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
    futureAssets = loadAssets();
  }

  Future<List<Map<String, dynamic>>> loadAssets() async {
    final jsonString = await rootBundle.loadString('assets/mock_assets.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Expanded(child: Center(child: AssetsPieChart())),
            ],
          );
        },
      ),
    );
  }
}
