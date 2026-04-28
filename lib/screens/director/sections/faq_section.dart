import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DirectorTestDataProvider>();

    if (data.faq.isEmpty) {
      return const Center(child: Text('Нет вопросов'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.faq.length,
      itemBuilder: (context, index) {
        final item = data.faq[index];
        return Card(
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              radius: 16,
              child: Text('${index + 1}', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            title: Text(item.question, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Text(item.answer, style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4)),
            ],
          ),
        );
      },
    );
  }
}
