import 'package:oko_znaniy_mobile/config/api_config.dart';
import 'package:oko_znaniy_mobile/models/user.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _api.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    await _api.saveTokens(
      data['access'] as String,
      data['refresh'] as String,
    );
    return data;
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    String role = 'client',
    String? referralCode,
  }) async {
    final response = await _api.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'username': username,
        'password': password,
        'role': role,
        if (referralCode != null) 'referral_code': referralCode,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  Future<User> getMe() async {
    final response = await _api.get(ApiEndpoints.me);
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> verifyEmailCode(String email, String code) async {
    await _api.post(
      ApiEndpoints.verifyEmailCode,
      data: {'email': email, 'code': code},
    );
  }

  Future<void> resendVerificationCode(String email) async {
    await _api.post(
      ApiEndpoints.resendVerificationCode,
      data: {'email': email},
    );
  }

  Future<void> requestPasswordReset(String email) async {
    await _api.post(
      ApiEndpoints.requestPasswordReset,
      data: {'email': email},
    );
  }

  Future<void> resetPasswordWithCode(
      String email, String code, String newPassword) async {
    await _api.post(
      ApiEndpoints.resetPasswordWithCode,
      data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      },
    );
  }

  Future<void> logout() async {
    await _api.clearTokens();
  }

  Future<User> updateProfile(Map<String, dynamic> data) async {
    final response = await _api.patch(ApiEndpoints.updateProfile, data: data);
    return User.fromJson(response.data as Map<String, dynamic>);
  }
}
