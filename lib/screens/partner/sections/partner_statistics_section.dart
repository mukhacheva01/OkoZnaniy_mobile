import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';
import 'package:intl/intl.dart';

class PartnerStatisticsSection extends StatefulWidget {
  const PartnerStatisticsSection({super.key});

  @override
  State<PartnerStatisticsSection> createState() => _PartnerStatisticsSectionState();
}

class _PartnerStatisticsSectionState extends State<PartnerStatisticsSection> {
  String _period = 'all';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PartnerTestDataProvider>();
    final stats = data.stats;
    final fmt = NumberFormat('#,##0', 'ru');

    if (stats == null) return const Center(child: CircularProgressIndicator());

    final filteredEarnings = _filterEarnings(data.earnings);
    final filteredTotal = filteredEarnings.fold<double>(0, (s, e) => s + (e.isCancelled ? 0 : e.amount));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _StatCard('${stats.totalReferrals}', 'Всего рефералов', const Color(0xFF2E7D32))),
            const SizedBox(width: 8),
            Expanded(child: _StatCard('${stats.activeReferrals}', 'Активных', const Color(0xFF1E88E5))),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _StatCard('${fmt.format(stats.totalEarned)} ₽', 'Заработано', const Color(0xFFFF9800))),
            const SizedBox(width: 8),
            Expanded(child: _StatCard('${fmt.format(stats.pendingPayout)} ₽', 'К выплате', const Color(0xFF7B1FA2))),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Период', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _PeriodChip('Всё время', 'all'),
            _PeriodChip('7 дней', '7d'),
            _PeriodChip('30 дней', '30d'),
            _PeriodChip('Этот месяц', 'month'),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('За выбранный период', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text('${fmt.format(filteredTotal)} ₽', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
              Text('${filteredEarnings.length} операций', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _PeriodChip(String label, String value) {
    final isSelected = _period == value;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : null)),
      selected: isSelected,
      selectedColor: const Color(0xFF2E7D32),
      onSelected: (_) => setState(() => _period = value),
    );
  }

  List _filterEarnings(List earnings) {
    final now = DateTime.now();
    switch (_period) {
      case '7d': return earnings.where((e) => now.difference(e.createdAt).inDays <= 7).toList();
      case '30d': return earnings.where((e) => now.difference(e.createdAt).inDays <= 30).toList();
      case 'month': return earnings.where((e) => e.createdAt.month == now.month && e.createdAt.year == now.year).toList();
      default: return earnings;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final Color color;
  const _StatCard(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          FittedBox(child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color))),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
