import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/admin_models.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class OrdersManagementSection extends StatefulWidget {
  const OrdersManagementSection({super.key});

  @override
  State<OrdersManagementSection> createState() => _OrdersManagementSectionState();
}

class _OrdersManagementSectionState extends State<OrdersManagementSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Все (${data.orders.length})'),
            Tab(text: 'Проблемные (${data.problemOrders.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _OrdersList(orders: data.orders),
              _OrdersList(orders: data.problemOrders),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrdersList extends StatelessWidget {
  final List<AdminOrder> orders;
  const _OrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];
        return Card(
          child: InkWell(
            onTap: () => _showOrderDetail(context, o),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('#${o.id} ${o.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                      _StatusBadge(o.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(o.clientName, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      if (o.expertName != null) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.school_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(o.expertName!, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (o.price != null) Text('${o.price!.toStringAsFixed(0)} ₽', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                      const Spacer(),
                      if (o.deadline != null) Text('Дедлайн: ${DateFormat('dd.MM.yyyy').format(o.deadline!)}', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                    ],
                  ),
                  if (o.isProblem) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFFE53935).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text(o.problemType ?? 'Проблема', style: const TextStyle(fontSize: 11, color: Color(0xFFE53935))),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOrderDetail(BuildContext context, AdminOrder order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (ctx, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text('#${order.id} ${order.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _DetailRow('Статус', order.status),
              _DetailRow('Клиент', order.clientName),
              if (order.expertName != null) _DetailRow('Эксперт', order.expertName!),
              if (order.price != null) _DetailRow('Стоимость', '${order.price!.toStringAsFixed(0)} ₽'),
              if (order.deadline != null) _DetailRow('Дедлайн', DateFormat('dd.MM.yyyy').format(order.deadline!)),
              _DetailRow('Создан', DateFormat('dd.MM.yyyy').format(order.createdAt)),
              if (order.isProblem) _DetailRow('Проблема', order.problemType ?? '-'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text('Сменить статус', style: Theme.of(ctx).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['new', 'in_progress', 'on_review', 'completed', 'frozen', 'closed'].map((status) {
                  final isActive = order.status == status;
                  return ChoiceChip(
                    label: Text(_statusLabel(status)),
                    selected: isActive,
                    onSelected: isActive ? null : (_) {
                      context.read<AdminTestDataProvider>().changeOrderStatus(order.id, status);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Статус заказа #${order.id} изменён на ${_statusLabel(status)}')));
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _statusLabel(String status) {
    const labels = {
      'new': 'Новый',
      'in_progress': 'В работе',
      'on_review': 'На проверке',
      'completed': 'Завершён',
      'overdue': 'Просрочен',
      'frozen': 'Заморожен',
      'closed': 'Закрыт',
      'dispute': 'Спор',
    };
    return labels[status] ?? status;
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  Color get _color {
    switch (status) {
      case 'new': return AppColors.primary;
      case 'in_progress': return const Color(0xFFFF9800);
      case 'on_review': return const Color(0xFF9C27B0);
      case 'completed': return const Color(0xFF4CAF50);
      case 'overdue': return const Color(0xFFE53935);
      case 'frozen': return const Color(0xFF607D8B);
      case 'dispute': return const Color(0xFFE53935);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: _color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(_OrdersList._statusLabel(status), style: TextStyle(fontSize: 11, color: _color, fontWeight: FontWeight.w500)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}
