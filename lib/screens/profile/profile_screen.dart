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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar & info
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: user?.avatar != null
                  ? ClipOval(
                      child: Image.network(
                        user!.avatar!,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, size: 48, color: AppColors.primary),
                      ),
                    )
                  : const Icon(Icons.person, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              user?.displayName ?? 'Пользователь',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _roleLabel(user?.role ?? 'client'),
                style: const TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 24),

            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat(context, '${user?.completedOrders ?? 0}', 'Заказов'),
                _buildStat(
                    context, user?.rating.toStringAsFixed(1) ?? '0.0', 'Рейтинг'),
                _buildStat(
                    context,
                    '${user?.balance.toStringAsFixed(0) ?? "0"} \u20BD',
                    'Баланс'),
              ],
            ),
            const SizedBox(height: 24),

            const Divider(),

            // Menu items
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
              ),
            if (user?.isPartner != true)
              _buildMenuItem(
                context,
                Icons.handshake_outlined,
                'Стать партнером',
                () => context.push(AppRoutes.becomePartner),
              ),
            if (user?.referralCode != null)
              _buildMenuItem(
                context,
                Icons.card_giftcard,
                'Реферальная программа',
                () {
                  // TODO: share referral code
                },
                trailing: Text(
                  user!.referralCode!,
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ),
            const Divider(),
            _buildMenuItem(
              context,
              Icons.logout,
              'Выйти',
              () async {
                await authProvider.logout();
                if (context.mounted) context.go(AppRoutes.login);
              },
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(title, style: TextStyle(color: color)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
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
