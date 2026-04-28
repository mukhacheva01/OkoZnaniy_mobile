import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';

class CatalogSection extends StatefulWidget {
  const CatalogSection({super.key});

  @override
  State<CatalogSection> createState() => _CatalogSectionState();
}

class _CatalogSectionState extends State<CatalogSection> with SingleTickerProviderStateMixin {
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
    final subjects = data.catalogItems.where((i) => i.type == 'subject').toList();
    final workTypes = data.catalogItems.where((i) => i.type == 'work_type').toList();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Предметы (${subjects.length})'),
            Tab(text: 'Типы работ (${workTypes.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _CatalogList(items: subjects, type: 'subject'),
              _CatalogList(items: workTypes, type: 'work_type'),
            ],
          ),
        ),
      ],
    );
  }
}

class _CatalogList extends StatelessWidget {
  final List items;
  final String type;
  const _CatalogList({required this.items, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FilledButton.icon(
                onPressed: () => _showAddDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: Text(type == 'subject' ? 'Добавить предмет' : 'Добавить тип'),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item.isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                    child: Icon(
                      type == 'subject' ? Icons.book : Icons.description,
                      color: item.isActive ? AppColors.primary : Colors.grey,
                    ),
                  ),
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: item.isActive ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(item.isActive ? 'Активен' : 'Отключён', style: TextStyle(fontSize: 11, color: item.isActive ? const Color(0xFF4CAF50) : Colors.grey)),
                      ),
                      const SizedBox(width: 8),
                      IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => _showEditDialog(context, item)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(type == 'subject' ? 'Новый предмет' : 'Новый тип работы'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Название')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Добавлено: ${controller.text}')));
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, dynamic item) {
    final controller = TextEditingController(text: item.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Редактировать'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Название')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Обновлено: ${controller.text}')));
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
