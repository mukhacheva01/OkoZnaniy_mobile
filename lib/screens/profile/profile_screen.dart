import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.editProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header with gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: user?.avatar != null
                        ? ClipOval(
                            child: Image.network(
                              user!.avatar!,
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person,
                                      size: 48, color: Colors.white),
                            ),
                          )
                        : const Icon(Icons.person,
                            size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Пользователь',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Text(
                      _roleLabel(user?.role ?? 'client'),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(context, '${user?.completedOrders ?? 0}',
                        'Заказов', AppColors.primary),
                    Container(
                        width: 1, height: 32, color: AppColors.divider),
                    _buildStat(
                        context,
                        user?.rating.toStringAsFixed(1) ?? '0.0',
                        'Рейтинг',
                        AppColors.orange),
                    Container(
                        width: 1, height: 32, color: AppColors.divider),
                    _buildStat(
                        context,
                        '${user?.balance.toStringAsFixed(0) ?? "0"} \u20BD',
                        'Баланс',
                        AppColors.success),
                  ],
                ),
              ),
            ),

            // Menu items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuItem(
                    context,
                    Icons.edit_outlined,
                    'Редактировать профиль',
                    () => context.push(AppRoutes.editProfile),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.notifications_outlined,
                    'Уведомления',
                    () => context.push(AppRoutes.notifications),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.shopping_bag_outlined,
                    'Купленные работы',
                    () => context.push(AppRoutes.purchasedWorks),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.support_agent,
                    'Поддержка',
                    () => context.push(AppRoutes.supportCenter),
                  ),
                  _buildMenuItem(
                    context,
                    Icons.school_outlined,
                    'База знаний',
                    () => context.push(AppRoutes.knowledgePortal),
                  ),
                  if (user?.role == 'expert')
                    _buildMenuItem(
                      context,
                      Icons.dashboard_outlined,
                      'Панель эксперта',
                      () => context.push(AppRoutes.expertDashboard),
                    ),
                  if (user?.isPartner == true)
                    _buildMenuItem(
                      context,
                      Icons.handshake_outlined,
                      'Партнерская программа',
                      () => context.push(AppRoutes.partnerDashboard),
                    ),
                  if (user?.role != 'expert')
                    _buildMenuItem(
                      context,
                      Icons.star_outline,
                      'Стать экспертом',
                      () => context.push(AppRoutes.becomeExpert),
                      iconColor: AppColors.orange,
                    ),
                  if (user?.isPartner != true)
                    _buildMenuItem(
                      context,
                      Icons.handshake_outlined,
                      'Стать партнером',
                      () => context.push(AppRoutes.becomePartner),
                      iconColor: AppColors.purple,
                    ),
                  if (user?.referralCode != null)
                    _buildMenuItem(
                      context,
                      Icons.card_giftcard,
                      'Реферальная программа',
                      () {},
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(64),
                        ),
                        child: Text(
                          user!.referralCode!,
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Divider(),
                  _buildMenuItem(
                    context,
                    Icons.logout,
                    'Выйти',
                    () async {
                      await authProvider.logout();
                      if (context.mounted) context.go(AppRoutes.login);
                    },
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
      BuildContext context, String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? iconColor,
    Color? titleColor,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                (iconColor ?? AppColors.textPrimary).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 20),
        ),
        title: Text(title, style: TextStyle(color: titleColor, fontSize: 15)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _roleLabel(String role) {
    const labels = {
      'client': 'Клиент',
      'expert': 'Эксперт',
      'partner': 'Партнер',
      'admin': 'Администратор',
      'director': 'Директор',
      'arbitrator': 'Арбитр',
    };
    return labels[role] ?? role;
  }
}
