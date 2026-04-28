import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';
import 'package:intl/intl.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DirectorTestDataProvider>();
    final kpi = data.kpi;
    final fmt = NumberFormat('#,##0', 'ru');

    if (kpi == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('KPI Платформы', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('Апрель 2026', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _KPIValue('${fmt.format(kpi.totalOrders)}', 'Всего заказов')),
                  Expanded(child: _KPIValue('${fmt.format(kpi.avgCheck)} ₽', 'Средний чек')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _KPIValue('${kpi.conversionRate}%', 'Конверсия')),
                  Expanded(child: _KPIValue('${kpi.activeUsers}', 'Активных')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Сводный отчёт', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _StatRow(icon: Icons.person_add, label: 'Новых пользователей', value: '${kpi.newUsersThisMonth}', color: const Color(0xFF4CAF50)),
        _StatRow(icon: Icons.check_circle, label: 'Завершённых заказов', value: '${kpi.completedOrdersThisMonth}', color: AppColors.primary),
        _StatRow(icon: Icons.monetization_on, label: 'Выручка за месяц', value: '${fmt.format(kpi.revenueThisMonth)} ₽', color: const Color(0xFFFF9800)),
        _StatRow(icon: Icons.trending_up, label: 'Прибыль за месяц', value: '${fmt.format(kpi.profitThisMonth)} ₽', color: const Color(0xFF7B1FA2)),
        const SizedBox(height: 16),
        const Text('Динамика', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _TrendRow('Заказы (мес.)', '+12%', true),
              _TrendRow('Средний чек', '+5.3%', true),
              _TrendRow('Конверсия', '-1.2%', false),
              _TrendRow('Новые пользователи', '+18%', true),
              _TrendRow('Выручка', '+8.5%', true),
            ],
          ),
        ),
      ],
    );
  }
}

class _KPIValue extends StatelessWidget {
  final String value;
  final String label;
  const _KPIValue(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatRow({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          radius: 18,
          child: Icon(icon, color: color, size: 18),
        ),
        title: Text(label, style: const TextStyle(fontSize: 14)),
        trailing: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
      ),
    );
  }
}

class _TrendRow extends StatelessWidget {
  final String label;
  final String change;
  final bool isPositive;
  const _TrendRow(this.label, this.change, this.isPositive);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(isPositive ? Icons.trending_up : Icons.trending_down, color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(change, style: TextStyle(fontWeight: FontWeight.w600, color: isPositive ? const Color(0xFF4CAF50) : const Color(0xFFE53935), fontSize: 13)),
        ],
      ),
    );
  }
}
