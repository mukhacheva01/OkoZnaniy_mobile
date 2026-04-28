import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';
import 'package:intl/intl.dart';

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({super.key});

  String _roleLabel(String role) {
    const map = {'client': 'Клиент', 'expert': 'Эксперт', 'admin': 'Администратор'};
    return map[role] ?? role;
  }

  Color _roleColor(String role) {
    switch (role) { case 'client': return AppColors.primary; case 'expert': return AppColors.orange; case 'admin': return const Color(0xFFE53935); default: return Colors.grey; }
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DirectorTestDataProvider>();

    if (data.suggestions.isEmpty) {
      return const Center(child: Text('Нет рекомендаций'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: data.suggestions.length,
      itemBuilder: (context, index) {
        final s = data.suggestions[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: _roleColor(s.authorRole).withValues(alpha: 0.1),
                      radius: 16,
                      child: Text(s.authorName[0], style: TextStyle(fontSize: 12, color: _roleColor(s.authorRole))),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.authorName, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                          Text('${_roleLabel(s.authorRole)} · ${DateFormat('dd.MM.yyyy').format(s.createdAt)}',
                            style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(Icons.lightbulb_outline, color: const Color(0xFFFF9800).withValues(alpha: 0.5), size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(s.text, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }
}
