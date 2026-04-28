import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class EarningsSection extends StatelessWidget {
  const EarningsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    final earnings = data.earnings;
    final unpaid = earnings.where((e) => !e.isPaid).toList();
    final totalUnpaid = unpaid.fold<double>(0, (sum, e) => sum + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFFFB74D)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('К выплате', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  Text('${totalUnpaid.toStringAsFixed(0)} ₽', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('${unpaid.length} начислений', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Все начисления (${earnings.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: earnings.length,
            itemBuilder: (context, index) {
              final e = earnings[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: e.isPaid ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : const Color(0xFFFF9800).withValues(alpha: 0.1),
                    child: Icon(e.isPaid ? Icons.check_circle : Icons.schedule, color: e.isPaid ? const Color(0xFF4CAF50) : const Color(0xFFFF9800)),
                  ),
                  title: Text('${e.partnerName} → ${e.referralName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  subtitle: Text('${e.type == 'order_commission' ? 'Комиссия с заказа' : 'Бонус за регистрацию'} · ${DateFormat('dd.MM.yyyy').format(e.createdAt)}', style: const TextStyle(fontSize: 11)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${e.amount.toStringAsFixed(0)} ₽', style: TextStyle(fontWeight: FontWeight.bold, color: e.isPaid ? const Color(0xFF4CAF50) : AppColors.textPrimary)),
                      if (!e.isPaid) ...[
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.check, size: 20),
                          color: const Color(0xFF4CAF50),
                          onPressed: () {
                            context.read<AdminTestDataProvider>().markEarningPaid(e.id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Начисление #${e.id} отмечено как выплаченное')));
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
