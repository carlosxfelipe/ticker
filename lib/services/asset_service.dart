import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ticker/database/database_helper.dart';

class AssetService {
  static Future<int> updateAllAssetsPricesFromBrapi() async {
    final assets = await DatabaseHelper().getAllAssets();

    final brapiDio = Dio(
      BaseOptions(
        headers: {'Authorization': 'Bearer ${dotenv.env['BRAPI_API_KEY']}'},
      ),
    );

    final yahooDio = Dio();

    int updatedCount = 0;

    for (final asset in assets) {
      final ticker = asset['ticker'];
      double? currentPrice;
      String source = 'none';

      // Tenta primeiro com BRAPI
      try {
        final response = await brapiDio.get(
          'https://brapi.dev/api/quote/$ticker',
        );
        final results = response.data['results'];
        if (results != null && results.isNotEmpty) {
          currentPrice = (results[0]['regularMarketPrice'] as num?)?.toDouble();
          source = 'brapi';
        }
      } catch (_) {
        // Ignora e tenta Yahoo
      }

      // Fallback com Yahoo se BRAPI falhar
      if (currentPrice == null) {
        final yahooTicker = '${ticker.toUpperCase()}.SA';
        try {
          final response = await yahooDio.get(
            'https://query1.finance.yahoo.com/v7/finance/quote',
            queryParameters: {'symbols': yahooTicker},
          );

          final results = response.data['quoteResponse']['result'];
          if (results != null && results.isNotEmpty) {
            currentPrice =
                (results[0]['regularMarketPrice'] as num?)?.toDouble();
            source = 'yahoo';
          }
        } catch (_) {
          // Silenciar erro
        }
      }

      // Atualiza no banco se conseguiu preço
      if (currentPrice != null) {
        await DatabaseHelper().updateAsset({
          ...asset,
          'current_price': currentPrice,
        });
        updatedCount++;
        debugPrint(
          'Ticker $ticker atualizado com preço R\$ ${currentPrice.toStringAsFixed(2)} (fonte: $source)',
        );
      } else {
        debugPrint('Falha ao obter preço para $ticker com Brapi e Yahoo');
      }
    }

    debugPrint('Total de ativos atualizados: $updatedCount');
    return updatedCount;
  }
}
