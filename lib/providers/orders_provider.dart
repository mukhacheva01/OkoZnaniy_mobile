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

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
