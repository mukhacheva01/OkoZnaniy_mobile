import 'package:oko_znaniy_mobile/config/api_config.dart';
import 'package:oko_znaniy_mobile/models/order.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';

class OrdersService {
  final ApiService _api = ApiService();

  Future<List<Order>> getOrders({
    int page = 1,
    String? status,
    String? search,
  }) async {
    final response = await _api.get(
      ApiEndpoints.ordersList,
      queryParameters: {
        'page': page,
        if (status != null) 'status': status,
        if (search != null) 'search': search,
      },
    );
    final results = response.data['results'] as List<dynamic>? ??
        (response.data is List ? response.data as List<dynamic> : []);
    return results
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Order>> getAvailableOrders({int page = 1}) async {
    final response = await _api.get(
      ApiEndpoints.ordersAvailable,
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List<dynamic>? ??
        (response.data is List ? response.data as List<dynamic> : []);
    return results
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Order>> getClientOrders({int page = 1}) async {
    final response = await _api.get(
      ApiEndpoints.clientOrders,
      queryParameters: {'page': page},
    );
    final results = response.data['results'] as List<dynamic>? ??
        (response.data is List ? response.data as List<dynamic> : []);
    return results
        .map((e) => Order.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Order> getOrderDetail(int id) async {
    final response = await _api.get(ApiEndpoints.orderDetail(id));
    return Order.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Order> createOrder(Map<String, dynamic> data) async {
    final response = await _api.post(ApiEndpoints.ordersList, data: data);
    return Order.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> takeOrder(int id) async {
    await _api.post(ApiEndpoints.orderTake(id));
  }

  Future<void> submitOrder(int id) async {
    await _api.post(ApiEndpoints.orderSubmit(id));
  }

  Future<void> completeOrder(int id) async {
    await _api.post(ApiEndpoints.orderComplete(id));
  }

  Future<void> approveOrder(int id) async {
    await _api.post(ApiEndpoints.orderApprove(id));
  }

  Future<void> requestRevision(int id, {String? comment}) async {
    await _api.post(
      ApiEndpoints.orderRevision(id),
      data: {if (comment != null) 'comment': comment},
    );
  }

  Future<void> uploadFile(int orderId, String filePath) async {
    await _api.uploadFile(ApiEndpoints.orderUploadFile(orderId), filePath);
  }

  Future<void> addComment(int orderId, String text) async {
    await _api.post(
      ApiEndpoints.orderComments(orderId),
      data: {'text': text},
    );
  }

  Future<void> createReview(int orderId, int rating, String text) async {
    await _api.post(
      ApiEndpoints.orderCreateReview(orderId),
      data: {'rating': rating, 'text': text},
    );
  }

  Future<void> rejectOrder(int id, {String? reason}) async {
    await _api.post(ApiEndpoints.orderReject(id), data: {if (reason != null) 'reason': reason});
  }

  Future<void> freezeOrder(int id) async {
    await _api.post(ApiEndpoints.orderFreeze(id));
  }

  Future<void> unfreezeOrder(int id) async {
    await _api.post(ApiEndpoints.orderUnfreeze(id));
  }

  Future<void> cancelOrder(int id) async {
    await _api.post(ApiEndpoints.orderCancel(id));
  }

  Future<void> reactivateOrder(int id) async {
    await _api.post(ApiEndpoints.orderReactivate(id));
  }

  Future<void> extendDeadline(int id, DateTime newDeadline) async {
    await _api.post(ApiEndpoints.orderExtendDeadline(id), data: {'deadline': newDeadline.toIso8601String()});
  }

  Future<void> assignExpert(int orderId, int expertId) async {
    await _api.post(ApiEndpoints.orderAssignExpert(orderId), data: {'expert_id': expertId});
  }

  Future<void> placeBid(int orderId, {required double amount, int prepayPercent = 0, String? comment}) async {
    await _api.post(ApiEndpoints.orderBids(orderId), data: {
      'amount': amount,
      'prepay_percent': prepayPercent,
      if (comment != null) 'comment': comment,
    });
  }

  Future<void> acceptBid(int orderId, int bidId) async {
    await _api.post(ApiEndpoints.orderAcceptBid(orderId), data: {'bid_id': bidId});
  }

  Future<void> declineBid(int orderId, int bidId) async {
    await _api.post(ApiEndpoints.orderDeclineBid(orderId, bidId));
  }

  Future<void> deleteFile(int orderId, int fileId) async {
    await _api.delete(ApiEndpoints.orderDeleteFile(orderId, fileId));
  }
}
