import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/order.dart';
import 'package:oko_znaniy_mobile/services/orders_service.dart';

class OrdersProvider extends ChangeNotifier {
  final OrdersService _service = OrdersService();

  List<Order> _orders = [];
  List<Order> _availableOrders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Order> get orders => _orders;
  List<Order> get availableOrders => _availableOrders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchOrders({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }
    if (!_hasMore && !refresh) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newOrders = await _service.getOrders(page: _currentPage);
      if (refresh) {
        _orders = newOrders;
      } else {
        _orders.addAll(newOrders);
      }
      _hasMore = newOrders.length >= 20;
      _currentPage++;
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки заказов';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchAvailableOrders({bool refresh = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _availableOrders = await _service.getAvailableOrders();
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки доступных заказов';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchOrderDetail(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentOrder = await _service.getOrderDetail(id);
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки заказа';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createOrder(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final order = await _service.createOrder(data);
      _orders.insert(0, order);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка создания заказа';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> takeOrder(int id) async {
    try {
      await _service.takeOrder(id);
      await fetchOrderDetail(id);
      return true;
    } catch (e) {
      _error = 'Ошибка принятия заказа';
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitOrder(int id) async {
    try { await _service.submitOrder(id); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка отправки работы'; notifyListeners(); return false; }
  }

  Future<bool> completeOrder(int id) async {
    try { await _service.completeOrder(id); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка завершения'; notifyListeners(); return false; }
  }

  Future<bool> approveOrder(int id) async {
    try { await _service.approveOrder(id); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка подтверждения'; notifyListeners(); return false; }
  }

  Future<bool> requestRevision(int id, {String? comment}) async {
    try { await _service.requestRevision(id, comment: comment); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка отправки на доработку'; notifyListeners(); return false; }
  }

  Future<bool> rejectOrder(int id, {String? reason}) async {
    try { await _service.rejectOrder(id, reason: reason); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка отклонения'; notifyListeners(); return false; }
  }

  Future<bool> freezeOrder(int id) async {
    try { await _service.freezeOrder(id); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка заморозки'; notifyListeners(); return false; }
  }

  Future<bool> unfreezeOrder(int id) async {
    try { await _service.unfreezeOrder(id); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка разморозки'; notifyListeners(); return false; }
  }

  Future<bool> cancelOrder(int id) async {
    try { await _service.cancelOrder(id); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка отмены'; notifyListeners(); return false; }
  }

  Future<bool> reactivateOrder(int id) async {
    try { await _service.reactivateOrder(id); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка реактивации'; notifyListeners(); return false; }
  }

  Future<bool> extendDeadline(int id, DateTime newDeadline) async {
    try { await _service.extendDeadline(id, newDeadline); await fetchOrderDetail(id); return true; }
    catch (e) { _error = 'Ошибка продления дедлайна'; notifyListeners(); return false; }
  }

  Future<bool> assignExpert(int orderId, int expertId) async {
    try { await _service.assignExpert(orderId, expertId); await fetchOrderDetail(orderId); return true; }
    catch (e) { _error = 'Ошибка назначения эксперта'; notifyListeners(); return false; }
  }

  Future<bool> placeBid(int orderId, {required double amount, int prepayPercent = 0, String? comment}) async {
    try { await _service.placeBid(orderId, amount: amount, prepayPercent: prepayPercent, comment: comment); return true; }
    catch (e) { _error = 'Ошибка размещения ставки'; notifyListeners(); return false; }
  }

  Future<bool> acceptBid(int orderId, int bidId) async {
    try { await _service.acceptBid(orderId, bidId); await fetchOrderDetail(orderId); return true; }
    catch (e) { _error = 'Ошибка принятия ставки'; notifyListeners(); return false; }
  }

  Future<bool> declineBid(int orderId, int bidId) async {
    try { await _service.declineBid(orderId, bidId); return true; }
    catch (e) { _error = 'Ошибка отклонения ставки'; notifyListeners(); return false; }
  }

  Future<bool> uploadFile(int orderId, String filePath) async {
    try { await _service.uploadFile(orderId, filePath); return true; }
    catch (e) { _error = 'Ошибка загрузки файла'; notifyListeners(); return false; }
  }

  Future<bool> deleteFile(int orderId, int fileId) async {
    try { await _service.deleteFile(orderId, fileId); return true; }
    catch (e) { _error = 'Ошибка удаления файла'; notifyListeners(); return false; }
  }

  Future<bool> addComment(int orderId, String text) async {
    try { await _service.addComment(orderId, text); return true; }
    catch (e) { _error = 'Ошибка добавления комментария'; notifyListeners(); return false; }
  }

  Future<bool> createReview(int orderId, int rating, String text) async {
    try { await _service.createReview(orderId, rating, text); return true; }
    catch (e) { _error = 'Ошибка создания отзыва'; notifyListeners(); return false; }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
