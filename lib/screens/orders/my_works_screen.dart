import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/orders_provider.dart';
import 'package:oko_znaniy_mobile/widgets/order_card.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';

class MyWorksScreen extends StatefulWidget {
  const MyWorksScreen({super.key});

  @override
  State<MyWorksScreen> createState() => _MyWorksScreenState();
}

class _MyWorksScreenState extends State<MyWorksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchOrders(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Мои работы')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createOrder),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchOrders(refresh: true),
        child: provider.isLoading && provider.orders.isEmpty
            ? const AppLoading(message: 'Загрузка...')
            : provider.orders.isEmpty
                ? const EmptyState(
                    icon: Icons.assignment_outlined,
                    title: 'Нет работ',
                    subtitle: 'Создайте свой первый заказ',
                  )
                : ListView.builder(
                    itemCount: provider.orders.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: provider.orders[index]);
                    },
                  ),
      ),
    );
  }
}
