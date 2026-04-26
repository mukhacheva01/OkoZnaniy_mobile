import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:intl/intl.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final testData = context.watch<TestDataProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Финансы')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance cards
            Row(
              children: [
                Expanded(child: _balanceCard(context, 'Баланс', '${user?.balance.toStringAsFixed(0) ?? "0"} ₽', AppColors.success, Icons.account_balance_wallet)),
                const SizedBox(width: 12),
                Expanded(child: _balanceCard(context, 'Заморожено', '${user?.frozenBalance.toStringAsFixed(0) ?? "0"} ₽', AppColors.orange, Icons.lock_outline)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(
                  onPressed: () => _showTopUpDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Пополнить'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(0, 44)),
                )),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => _showWithdrawDialog(context),
                  icon: const Icon(Icons.arrow_downward, size: 18),
                  label: const Text('Вывести'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44)),
                )),
              ],
            ),
            const SizedBox(height: 24),

            Text('История транзакций', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (testData.transactions.isEmpty)
              Center(child: Padding(padding: const EdgeInsets.all(32), child: Text('Нет транзакций', style: TextStyle(color: AppColors.textSecondary))))
            else
              ...testData.transactions.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: (t.amount >= 0 ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(_txIcon(t.type), color: t.amount >= 0 ? AppColors.success : AppColors.error, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.typeLabel, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                          Text(t.description, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${t.amount >= 0 ? "+" : ""}${t.amount.toStringAsFixed(0)} ₽',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: t.amount >= 0 ? AppColors.success : AppColors.error),
                        ),
                        Text(DateFormat('dd.MM.yy').format(t.createdAt), style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _balanceCard(BuildContext context, String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  IconData _txIcon(String type) {
    switch (type) {
      case 'deposit': return Icons.arrow_upward;
      case 'withdrawal': return Icons.arrow_downward;
      case 'freeze': return Icons.lock;
      case 'unfreeze': return Icons.lock_open;
      case 'payment': return Icons.payment;
      case 'commission': return Icons.receipt;
      case 'refund': return Icons.replay;
      default: return Icons.swap_horiz;
    }
  }

  void _showTopUpDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Пополнить баланс'),
        content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Сумма (₽)', prefixIcon: Icon(Icons.attach_money))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                context.read<TestDataProvider>().addTransaction(Transaction(
                  id: DateTime.now().millisecondsSinceEpoch,
                  type: 'deposit',
                  amount: amount,
                  description: 'Пополнение баланса',
                  createdAt: DateTime.now(),
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Баланс пополнен на ${amount.toStringAsFixed(0)} ₽')));
              }
            },
            child: const Text('Пополнить'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Вывод средств'),
        content: TextField(controller: controller, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Сумма (₽)', prefixIcon: Icon(Icons.attach_money))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                context.read<TestDataProvider>().addTransaction(Transaction(
                  id: DateTime.now().millisecondsSinceEpoch,
                  type: 'withdrawal',
                  amount: -amount,
                  description: 'Вывод средств',
                  createdAt: DateTime.now(),
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заявка на вывод ${amount.toStringAsFixed(0)} ₽ создана')));
              }
            },
            child: const Text('Вывести'),
          ),
        ],
      ),
    );
  }
}
