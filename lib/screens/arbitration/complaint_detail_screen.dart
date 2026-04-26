import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:oko_znaniy_mobile/widgets/status_badge.dart';
import 'package:intl/intl.dart';

class ComplaintsListScreen extends StatelessWidget {
  const ComplaintsListScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'open': return Colors.orange;
      case 'in_review': return AppColors.primary;
      case 'resolved': return AppColors.success;
      case 'closed': return Colors.grey;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final complaints = testData.complaints;

    return Scaffold(
      appBar: AppBar(title: const Text('Арбитраж')),
      body: complaints.isEmpty
          ? const EmptyState(icon: Icons.gavel, title: 'Нет жалоб', subtitle: 'Жалобы можно подать из карточки заказа')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final c = complaints[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(c.orderTitle, style: const TextStyle(fontWeight: FontWeight.bold))),
                            StatusBadge(label: c.statusLabel, color: _statusColor(c.status)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Причина: ${c.reason}', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(c.description, style: const TextStyle(height: 1.4)),
                        if (c.resolution != null) ...[
                          const Divider(height: 24),
                          Text('Решение:', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.success)),
                          Text(c.resolution!),
                        ],
                        const SizedBox(height: 8),
                        Text(DateFormat('dd.MM.yyyy HH:mm').format(c.createdAt), style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
