import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertBidsScreen extends StatelessWidget {
  const ExpertBidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final bids = testData.expertBids;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои ставки')),
      body: bids.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.how_to_vote_outlined, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text('Нет активных ставок'),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final bid = bids[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('Заказ #${bid.orderId}', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
                            _buildStatusChip(bid.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildRow('Сумма', '${bid.price.toStringAsFixed(0)} ₽'),
                        _buildRow('Предоплата', '${bid.prepayPercent}%'),
                        _buildRow('Срок', '${bid.days} дн.'),
                        if (bid.comment.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(bid.comment, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                        const SizedBox(height: 8),
                        Text(_formatDate(bid.createdAt), style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        if (bid.status == 'pending') ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                testData.cancelBid(bid.id);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ставка отменена')));
                              },
                              icon: Icon(Icons.cancel_outlined, size: 16, color: AppColors.error),
                              label: Text('Отменить', style: TextStyle(color: AppColors.error)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final labels = {'pending': 'Ожидает', 'accepted': 'Принята', 'rejected': 'Отклонена', 'cancelled': 'Отменена'};
    final colors = {'pending': AppColors.orange, 'accepted': AppColors.success, 'rejected': AppColors.error, 'cancelled': AppColors.textSecondary};
    final color = colors[status] ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
      child: Text(labels[status] ?? status, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
