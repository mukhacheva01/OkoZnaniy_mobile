import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';
import 'package:oko_znaniy_mobile/providers/notifications_provider.dart';
import 'package:oko_znaniy_mobile/providers/catalog_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Column(
        children: [
          // Back button
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Око Знаний',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              tabs: const [
                Tab(text: 'Зарегистрироваться'),
                Tab(text: 'Войти'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Register tab — navigate immediately
                Builder(
                  builder: (context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_tabController.index == 0) {
                        context.go(AppRoutes.register);
                      }
                    });
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),

                // Login tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (authProvider.error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              authProvider.error!,
                              style: const TextStyle(color: AppColors.error),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Email
                        const Text('Email',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password
                        const Text('Пароль',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Пароль',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Введите пароль';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => context.go(AppRoutes.passwordReset),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text('Забыли пароль?'),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login button
                        ElevatedButton(
                          onPressed:
                              authProvider.isLoading ? null : _handleLogin,
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Войти'),
                        ),
                        const SizedBox(height: 24),

                        // Social login
                        Text(
                          'или войти через',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              'assets/icons/telegram.png',
                              () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Авторизация через Telegram...'))),
                              'Telegram',
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              'assets/icons/vk.png',
                              () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Авторизация через VK...'))),
                              'VK',
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              'assets/icons/google.png',
                              () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Авторизация через Google...'))),
                              'Google',
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  context.read<AuthProvider>().loginAsTestUser(role: 'client');
                                  context.read<TestDataProvider>().initTestData();
                                  context.read<NotificationsProvider>().initTestNotifications('client');
                                  context.read<CatalogProvider>().initTestData();
                                  context.go(AppRoutes.home);
                                },
                                icon: const Icon(Icons.person_outline),
                                label: const Text('Клиент'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                  minimumSize: const Size(0, 48),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  context.read<AuthProvider>().loginAsTestUser(role: 'expert');
                                  context.read<TestDataProvider>().initTestData();
                                  context.read<NotificationsProvider>().initTestNotifications('expert');
                                  context.read<CatalogProvider>().initTestData();
                                  context.go(AppRoutes.home);
                                },
                                icon: const Icon(Icons.school_outlined),
                                label: const Text('Эксперт'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFFFB34A),
                                  side: const BorderSide(color: Color(0xFFFFB34A)),
                                  minimumSize: const Size(0, 48),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  context.read<AuthProvider>().loginAsTestUser(role: 'admin');
                                  context.read<AdminTestDataProvider>().initAdminTestData();
                                  context.read<NotificationsProvider>().initTestNotifications('admin');
                                  context.go(AppRoutes.adminDashboard);
                                },
                                icon: const Icon(Icons.admin_panel_settings_outlined),
                                label: const Text('Админ', style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFE53935),
                                  side: const BorderSide(color: Color(0xFFE53935)),
                                  minimumSize: const Size(0, 48),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  context.read<AuthProvider>().loginAsTestUser(role: 'director');
                                  context.read<AdminTestDataProvider>().initAdminTestData();
                                  context.read<DirectorTestDataProvider>().initDirectorTestData();
                                  context.read<NotificationsProvider>().initTestNotifications('director');
                                  context.go(AppRoutes.directorDashboard);
                                },
                                icon: const Icon(Icons.business_outlined),
                                label: const Text('Директор', style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF7B1FA2),
                                  side: const BorderSide(color: Color(0xFF7B1FA2)),
                                  minimumSize: const Size(0, 48),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  context.read<AuthProvider>().loginAsTestUser(role: 'partner');
                                  context.read<PartnerTestDataProvider>().initPartnerTestData();
                                  context.read<NotificationsProvider>().initTestNotifications('partner');
                                  context.go(AppRoutes.partnerDashboard);
                                },
                                icon: const Icon(Icons.handshake_outlined),
                                label: const Text('Партнёр', style: TextStyle(fontSize: 12)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2E7D32),
                                  side: const BorderSide(color: Color(0xFF2E7D32)),
                                  minimumSize: const Size(0, 48),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap, [String? label]) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: ClipOval(
          child: Image.asset(
            assetPath,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.public, size: 28),
          ),
        ),
      ),
    );
  }
}
