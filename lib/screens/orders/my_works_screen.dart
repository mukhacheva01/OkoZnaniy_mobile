import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/widgets/order_card.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';

class MyWorksScreen extends StatefulWidget {
  const MyWorksScreen({super.key});

  @override
  State<MyWorksScreen> createState() => _MyWorksScreenState();
}

class _MyWorksScreenState extends State<MyWorksScreen> {
  String _selectedStatus = 'all';

  final _statuses = {
    'all': 'Все',
    'new': 'Открытые',
    'confirming': 'Подтверждение',
    'in_progress': 'В работе',
    'waiting_payment': 'Ожидает оплаты',
    'review': 'На проверке',
    'completed': 'Выполненные',
    'revision': 'На доработке',
    'download': 'Скачивание',
    'closed': 'Закрытые',
  };

  @override
  Widget build(BuildContext context) {
    final isTest = context.watch<AuthProvider>().isTestUser;
    final testData = context.watch<TestDataProvider>();
    final orders = isTest ? testData.getOrdersByStatus(_selectedStatus) : [];

    return Scaffold(
      appBar: AppBar(title: const Text('Мои заказы')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createOrder),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _statuses.entries.map((e) {
                final selected = e.key == _selectedStatus;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: FilterChip(
                    label: Text(e.value, style: TextStyle(fontSize: 13, color: selected ? Colors.white : AppColors.textPrimary)),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedStatus = e.key),
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: orders.isEmpty
                ? const EmptyState(icon: Icons.assignment_outlined, title: 'Нет заказов', subtitle: 'Создайте свой первый заказ')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: orders.length,
                    itemBuilder: (context, index) => OrderCard(order: orders[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
