import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';
import 'package:intl/intl.dart';

class DirectorPartnersSection extends StatelessWidget {
  const DirectorPartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DirectorTestDataProvider>();
    final fmt = NumberFormat('#,##0', 'ru');

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                Text('${data.partners.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('Партнёров', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
              Column(children: [
                Text('${fmt.format(data.partnersTotalTurnover)} ₽', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('Общий оборот', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
              Column(children: [
                Text('${data.partners.fold<int>(0, (s, p) => s + p.referrals)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('Рефералов', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...data.partners.map((p) => Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: p.isActive ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      radius: 18,
                      child: Text(p.username[0].toUpperCase(), style: TextStyle(color: p.isActive ? const Color(0xFF4CAF50) : Colors.grey)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.username, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(p.email, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: p.isActive ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(p.isActive ? 'Активен' : 'Неактивен', style: TextStyle(fontSize: 10, color: p.isActive ? const Color(0xFF4CAF50) : Colors.grey)),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MiniStat('Рефералов', '${p.referrals}'),
                    _MiniStat('Заработано', '${fmt.format(p.earned)} ₽'),
                    _MiniStat('Выплачено', '${fmt.format(p.paid)} ₽'),
                    _MiniStat('Комиссия', '${p.commissionRate.toStringAsFixed(0)}%'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _showCommissionDialog(context, p.id, p.commissionRate),
                      icon: const Icon(Icons.edit, size: 14),
                      label: const Text('Комиссия', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<DirectorTestDataProvider>().togglePartnerStatus(p.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(p.isActive ? 'Партнёр выключен' : 'Партнёр включён')));
                      },
                      icon: Icon(p.isActive ? Icons.pause : Icons.play_arrow, size: 14),
                      label: Text(p.isActive ? 'Выключить' : 'Включить', style: const TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(visualDensity: VisualDensity.compact),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  void _showCommissionDialog(BuildContext context, int id, double current) {
    final controller = TextEditingController(text: current.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Изменить комиссию'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Комиссия (%)', suffixText: '%'), keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              final rate = double.tryParse(controller.text);
              if (rate != null && rate >= 0 && rate <= 100) {
                context.read<DirectorTestDataProvider>().updatePartnerCommission(id, rate);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Комиссия изменена на ${rate.toStringAsFixed(0)}%')));
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}
