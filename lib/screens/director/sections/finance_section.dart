import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/director_models.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';
import 'package:intl/intl.dart';

class FinanceSection extends StatelessWidget {
  const FinanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DirectorTestDataProvider>();
    final fmt = NumberFormat('#,##0', 'ru');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _MetricCard('Оборот', '${fmt.format(data.monthlyTurnover)} ₽', const Color(0xFF4CAF50))),
            const SizedBox(width: 8),
            Expanded(child: _MetricCard('Расходы', '${fmt.format(data.monthlyExpenses)} ₽', const Color(0xFFE53935))),
            const SizedBox(width: 8),
            Expanded(child: _MetricCard('Прибыль', '${fmt.format(data.netProfit)} ₽', AppColors.primary)),
          ],
        ),
        const SizedBox(height: 16),
        _SectionHeader('Доходы', onAdd: () => _showAddRecord(context, true)),
        ...data.incomes.map((r) => _RecordTile(record: r, isIncome: true)),
        const SizedBox(height: 16),
        _SectionHeader('Расходы', onAdd: () => _showAddRecord(context, false)),
        ...data.expenses.map((r) => _RecordTile(record: r, isIncome: false)),
      ],
    );
  }

  void _showAddRecord(BuildContext context, bool isIncome) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isIncome ? 'Новый доход' : 'Новый расход'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Категория')),
            const SizedBox(height: 8),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Описание')),
            const SizedBox(height: 8),
            TextField(controller: amountController, decoration: const InputDecoration(labelText: 'Сумма (₽)', suffixText: '₽'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount == null || categoryController.text.isEmpty) return;
              final record = FinanceRecord(
                id: DateTime.now().millisecondsSinceEpoch,
                category: categoryController.text,
                amount: amount,
                description: descController.text,
                date: DateTime.now(),
                isIncome: isIncome,
              );
              final provider = context.read<DirectorTestDataProvider>();
              if (isIncome) { provider.addIncome(record); } else { provider.addExpense(record); }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isIncome ? 'Доход добавлен' : 'Расход добавлен')));
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _MetricCard(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          FittedBox(child: Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color))),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onAdd;
  const _SectionHeader(this.title, {required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const Spacer(),
        TextButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 18), label: const Text('Добавить')),
      ],
    );
  }
}

class _RecordTile extends StatelessWidget {
  final FinanceRecord record;
  final bool isIncome;
  const _RecordTile({required this.record, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0', 'ru');
    final color = isIncome ? const Color(0xFF4CAF50) : const Color(0xFFE53935);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          radius: 18,
          child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: color, size: 18),
        ),
        title: Text(record.category, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        subtitle: Text('${record.description} · ${DateFormat('dd.MM.yyyy').format(record.date)}', style: const TextStyle(fontSize: 11)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${isIncome ? '+' : '-'}${fmt.format(record.amount)} ₽', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              onPressed: () {
                final provider = context.read<DirectorTestDataProvider>();
                if (isIncome) { provider.deleteIncome(record.id); } else { provider.deleteExpense(record.id); }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Запись удалена')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
