import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertOwnProfileScreen extends StatelessWidget {
  const ExpertOwnProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final testData = context.watch<TestDataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль эксперта'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.editExpertProfile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    child: const Icon(Icons.person, size: 48, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(user?.displayName ?? 'Эксперт',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                  if (user?.phone != null) ...[
                    const SizedBox(height: 2),
                    Text(user!.phone!, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge(context, 'Эксперт', AppColors.orange),
                      const SizedBox(width: 8),
                      _buildVerificationBadge(context, user?.verificationStatus ?? 'none'),
                    ],
                  ),
                ],
              ),
            ),

            // Stats card
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(context, '${user?.totalOrders ?? 0}', 'Всего', AppColors.textSecondary),
                        Container(width: 1, height: 32, color: AppColors.divider),
                        _buildStat(context, '${user?.completedOrders ?? 0}', 'Завершено', AppColors.success),
                        Container(width: 1, height: 32, color: AppColors.divider),
                        _buildStat(context, user?.rating.toStringAsFixed(1) ?? '0.0', 'Рейтинг', AppColors.orange),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(context, '${user?.totalReviews ?? 0}', 'Отзывов', AppColors.primary),
                        Container(width: 1, height: 32, color: AppColors.divider),
                        _buildStat(context, '${user?.successRate.toStringAsFixed(0) ?? "0"}%', 'Успех', AppColors.success),
                        Container(width: 1, height: 32, color: AppColors.divider),
                        _buildStat(context, user?.avgResponseTime ?? '-', 'Ответ', AppColors.primary),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(context, '${user?.balance.toStringAsFixed(0) ?? "0"} ₽', 'Баланс', AppColors.success),
                        Container(width: 1, height: 32, color: AppColors.divider),
                        _buildStat(context, '${user?.totalEarnings.toStringAsFixed(0) ?? "0"} ₽', 'Заработок', AppColors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bio section
            if (user?.bio != null && user!.bio!.isNotEmpty)
              _buildInfoSection(context, 'О себе', user.bio!),

            // Education
            if (user?.education != null && user!.education!.isNotEmpty)
              _buildInfoSection(context, 'Образование', user.education!),

            // Experience & rate
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Детали', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildDetailRow('Опыт работы', '${user?.experienceYears ?? 0} лет'),
                  _buildDetailRow('Почасовая ставка', '${user?.hourlyRate.toStringAsFixed(0) ?? "0"} ₽/час'),
                  if (user?.portfolioUrl != null)
                    _buildDetailRow('Портфолио', user!.portfolioUrl!),
                ],
              ),
            ),

            // Skills
            if (user?.skills != null && user!.skills.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Навыки', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: user.skills.map((skill) => Chip(
                        label: Text(skill, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      )).toList(),
                    ),
                  ],
                ),
              ),

            // Specializations summary
            if (testData.specializations.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Специализации', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        TextButton(onPressed: () => context.push(AppRoutes.specializations), child: const Text('Все')),
                      ],
                    ),
                    ...testData.specializations.take(3).map((s) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Icon(Icons.work_outline, color: s.verificationStatus == 'verified' ? AppColors.success : AppColors.orange, size: 20),
                      title: Text(s.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      subtitle: Text(s.subject, style: const TextStyle(fontSize: 12)),
                      trailing: _buildVerifChip(s.verificationStatus),
                    )),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildMenuItem(context, Icons.edit_outlined, 'Редактировать профиль', () => context.push(AppRoutes.editExpertProfile)),
                  _buildMenuItem(context, Icons.assignment_ind, 'Анкета эксперта', () => context.push(AppRoutes.expertApplicationView)),
                  _buildMenuItem(context, Icons.category_outlined, 'Специализации', () => context.push(AppRoutes.specializations)),
                  _buildMenuItem(context, Icons.description_outlined, 'Документы', () => context.push(AppRoutes.expertDocuments)),
                  _buildMenuItem(context, Icons.star_outline, 'Отзывы обо мне', () => context.push(AppRoutes.expertReviews)),
                  _buildMenuItem(context, Icons.account_balance_wallet_outlined, 'Финансы', () => context.push(AppRoutes.expertFinance)),
                  _buildMenuItem(context, Icons.people_outline, 'Друзья', () => context.push(AppRoutes.friends)),
                  _buildMenuItem(context, Icons.store_outlined, 'Магазин работ', () => context.push(AppRoutes.expertShopWorks)),
                  _buildMenuItem(context, Icons.gavel_outlined, 'Арбитраж', () => context.push(AppRoutes.expertArbitration)),
                  _buildMenuItem(context, Icons.lock_outline, 'Сменить пароль', () => context.push(AppRoutes.changePassword)),
                  _buildMenuItem(context, Icons.notifications_outlined, 'Уведомления', () => context.push(AppRoutes.notifications)),
                  _buildMenuItem(context, Icons.support_agent, 'Поддержка', () => context.push(AppRoutes.supportCenter)),
                  const SizedBox(height: 8),
                  const Divider(),
                  _buildMenuItem(context, Icons.logout, 'Выйти', () async {
                    await authProvider.logout();
                    if (context.mounted) context.go(AppRoutes.login);
                  }, iconColor: AppColors.error, titleColor: AppColors.error),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(64)),
      child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }

  Widget _buildVerificationBadge(BuildContext context, String status) {
    final labels = {'none': 'Не верифицирован', 'pending': 'На проверке', 'verified': 'Верифицирован', 'rejected': 'Отклонён'};
    final colors = {'none': Colors.grey, 'pending': AppColors.orange, 'verified': AppColors.success, 'rejected': AppColors.error};
    final icons = {'none': Icons.help_outline, 'pending': Icons.hourglass_empty, 'verified': Icons.verified, 'rejected': Icons.cancel};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: (colors[status] ?? Colors.grey).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(64)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icons[status] ?? Icons.help_outline, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(labels[status] ?? status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Flexible(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildVerifChip(String status) {
    final labels = {'pending': 'На проверке', 'verified': 'Подтверждена', 'rejected': 'Отклонена'};
    final colors = {'pending': AppColors.orange, 'verified': AppColors.success, 'rejected': AppColors.error};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: (colors[status] ?? AppColors.textSecondary).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
      child: Text(labels[status] ?? status, style: TextStyle(fontSize: 11, color: colors[status] ?? AppColors.textSecondary, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color? iconColor, Color? titleColor}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: titleColor ?? AppColors.textPrimary, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
