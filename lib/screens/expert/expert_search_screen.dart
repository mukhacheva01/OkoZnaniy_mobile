import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertSearchScreen extends StatefulWidget {
  const ExpertSearchScreen({super.key});

  @override
  State<ExpertSearchScreen> createState() => _ExpertSearchScreenState();
}

class _ExpertSearchScreenState extends State<ExpertSearchScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final experts = testData.experts.where((e) {
      if (_search.isEmpty) return true;
      final q = _search.toLowerCase();
      return e.name.toLowerCase().contains(q) || e.specializations.any((s) => s.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Поиск экспертов')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Поиск по имени или специализации...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: experts.length,
              itemBuilder: (context, index) {
                final expert = experts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.orange.withValues(alpha: 0.1),
                      child: Text(expert.name[0], style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(expert.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('★ ${expert.rating} · ${expert.completedOrders} заказов', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Wrap(
                          spacing: 4,
                          children: expert.specializations.take(3).map((s) => Chip(
                            label: Text(s, style: const TextStyle(fontSize: 10)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                          )).toList(),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/experts/${expert.id}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
