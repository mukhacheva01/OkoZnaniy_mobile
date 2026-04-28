import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';
import 'package:intl/intl.dart';

class PartnerEarningsSection extends StatefulWidget {
  const PartnerEarningsSection({super.key});

  @override
  State<PartnerEarningsSection> createState() => _PartnerEarningsSectionState();
}

class _PartnerEarningsSectionState extends State<PartnerEarningsSection> {
  String _sortBy = 'date';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PartnerTestDataProvider>();
    final fmt = NumberFormat('#,##0', 'ru');
    final earnings = List.of(data.earnings);

    if (_sortBy == 'amount') {
      earnings.sort((a, b) => b.amount.compareTo(a.amount));
    } else {
      earnings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final totalPending = earnings.where((e) => !e.isPaid && !e.isCancelled).fold<double>(0, (s, e) => s + e.amount);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF43A047)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: [
                Text('${fmt.format(totalPending)} ₽', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('К выплате', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
              Column(children: [
                Text('${earnings.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('Операций', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Text('Сортировка:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('По дате', style: TextStyle(fontSize: 11)),
                selected: _sortBy == 'date',
                selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                onSelected: (_) => setState(() => _sortBy = 'date'),
              ),
              const SizedBox(width: 4),
              ChoiceChip(
                label: const Text('По сумме', style: TextStyle(fontSize: 11)),
                selected: _sortBy == 'amount',
                selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
                onSelected: (_) => setState(() => _sortBy = 'amount'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: earnings.length,
            itemBuilder: (context, index) {
              final e = earnings[index];
              final isCommission = e.type == 'order_commission';
              final statusColor = e.isCancelled ? Colors.grey : (e.isPaid ? const Color(0xFF4CAF50) : const Color(0xFFFF9800));
              final statusLabel = e.isCancelled ? 'Отменено' : (e.isPaid ? 'Выплачено' : 'Ожидает');

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: e.isCancelled ? Colors.grey.withValues(alpha: 0.1) : (isCommission ? const Color(0xFF2E7D32).withValues(alpha: 0.1) : const Color(0xFF1E88E5).withValues(alpha: 0.1)),
                    radius: 18,
                    child: Icon(isCommission ? Icons.monetization_on : Icons.card_giftcard,
                      color: e.isCancelled ? Colors.grey : (isCommission ? const Color(0xFF2E7D32) : const Color(0xFF1E88E5)), size: 18),
                  ),
                  title: Row(
                    children: [
                      if (e.orderId != null) Text('#${e.orderId} ', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      Expanded(child: Text(e.referralName, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13))),
                    ],
                  ),
                  subtitle: Text(
                    '${isCommission ? "Комиссия" : "Бонус"} · ${DateFormat('dd.MM.yyyy').format(e.createdAt)}',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${e.isCancelled ? "" : "+"}${fmt.format(e.amount)} ₽',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                          color: e.isCancelled ? Colors.grey : const Color(0xFF2E7D32),
                          decoration: e.isCancelled ? TextDecoration.lineThrough : null),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                        child: Text(statusLabel, style: TextStyle(fontSize: 9, color: statusColor)),
                      ),
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
