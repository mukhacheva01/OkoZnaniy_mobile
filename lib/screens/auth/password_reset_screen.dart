import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите корректный email')));
      return;
    }
    setState(() => _isLoading = true);
    final success = await context.read<AuthProvider>().requestPasswordReset(_emailController.text.trim());
    setState(() { _isLoading = false; _codeSent = success; });
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Код отправлен на email')));
    }
  }

  Future<void> _resetPassword() async {
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Пароли не совпадают')));
      return;
    }
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Минимум 8 символов')));
      return;
    }
    setState(() => _isLoading = true);
    final success = await context.read<AuthProvider>().resetPasswordWithCode(_codeController.text.trim(), _passwordController.text);
    setState(() => _isLoading = false);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Пароль изменён! Войдите заново')));
      context.go(AppRoutes.login);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Неверный код')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go(AppRoutes.login)),
        title: const Text('Сброс пароля'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.lock_reset, size: 64, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(!_codeSent ? 'Введите email для сброса пароля' : 'Введите код из письма и новый пароль',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            if (!_codeSent) ...[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendCode,
                child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Отправить код'),
              ),
            ] else ...[
              TextFormField(controller: _codeController, decoration: const InputDecoration(labelText: 'Код из письма', prefixIcon: Icon(Icons.pin))),
              const SizedBox(height: 12),
              TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Новый пароль', prefixIcon: Icon(Icons.lock_outline))),
              const SizedBox(height: 12),
              TextFormField(controller: _confirmController, obscureText: true, decoration: const InputDecoration(labelText: 'Подтвердите пароль', prefixIcon: Icon(Icons.lock_outline))),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Сменить пароль'),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: _sendCode, child: const Text('Отправить код повторно')),
            ],
          ],
        ),
      ),
    );
  }
}
