import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/providers/orders_provider.dart';
import 'package:oko_znaniy_mobile/widgets/order_card.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';

class OrdersFeedScreen extends StatefulWidget {
  const OrdersFeedScreen({super.key});

  @override
  State<OrdersFeedScreen> createState() => _OrdersFeedScreenState();
}

class _OrdersFeedScreenState extends State<OrdersFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchAvailableOrders(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Лента заказов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: filters
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchAvailableOrders(refresh: true),
        child: provider.isLoading && provider.availableOrders.isEmpty
            ? const AppLoading(message: 'Загрузка заказов...')
            : provider.availableOrders.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: 'Нет доступных заказов',
                    subtitle: 'Новые заказы появятся здесь',
                  )
                : ListView.builder(
                    itemCount: provider.availableOrders.length,
                    itemBuilder: (context, index) {
                      return OrderCard(order: provider.availableOrders[index]);
                    },
                  ),
      ),
    );
  }
}
