import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/user.dart';
import 'package:oko_znaniy_mobile/services/auth_service.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  String get userRole => _user?.role ?? 'client';

  Future<void> init() async {
    final token = await _apiService.getAccessToken();
    if (token != null) {
      await fetchUser();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.login(email, password);
      await fetchUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Неверный email или пароль';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String username,
    required String password,
    String role = 'client',
    String? referralCode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.register(
        email: email,
        username: username,
        password: password,
        role: role,
        referralCode: referralCode,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка регистрации. Проверьте данные.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchUser() async {
    try {
      _user = await _authService.getMe();
      notifyListeners();
    } catch (e) {
      _user = null;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.updateProfile(data);
    } catch (e) {
      _error = 'Ошибка обновления профиля';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  void loginAsTestUser() {
    _user = User(
      id: 0,
      email: 'test@okoznaniy.ru',
      username: 'Тестовый пользователь',
      firstName: 'Иван',
      lastName: 'Иванов',
      role: 'client',
      balance: 1500,
      isExpert: false,
      isPartner: false,
      referralCode: 'TEST123',
      rating: 4.8,
      completedOrders: 12,
    );
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
