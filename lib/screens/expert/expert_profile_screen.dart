import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:intl/intl.dart';

class ExpertProfileScreen extends StatelessWidget {
  final int expertId;
  const ExpertProfileScreen({super.key, required this.expertId});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final expert = testData.experts.where((e) => e.id == expertId).firstOrNull;

    if (expert == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Эксперт')),
        body: const Center(child: Text('Эксперт не найден')),
      );
    }

    final isFriend = testData.friends.any((f) => f.id == expertId);

    return Scaffold(
      appBar: AppBar(title: Text(expert.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.orange.withValues(alpha: 0.1),
                child: Text(expert.name[0], style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.orange)),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: Text(expert.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: AppColors.orange, size: 20),
                  Text(' ${expert.rating}', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(' · ${expert.completedOrders} заказов', style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: expert.specializations.map((s) => Chip(
                label: Text(s),
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                labelStyle: TextStyle(color: AppColors.primary, fontSize: 13),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Text(expert.description, style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 8),
            Text('На платформе с ${DateFormat('MMMM yyyy', 'ru').format(expert.joinedAt)}', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (!isFriend) {
                        testData.addFriend(Friend(id: expert.id, name: expert.name, role: 'expert'));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${expert.name} добавлен в друзья')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Уже в друзьях')));
                      }
                    },
                    icon: Icon(isFriend ? Icons.check : Icons.person_add),
                    label: Text(isFriend ? 'В друзьях' : 'Добавить в друзья'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
