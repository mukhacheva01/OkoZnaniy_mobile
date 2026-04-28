import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/widgets/status_badge.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  Color _statusColor(String status) {
    const colors = {
      'new': Colors.green, 'confirming': Colors.orange, 'in_progress': Colors.purple,
      'waiting_payment': Colors.amber, 'review': Colors.cyan, 'completed': Colors.green,
      'revision': Colors.pink, 'closed': Colors.grey, 'cancelled': Colors.red,
    };
    return colors[status] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isTest = context.watch<AuthProvider>().isTestUser;
    final testData = context.watch<TestDataProvider>();
    final order = isTest ? testData.getOrderById(orderId) : null;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Заказ #$orderId')),
        body: const Center(child: Text('Заказ не найден')),
      );
    }

    final bids = testData.getBidsForOrder(orderId);
    final files = testData.getFilesForOrder(orderId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ #${order.id}'),
        actions: [
          if (order.expertId != null)
            IconButton(icon: const Icon(Icons.chat_bubble_outline), onPressed: () => context.push('/chats/1')),
          PopupMenuButton<String>(
            onSelected: (action) {
              switch (action) {
                case 'delete':
                  if (order.status == 'new' || order.status == 'completed' || order.status == 'closed') {
                    testData.deleteOrder(orderId);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заказ удалён')));
                    context.pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Можно удалить только новые или завершённые заказы')));
                  }
                  break;
                case 'freeze':
                  testData.updateOrderStatus(orderId, 'closed');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заказ заморожен')));
                  break;
                case 'complaint':
                  context.push('/orders/$orderId/complaint');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'freeze', child: Text('Заморозить заказ')),
              const PopupMenuItem(value: 'complaint', child: Text('Подать жалобу')),
              const PopupMenuItem(value: 'delete', child: Text('Удалить заказ')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(order.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                StatusBadge(label: order.statusLabel, color: _statusColor(order.status)),
              ],
            ),
            const SizedBox(height: 16),

            _info('Тип работы', order.workType),
            _info('Предмет', order.subject),
            if (order.deadline != null) _info('Дедлайн', DateFormat('dd.MM.yyyy HH:mm').format(order.deadline!)),
            if (order.price != null) _info('Стоимость', '${order.price!.toStringAsFixed(0)} ₽'),
            if (order.budget != null && order.price == null) _info('Бюджет', '${order.budget!.toStringAsFixed(0)} ₽'),
            if (order.expertName != null) _info('Эксперт', order.expertName!),

            const Divider(height: 32),
            Text('Описание', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(order.description, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),

            // Bids
            if (bids.isNotEmpty && order.status == 'new') ...[
              const Divider(height: 32),
              Text('Ставки экспертов (${bids.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...bids.map((bid) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: const Icon(Icons.person, size: 20, color: AppColors.primary)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bid.expertName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text('★ ${bid.expertRating} · ${bid.expertCompletedOrders} заказов', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Text('${bid.price.toStringAsFixed(0)} ₽', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Срок: ${bid.days} дн.', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text(bid.comment, style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: ElevatedButton(
                            onPressed: () {
                              testData.acceptBid(bid);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${bid.expertName} назначена экспертом')));
                            },
                            style: ElevatedButton.styleFrom(minimumSize: const Size(0, 36)),
                            child: const Text('Принять'),
                          )),
                          const SizedBox(width: 8),
                          Expanded(child: OutlinedButton(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ставка отклонена'))),
                            style: OutlinedButton.styleFrom(minimumSize: const Size(0, 36)),
                            child: const Text('Отклонить'),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
            ],

            // Files
            if (files.isNotEmpty) ...[
              const Divider(height: 32),
              Text('Файлы (${files.length})', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...files.map((f) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(_fileIcon(f.name), color: AppColors.primary),
                title: Text(f.name, style: const TextStyle(fontSize: 14)),
                subtitle: Text('${f.sizeLabel} · ${DateFormat('dd.MM.yyyy').format(f.uploadedAt)}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                trailing: IconButton(icon: const Icon(Icons.download), onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Скачивание (демо)')))),
              )),
            ],

            // Actions
            const SizedBox(height: 24),
            if (order.status == 'review') ...[
              ElevatedButton(
                onPressed: () {
                  testData.updateOrderStatus(orderId, 'completed');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Работа принята!')));
                },
                child: const Text('Принять работу'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _showRevisionDialog(context, testData),
                child: const Text('Отправить на доработку'),
              ),
            ],
            if (order.status == 'waiting_payment')
              ElevatedButton(
                onPressed: () {
                  testData.updateOrderStatus(orderId, 'in_progress');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Оплата произведена')));
                },
                child: const Text('Оплатить'),
              ),
            if (order.status == 'completed')
              ElevatedButton(
                onPressed: () => context.push(AppRoutes.reviews),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
                child: const Text('Оставить отзыв'),
              ),
          ],
        ),
      ),
    );
  }

  void _showRevisionDialog(BuildContext context, TestDataProvider testData) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Доработка'),
        content: TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(hintText: 'Опишите замечания...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              testData.updateOrderStatus(orderId, 'revision');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Отправлено на доработку')));
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 14))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        ],
      ),
    );
  }

  IconData _fileIcon(String name) {
    if (name.endsWith('.pdf')) return Icons.picture_as_pdf;
    if (name.endsWith('.docx') || name.endsWith('.doc')) return Icons.description;
    if (name.endsWith('.jpg') || name.endsWith('.png')) return Icons.image;
    if (name.endsWith('.zip') || name.endsWith('.rar')) return Icons.archive;
    return Icons.insert_drive_file;
  }
}
