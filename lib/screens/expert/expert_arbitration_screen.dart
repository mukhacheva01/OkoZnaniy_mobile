import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertArbitrationScreen extends StatelessWidget {
  const ExpertArbitrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final complaints = testData.complaints;

    return Scaffold(
      appBar: AppBar(title: const Text('Арбитраж')),
      body: complaints.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.gavel_outlined, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text('Нет жалоб'),
            ]))
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
                            Expanded(child: Text('Жалоба #${c.id}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
                            _buildStatusChip(c.status, c.statusLabel),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Заказ #${c.orderId}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Text(c.description, style: const TextStyle(fontSize: 14)),

                        if (c.resolution != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.success.withValues(alpha: 0.2))),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Решение арбитража:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.success)),
                              const SizedBox(height: 4),
                              Text(c.resolution!, style: const TextStyle(fontSize: 13)),
                            ]),
                          ),
                        ],

                        if (c.expertResponse != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Ваш ответ:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                              const SizedBox(height: 4),
                              Text(c.expertResponse!, style: const TextStyle(fontSize: 13)),
                            ]),
                          ),
                        ],

                        if (c.status == 'open' && c.expertResponse == null) ...[
                          const SizedBox(height: 12),
                          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            FilledButton.icon(
                              onPressed: () => _showResponseDialog(context, c, testData),
                              icon: const Icon(Icons.reply, size: 16),
                              label: const Text('Ответить'),
                            ),
                          ]),
                        ],

                        const SizedBox(height: 8),
                        Text(_formatDate(c.createdAt), style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    final colors = {'open': AppColors.orange, 'in_review': AppColors.primary, 'resolved': AppColors.success, 'closed': AppColors.textSecondary};
    final color = colors[status] ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  void _showResponseDialog(BuildContext context, Complaint c, TestDataProvider testData) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ответ на жалобу'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Ваш ответ...'), maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                testData.respondToComplaint(c.id, controller.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ответ отправлен')));
              }
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
