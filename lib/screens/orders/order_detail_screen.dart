import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/orders_provider.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/app_error.dart';
import 'package:oko_znaniy_mobile/widgets/status_badge.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchOrderDetail(widget.orderId);
    });
  }

  Color _statusColor(String status) {
    const colors = {
      'new': Colors.green,
      'confirming': Colors.orange,
      'in_progress': Colors.purple,
      'waiting_payment': Colors.amber,
      'review': Colors.cyan,
      'completed': Colors.green,
      'revision': Colors.pink,
      'cancelled': Colors.red,
      'dispute': Colors.deepOrange,
    };
    return colors[status] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrdersProvider>();
    final authProvider = context.watch<AuthProvider>();
    final order = ordersProvider.currentOrder;

    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ #${widget.orderId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              // TODO: navigate to order chat
            },
          ),
        ],
      ),
      body: ordersProvider.isLoading
          ? const AppLoading(message: 'Загрузка заказа...')
          : ordersProvider.error != null
              ? AppError(
                  message: ordersProvider.error!,
                  onRetry: () => ordersProvider.fetchOrderDetail(widget.orderId),
                )
              : order == null
                  ? const AppError(message: 'Заказ не найден')
                  : RefreshIndicator(
                      onRefresh: () =>
                          ordersProvider.fetchOrderDetail(widget.orderId),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Status
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    order.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                StatusBadge(
                                  label: order.statusLabel,
                                  color: _statusColor(order.status),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Info cards
                            _buildInfoRow('Тип работы', order.workType),
                            _buildInfoRow('Предмет', order.subject),
                            _buildInfoRow('Приоритет', order.priorityLabel),
                            if (order.deadline != null)
                              _buildInfoRow(
                                'Дедлайн',
                                DateFormat('dd.MM.yyyy').format(order.deadline!),
                              ),
                            if (order.price != null)
                              _buildInfoRow(
                                'Стоимость',
                                '${order.price!.toStringAsFixed(0)} \u20BD',
                              ),
                            if (order.clientName != null)
                              _buildInfoRow('Заказчик', order.clientName!),
                            if (order.expertName != null)
                              _buildInfoRow('Эксперт', order.expertName!),

                            const Divider(height: 32),

                            // Description
                            Text(
                              'Описание',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(order.description),
                            const SizedBox(height: 24),

                            // Files section
                            Text(
                              'Файлы (${order.filesCount})',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            if (order.filesCount == 0)
                              const Text(
                                'Файлы не прикреплены',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            const SizedBox(height: 24),

                            // Action buttons
                            if (order.status == 'new' &&
                                authProvider.user?.role == 'expert')
                              ElevatedButton(
                                onPressed: () async {
                                  await ordersProvider.takeOrder(order.id);
                                },
                                child: const Text('Взять заказ'),
                              ),
                            if (order.status == 'review' &&
                                order.clientId == authProvider.user?.id)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: approve
                                      },
                                      child: const Text('Принять'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        // TODO: revision
                                      },
                                      child: const Text('На доработку'),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
