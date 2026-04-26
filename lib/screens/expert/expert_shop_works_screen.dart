import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertShopWorksScreen extends StatelessWidget {
  const ExpertShopWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final works = testData.shopWorks;

    return Scaffold(
      appBar: AppBar(title: const Text('Магазин готовых работ')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, testData, null),
        child: const Icon(Icons.add),
      ),
      body: works.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.store_outlined, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text('Нет работ в магазине'),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: () => _showAddEditDialog(context, testData, null), icon: const Icon(Icons.add), label: const Text('Добавить работу')),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: works.length,
              itemBuilder: (context, index) {
                final w = works[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(w.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
                              child: Text('${w.price.toStringAsFixed(0)} ₽', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(w.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        Row(children: [
                          _buildTag(Icons.book_outlined, w.subject),
                          const SizedBox(width: 8),
                          _buildTag(Icons.assignment_outlined, w.workType),
                        ]),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.shopping_cart_outlined, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text('Продано: ${w.salesCount}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () => _showAddEditDialog(context, testData, w),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Изменить', style: TextStyle(fontSize: 12)),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                testData.deleteShopWork(w.id);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Работа удалена')));
                              },
                              icon: Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                              label: Text('Удалить', style: TextStyle(fontSize: 12, color: AppColors.error)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(64)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: AppColors.primary)),
      ]),
    );
  }

  void _showAddEditDialog(BuildContext context, TestDataProvider testData, ShopWork? work) {
    final titleCtrl = TextEditingController(text: work?.title ?? '');
    final descCtrl = TextEditingController(text: work?.description ?? '');
    final subjectCtrl = TextEditingController(text: work?.subject ?? '');
    final typeCtrl = TextEditingController(text: work?.workType ?? '');
    final priceCtrl = TextEditingController(text: work != null ? work.price.toStringAsFixed(0) : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(work == null ? 'Добавить работу' : 'Редактировать работу'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Название *')),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Описание'), maxLines: 3),
              const SizedBox(height: 8),
              TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: 'Предмет *')),
              const SizedBox(height: 8),
              TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Тип работы *')),
              const SizedBox(height: 8),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Цена (₽) *'), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;
              final newWork = ShopWork(
                id: work?.id ?? DateTime.now().millisecondsSinceEpoch,
                title: titleCtrl.text,
                description: descCtrl.text,
                subject: subjectCtrl.text,
                workType: typeCtrl.text,
                price: double.tryParse(priceCtrl.text) ?? 0,
                salesCount: work?.salesCount ?? 0,
                createdAt: work?.createdAt ?? DateTime.now(),
              );
              if (work == null) {
                testData.addShopWork(newWork);
              } else {
                testData.updateShopWork(work.id, newWork);
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(work == null ? 'Работа добавлена' : 'Работа обновлена')));
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
