import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    final stats = data.stats;

    if (stats == null) {
      return const Center(child: Text('Нет данных'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Обзор платформы', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _StatCard(label: 'Пользователей', value: '${stats.totalUsers}', icon: Icons.people, color: AppColors.primary),
              _StatCard(label: 'Экспертов', value: '${stats.totalExperts}', icon: Icons.school, color: const Color(0xFFFFB34A)),
              _StatCard(label: 'Всего заказов', value: '${stats.totalOrders}', icon: Icons.assignment, color: const Color(0xFF4CAF50)),
              _StatCard(label: 'Активных', value: '${stats.activeOrders}', icon: Icons.hourglass_top, color: const Color(0xFFFF9800)),
              _StatCard(label: 'Открытых тикетов', value: '${stats.openTickets}', icon: Icons.support_agent, color: const Color(0xFFE53935)),
              _StatCard(label: 'Арбитражных дел', value: '${stats.arbitrationCases}', icon: Icons.gavel, color: const Color(0xFF7B1FA2)),
              _StatCard(label: 'Выручка', value: '${_formatMoney(stats.totalRevenue)} ₽', icon: Icons.trending_up, color: const Color(0xFF2E7D32)),
              _StatCard(label: 'Комиссия', value: '${_formatMoney(stats.platformCommission)} ₽', icon: Icons.percent, color: const Color(0xFF1565C0)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Последние события', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _EventTile(icon: Icons.person_add, text: 'Новый пользователь: Козлова Н.', time: '5 мин назад', color: AppColors.primary),
          _EventTile(icon: Icons.assignment_turned_in, text: 'Заказ #103 завершён', time: '15 мин назад', color: const Color(0xFF4CAF50)),
          _EventTile(icon: Icons.warning_amber, text: 'Тикет #1: Не могу оплатить заказ', time: '30 мин назад', color: const Color(0xFFE53935)),
          _EventTile(icon: Icons.gavel, text: 'Новое арбитражное дело #2', time: '1 час назад', color: const Color(0xFF7B1FA2)),
          _EventTile(icon: Icons.handshake, text: 'Партнёр partner_anna: 3 новых реферала', time: '2 часа назад', color: const Color(0xFF2E7D32)),
        ],
      ),
    );
  }

  static String _formatMoney(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(0)}K';
    return amount.toStringAsFixed(0);
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final String time;
  final Color color;

  const _EventTile({required this.icon, required this.text, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 20)),
      title: Text(text, style: const TextStyle(fontSize: 13)),
      trailing: Text(time, style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
    );
  }
}
