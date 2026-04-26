import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/models/order.dart';

class ExpertWorksScreen extends StatefulWidget {
  const ExpertWorksScreen({super.key});

  @override
  State<ExpertWorksScreen> createState() => _ExpertWorksScreenState();
}

class _ExpertWorksScreenState extends State<ExpertWorksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _statusFilters = [
    {'key': 'all', 'label': 'Все'},
    {'key': 'confirming', 'label': 'На подтв.'},
    {'key': 'in_progress', 'label': 'В работе'},
    {'key': 'review', 'label': 'На проверке'},
    {'key': 'revision', 'label': 'На доработке'},
    {'key': 'waiting_payment', 'label': 'Ожид. оплаты'},
    {'key': 'completed', 'label': 'Выполненные'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusFilters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final isTest = context.watch<AuthProvider>().isTestUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои работы'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _statusFilters.map((f) => Tab(text: f['label'])).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusFilters.map((filter) {
          final status = filter['key'];
          final orders = isTest ? testData.getExpertOrdersByStatus(status) : <Order>[];
          final now = DateTime.now();
          final overdueOrders = orders.where((o) => o.deadline != null && o.deadline!.isBefore(now) && o.status != 'completed' && o.status != 'closed').toList();

          return orders.isEmpty
              ? Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment_outlined, size: 48, color: AppColors.textTertiary),
                    const SizedBox(height: 8),
                    const Text('Нет заказов'),
                  ],
                ))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (overdueOrders.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error.withValues(alpha: 0.2))),
                        child: Row(children: [
                          Icon(Icons.warning_amber, color: AppColors.error),
                          const SizedBox(width: 8),
                          Text('Просроченных: ${overdueOrders.length}', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                      const SizedBox(height: 12),
                    ],
                    ...orders.map((order) => _buildWorkCard(context, order, testData, now)),
                  ],
                );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkCard(BuildContext context, Order order, TestDataProvider testData, DateTime now) {
    final isOverdue = order.deadline != null && order.deadline!.isBefore(now) && order.status != 'completed' && order.status != 'closed';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: isOverdue ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.error.withValues(alpha: 0.5))) : null,
      child: InkWell(
        onTap: () => context.push('/orders/${order.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(order.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
                  _buildStatusChip(order.status, order.statusLabel),
                ],
              ),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('Клиент: ${order.clientName ?? "-"}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.book_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${order.subject} • ${order.workType}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ]),
              if (order.price != null) ...[
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.attach_money, size: 14, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text('${order.price!.toStringAsFixed(0)} ₽', style: TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600)),
                ]),
              ],
              if (order.deadline != null) ...[
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.schedule, size: 14, color: isOverdue ? AppColors.error : AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('Дедлайн: ${_formatDate(order.deadline!)}', style: TextStyle(fontSize: 12, color: isOverdue ? AppColors.error : AppColors.textSecondary, fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal)),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(4)),
                      child: const Text('Просрочен', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ]),
              ],
              const SizedBox(height: 8),
              // Actions
              if (order.status == 'in_progress' || order.status == 'revision')
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        testData.updateOrderStatus(order.id, 'review');
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Работа отправлена на проверку')));
                      },
                      icon: const Icon(Icons.send, size: 16),
                      label: const Text('На проверку', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    final colors = {
      'new': AppColors.primary, 'confirming': AppColors.orange, 'in_progress': AppColors.primary,
      'review': AppColors.purple, 'revision': AppColors.orange, 'waiting_payment': AppColors.success,
      'completed': AppColors.success, 'closed': AppColors.textSecondary,
    };
    final color = colors[status] ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
