import 'package:oko_znaniy_mobile/config/api_config.dart';
import 'package:oko_znaniy_mobile/models/shop_work.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';

class ShopService {
  final ApiService _api = ApiService();

  Future<List<ShopWork>> getShopWorks({
    int page = 1,
    String? search,
    String? workType,
    String? subject,
  }) async {
    final response = await _api.get(
      ApiEndpoints.shopWorks,
      queryParameters: {
        'page': page,
        if (search != null) 'search': search,
        if (workType != null) 'work_type': workType,
        if (subject != null) 'subject': subject,
      },
    );
    final results = response.data['results'] as List<dynamic>? ??
        (response.data is List ? response.data as List<dynamic> : []);
    return results
        .map((e) => ShopWork.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ShopWork> getWorkDetail(int id) async {
    final response = await _api.get(ApiEndpoints.shopWorkDetail(id));
    return ShopWork.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> purchaseWork(int id) async {
    await _api.post(ApiEndpoints.shopWorkPurchase(id));
  }

  Future<List<ShopWork>> getPurchasedWorks({int page = 1}) async {
    final response = await _api.get(
      ApiEndpoints.shopPurchased,
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List<dynamic>? ??
        (response.data is List ? response.data as List<dynamic> : []);
    return results
        .map((e) => ShopWork.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
