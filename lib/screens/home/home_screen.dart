import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/widgets/order_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final testData = context.watch<TestDataProvider>();
    final user = authProvider.user;
    final isTest = authProvider.isTestUser;
    final orders = isTest ? testData.orders.take(3).toList() : [];
    final unreadNotifications = isTest ? testData.notifications.where((n) => !n.isRead).length : 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 32,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.visibility, color: AppColors.primary)),
            const SizedBox(width: 8),
            const Text('Око Знаний'),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () => context.push(AppRoutes.notifications)),
              if (unreadNotifications > 0)
                Positioned(right: 8, top: 8, child: Container(
                  width: 16, height: 16,
                  decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  child: Center(child: Text('$unreadNotifications', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                )),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Привет, ${user?.displayName ?? 'Пользователь'}!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  if (user != null) Text('Баланс: ${user.balance.toStringAsFixed(0)} ₽',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
                  const SizedBox(height: 12),
                  if (user?.role == 'client' || user?.role == null)
                    FilledButton(
                      onPressed: () => context.push(AppRoutes.createOrder),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: AppColors.grey700),
                      child: const Text('Создать заказ'),
                    )
                  else if (user?.role == 'expert')
                    FilledButton(
                      onPressed: () => context.go(AppRoutes.ordersFeed),
                      style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: AppColors.grey700),
                      child: const Text('Найти заказы'),
                    ),
                ],
              ),
            ),

            // Quick actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Быстрые действия', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildQuickAction(context, Icons.add_circle_outline, 'Новый заказ', AppColors.primary, () => context.push(AppRoutes.createOrder)),
                  _buildQuickAction(context, Icons.account_balance_wallet, 'Финансы', AppColors.success, () => context.push(AppRoutes.finance)),
                  _buildQuickAction(context, Icons.people_outline, 'Друзья', AppColors.orange, () => context.push(AppRoutes.friends)),
                  _buildQuickAction(context, Icons.search, 'Эксперты', AppColors.purple, () => context.push(AppRoutes.expertSearch)),
                  _buildQuickAction(context, Icons.school_outlined, 'База знаний', AppColors.primary, () => context.push(AppRoutes.knowledgePortal)),
                  _buildQuickAction(context, Icons.support_agent, 'Поддержка', AppColors.success, () => context.push(AppRoutes.supportCenter)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recent orders
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('Мои заказы', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(onPressed: () => context.go(AppRoutes.myWorks), child: const Text('Все')),
                ],
              ),
            ),

            if (orders.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.assignment_outlined, size: 48, color: AppColors.textTertiary),
                      const SizedBox(height: 8),
                      Text('Пока нет заказов', style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.push(AppRoutes.createOrder),
                        icon: const Icon(Icons.add),
                        label: const Text('Создать первый заказ'),
                        style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: AppColors.grey700),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orders.length,
                itemBuilder: (context, index) => OrderCard(order: orders[index]),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 90,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 6),
              Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
