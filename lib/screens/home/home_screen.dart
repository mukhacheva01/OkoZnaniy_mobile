import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/orders_provider.dart';
import 'package:oko_znaniy_mobile/widgets/order_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().fetchOrders(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final ordersProvider = context.watch<OrdersProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.visibility, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text('Око Знаний'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await authProvider.fetchUser();
          await ordersProvider.fetchOrders(refresh: true);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Привет, ${user?.displayName ?? 'Пользователь'}!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user?.role == 'expert'
                          ? 'Найдите новые заказы для выполнения'
                          : 'Разместите задание и получите помощь',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    if (user?.role == 'client' || user?.role == null)
                      ElevatedButton(
                        onPressed: () => context.push(AppRoutes.createOrder),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                        ),
                        child: const Text('Создать заказ'),
                      )
                    else if (user?.role == 'expert')
                      ElevatedButton(
                        onPressed: () => context.go(AppRoutes.ordersFeed),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                        ),
                        child: const Text('Найти заказы'),
                      ),
                  ],
                ),
              ),

              // Quick actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Быстрые действия',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildQuickAction(
                      context,
                      Icons.add_circle_outline,
                      'Новый заказ',
                      () => context.push(AppRoutes.createOrder),
                    ),
                    _buildQuickAction(
                      context,
                      Icons.store_outlined,
                      'Магазин работ',
                      () => context.go(AppRoutes.shop),
                    ),
                    _buildQuickAction(
                      context,
                      Icons.school_outlined,
                      'База знаний',
                      () => context.push(AppRoutes.knowledgePortal),
                    ),
                    _buildQuickAction(
                      context,
                      Icons.support_agent,
                      'Поддержка',
                      () => context.push(AppRoutes.supportCenter),
                    ),
                    _buildQuickAction(
                      context,
                      Icons.star_outline,
                      'Стать экспертом',
                      () => context.push(AppRoutes.becomeExpert),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Recent orders
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Мои заказы',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.myWorks),
                      child: const Text('Все'),
                    ),
                  ],
                ),
              ),

              if (ordersProvider.isLoading && ordersProvider.orders.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (ordersProvider.orders.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.assignment_outlined,
                            size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                        const SizedBox(height: 8),
                        Text(
                          'Пока нет заказов',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      ordersProvider.orders.length > 5 ? 5 : ordersProvider.orders.length,
                  itemBuilder: (context, index) {
                    return OrderCard(order: ordersProvider.orders[index]);
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 90,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
