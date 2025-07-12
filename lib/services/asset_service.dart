import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ticker/database/database_helper.dart';

class AssetService {
  static Future<int> updateAllAssetsPricesFromBrapi() async {
    final assets = await DatabaseHelper().getAllAssets();

    final dio = Dio(
      BaseOptions(
        headers: {'Authorization': 'Bearer ${dotenv.env['BRAPI_API_KEY']}'},
      ),
    );

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
        // Log silencioso
      }
    }

    return updatedCount;
  }
}
