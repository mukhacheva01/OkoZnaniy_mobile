import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/user.dart';
import 'package:oko_znaniy_mobile/services/auth_service.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';
import 'package:oko_znaniy_mobile/config/api_config.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isTestUser = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  bool get isTestUser => _isTestUser;
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
    if (_isTestUser) return;
    try {
      _user = await _authService.getMe();
      notifyListeners();
    } catch (e) {
      _user = null;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_isTestUser) {
      _user = User(
        id: _user!.id,
        email: data['email'] as String? ?? _user!.email,
        username: _user!.username,
        firstName: data['first_name'] as String? ?? _user!.firstName,
        lastName: data['last_name'] as String? ?? _user!.lastName,
        role: _user!.role,
        avatar: _user!.avatar,
        phone: data['phone'] as String? ?? _user!.phone,
        balance: _user!.balance,
        frozenBalance: _user!.frozenBalance,
        isExpert: _user!.isExpert,
        isPartner: _user!.isPartner,
        referralCode: _user!.referralCode,
        rating: _user!.rating,
        completedOrders: _user!.completedOrders,
        activeOrders: _user!.activeOrders,
        totalOrders: _user!.totalOrders,
        totalSpent: _user!.totalSpent,
        emailVerified: _user!.emailVerified,
        bio: data['bio'] as String? ?? _user!.bio,
        education: data['education'] as String? ?? _user!.education,
        experienceYears: data['experience_years'] as int? ?? _user!.experienceYears,
        hourlyRate: (data['hourly_rate'] as num?)?.toDouble() ?? _user!.hourlyRate,
        skills: data['skills'] as List<String>? ?? _user!.skills,
        portfolioUrl: data['portfolio_url'] as String? ?? _user!.portfolioUrl,
        verificationStatus: _user!.verificationStatus,
        totalEarnings: _user!.totalEarnings,
        totalReviews: _user!.totalReviews,
        avgResponseTime: _user!.avgResponseTime,
      );
      notifyListeners();
      return;
    }
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
    _isTestUser = false;
    notifyListeners();
  }

  void loginAsTestUser({String role = 'client'}) {
    _isTestUser = true;
    final isExpert = role == 'expert';
    final isAdmin = role == 'admin';
    final isDirector = role == 'director';
    final isPartner = role == 'partner';

    String email, username, firstName, lastName;
    double balance;

    if (isAdmin) {
      email = 'admin@okoznaniy.ru'; username = 'Тестовый админ'; firstName = 'Сергей'; lastName = 'Администратов'; balance = 0;
    } else if (isDirector) {
      email = 'director@okoznaniy.ru'; username = 'Тестовый директор'; firstName = 'Дмитрий'; lastName = 'Директоров'; balance = 0;
    } else if (isPartner) {
      email = 'partner@okoznaniy.ru'; username = 'Тестовый партнёр'; firstName = 'Анна'; lastName = 'Партнёрова'; balance = 12500;
    } else if (isExpert) {
      email = 'expert@okoznaniy.ru'; username = 'Тестовый эксперт'; firstName = 'Алексей'; lastName = 'Петров'; balance = 8500;
    } else {
      email = 'client@okoznaniy.ru'; username = 'Тестовый клиент'; firstName = 'Иван'; lastName = 'Иванов'; balance = 1500;
    }

    _user = User(
      id: 0,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      role: role,
      phone: '+7 (999) 123-45-67',
      balance: balance,
      frozenBalance: (isExpert || isAdmin || isDirector || isPartner) ? 0 : 3500,
      isExpert: isExpert,
      isPartner: isPartner,
      referralCode: isPartner ? 'PARTNER2026' : 'TEST123',
      rating: isExpert ? 4.9 : 4.8,
      completedOrders: isExpert ? 156 : 8,
      activeOrders: isExpert ? 5 : 3,
      totalOrders: isExpert ? 180 : 12,
      totalSpent: isExpert ? 0 : 42500,
      emailVerified: true,
      bio: isExpert ? 'Кандидат экономических наук, преподаватель вуза с 10-летним стажем. Специализируюсь на экономике, менеджменте и финансовом анализе.' : null,
      education: isExpert ? 'МГУ им. Ломоносова, Экономический факультет, 2014' : null,
      experienceYears: isExpert ? 10 : 0,
      hourlyRate: isExpert ? 1500 : 0,
      skills: isExpert ? ['Экономика', 'Менеджмент', 'Финансовый анализ', 'Бухгалтерский учёт', 'Статистика'] : [],
      portfolioUrl: isExpert ? 'https://portfolio.example.com/petrov' : null,
      verificationStatus: isExpert ? 'verified' : 'none',
      totalEarnings: isExpert ? 485000 : (isPartner ? 67500 : 0),
      totalReviews: isExpert ? 142 : 0,
      avgResponseTime: isExpert ? '15 мин' : '',
      hasPartnerInfo: isPartner,
    );
    _error = null;
    notifyListeners();
  }

  // Email verification
  Future<bool> verifyEmailCode(String code) async {
    if (_isTestUser) {
      _user = User(
        id: _user!.id, email: _user!.email, username: _user!.username,
        firstName: _user!.firstName, lastName: _user!.lastName, role: _user!.role,
        phone: _user!.phone, balance: _user!.balance, frozenBalance: _user!.frozenBalance,
        isExpert: _user!.isExpert, isPartner: _user!.isPartner, referralCode: _user!.referralCode,
        rating: _user!.rating, completedOrders: _user!.completedOrders, activeOrders: _user!.activeOrders,
        totalOrders: _user!.totalOrders, totalSpent: _user!.totalSpent, emailVerified: true,
        bio: _user!.bio, education: _user!.education, experienceYears: _user!.experienceYears,
        hourlyRate: _user!.hourlyRate, skills: _user!.skills, portfolioUrl: _user!.portfolioUrl,
        verificationStatus: _user!.verificationStatus, totalEarnings: _user!.totalEarnings,
        totalReviews: _user!.totalReviews, avgResponseTime: _user!.avgResponseTime,
        hasPartnerInfo: _user!.hasPartnerInfo,
      );
      notifyListeners();
      return true;
    }
    try {
      await _apiService.post(ApiEndpoints.verifyEmailCode, data: {'code': code});
      await fetchUser();
      return true;
    } catch (e) { return false; }
  }

  Future<bool> resendVerificationCode() async {
    if (_isTestUser) return true;
    try {
      await _apiService.post(ApiEndpoints.resendVerificationCode, data: {});
      return true;
    } catch (e) { return false; }
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      await _apiService.post(ApiEndpoints.requestPasswordReset, data: {'email': email});
      return true;
    } catch (e) { return false; }
  }

  Future<bool> resetPasswordWithCode(String code, String newPassword) async {
    try {
      await _apiService.post(ApiEndpoints.resetPasswordWithCode, data: {'code': code, 'new_password': newPassword});
      return true;
    } catch (e) { return false; }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_isTestUser) return true;
    try {
      await _apiService.post('/users/change_password/', data: {'old_password': oldPassword, 'new_password': newPassword});
      return true;
    } catch (e) { return false; }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
