import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertFinanceScreen extends StatefulWidget {
  const ExpertFinanceScreen({super.key});

  @override
  State<ExpertFinanceScreen> createState() => _ExpertFinanceScreenState();
}

class _ExpertFinanceScreenState extends State<ExpertFinanceScreen> with SingleTickerProviderStateMixin {
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
    final user = context.watch<AuthProvider>().user;
    final testData = context.watch<TestDataProvider>();
    final transactions = testData.expertTransactions;
    final earnings = transactions.where((t) => t.type == 'earning').fold(0.0, (sum, t) => sum + t.amount);
    final commissions = transactions.where((t) => t.type == 'commission').fold(0.0, (sum, t) => sum + t.amount.abs());
    final withdrawals = transactions.where((t) => t.type == 'withdrawal').fold(0.0, (sum, t) => sum + t.amount.abs());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансы'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Обзор'), Tab(text: 'Транзакции')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Overview tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      const Text('Текущий баланс', style: TextStyle(color: Colors.white70)),
                      Text('${user?.balance.toStringAsFixed(0) ?? "0"} ₽', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                      if ((user?.frozenBalance ?? 0) > 0) ...[
                        const SizedBox(height: 4),
                        Text('Заморожено: ${user?.frozenBalance.toStringAsFixed(0)} ₽', style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Общий заработок', '${user?.totalEarnings.toStringAsFixed(0) ?? "0"} ₽', AppColors.success, Icons.trending_up)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Комиссии', '${commissions.toStringAsFixed(0)} ₽', AppColors.orange, Icons.percent)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Выплаты', '${withdrawals.toStringAsFixed(0)} ₽', AppColors.primary, Icons.account_balance)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildStatCard('Доход (нетто)', '${(earnings - commissions).toStringAsFixed(0)} ₽', AppColors.success, Icons.savings)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showWithdrawDialog(context, testData, user?.balance ?? 0),
                    icon: const Icon(Icons.account_balance_wallet),
                    label: const Text('Вывести средства'),
                  ),
                ),
              ],
            ),
          ),

          // Transactions tab
          transactions.isEmpty
              ? const Center(child: Text('Нет транзакций'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final t = transactions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: _txColor(t.type).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Icon(_txIcon(t.type), color: _txColor(t.type), size: 20),
                        ),
                        title: Text(t.description, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        subtitle: Text(_formatDate(t.createdAt), style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                        trailing: Text(
                          '${t.amount >= 0 ? '+' : ''}${t.amount.toStringAsFixed(0)} ₽',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: t.amount >= 0 ? AppColors.success : AppColors.error),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Color _txColor(String type) {
    const colors = {'earning': AppColors.success, 'commission': AppColors.orange, 'withdrawal': AppColors.primary, 'freeze': AppColors.textSecondary, 'unfreeze': AppColors.primary, 'refund': AppColors.error};
    return colors[type] ?? AppColors.textSecondary;
  }

  IconData _txIcon(String type) {
    const icons = {'earning': Icons.arrow_downward, 'commission': Icons.percent, 'withdrawal': Icons.arrow_upward, 'freeze': Icons.lock, 'unfreeze': Icons.lock_open, 'refund': Icons.undo};
    return icons[type] ?? Icons.swap_horiz;
  }

  void _showWithdrawDialog(BuildContext context, TestDataProvider testData, double balance) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Вывод средств'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Доступно: ${balance.toStringAsFixed(0)} ₽', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            TextField(controller: controller, decoration: const InputDecoration(labelText: 'Сумма (₽)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount == null || amount <= 0 || amount > balance) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Некорректная сумма')));
                return;
              }
              testData.addExpertTransaction(Transaction(
                id: DateTime.now().millisecondsSinceEpoch,
                type: 'withdrawal',
                amount: -amount,
                description: 'Вывод средств',
                createdAt: DateTime.now(),
              ));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заявка на вывод ${amount.toStringAsFixed(0)} ₽ отправлена')));
            },
            child: const Text('Вывести'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
