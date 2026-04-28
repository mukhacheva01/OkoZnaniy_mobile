import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';
import 'package:intl/intl.dart';

class ReferralsSection extends StatelessWidget {
  const ReferralsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PartnerTestDataProvider>();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                Text('${data.referrals.length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                Text('Всего', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
              Column(children: [
                Text('${data.referrals.where((r) => r.role == "client").length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E88E5))),
                Text('Клиентов', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
              Column(children: [
                Text('${data.referrals.where((r) => r.role == "expert").length}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFFF9800))),
                Text('Экспертов', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ]),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: data.referrals.length,
            itemBuilder: (context, index) {
              final r = data.referrals[index];
              final isExpert = r.role == 'expert';
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isExpert ? const Color(0xFFFF9800).withValues(alpha: 0.1) : const Color(0xFF1E88E5).withValues(alpha: 0.1),
                    radius: 18,
                    child: Text(r.username[0], style: TextStyle(color: isExpert ? const Color(0xFFFF9800) : const Color(0xFF1E88E5), fontWeight: FontWeight.bold)),
                  ),
                  title: Text(r.username, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  subtitle: Text(
                    '${isExpert ? "Эксперт" : "Клиент"} · ${r.ordersCount} заказов · ${DateFormat('dd.MM.yyyy').format(r.registeredAt)}',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isExpert ? const Color(0xFFFF9800).withValues(alpha: 0.1) : const Color(0xFF1E88E5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(isExpert ? 'Эксперт' : 'Клиент', style: TextStyle(fontSize: 10, color: isExpert ? const Color(0xFFFF9800) : const Color(0xFF1E88E5))),
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
