import 'package:oko_znaniy_mobile/config/api_config.dart';
import 'package:oko_znaniy_mobile/models/notification.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';

class NotificationService {
  final ApiService _api = ApiService();

  Future<List<AppNotification>> getNotifications({int page = 1}) async {
    final response = await _api.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page},
    );
    final results = response.data is List
        ? response.data as List<dynamic>
        : (response.data['results'] as List<dynamic>? ?? []);
    return results
        .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(int id) async {
    await _api.post(ApiEndpoints.notificationMarkRead(id));
  }
}
