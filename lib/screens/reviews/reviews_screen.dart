import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final reviews = testData.reviews;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои отзывы')),
      body: reviews.isEmpty
          ? const EmptyState(icon: Icons.star_outline, title: 'Нет отзывов', subtitle: 'Отзывы появятся после завершения заказов')
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.orange.withValues(alpha: 0.1),
                              child: const Icon(Icons.person, color: AppColors.orange),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(review.expertName, style: const TextStyle(fontWeight: FontWeight.w600)),
                                  Text('Заказ #${review.orderId}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text(DateFormat('dd.MM.yy').format(review.createdAt), style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(5, (i) => Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            color: AppColors.orange, size: 20,
                          )),
                        ),
                        const SizedBox(height: 8),
                        Text(review.comment, style: TextStyle(color: AppColors.textSecondary, height: 1.4)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Изменить'),
                              onPressed: () => _showEditDialog(context, testData, review),
                            ),
                            TextButton.icon(
                              icon: Icon(Icons.delete, size: 16, color: AppColors.error),
                              label: Text('Удалить', style: TextStyle(color: AppColors.error)),
                              onPressed: () {
                                testData.deleteReview(review.id);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Отзыв удалён')));
                              },
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

  void _showEditDialog(BuildContext context, TestDataProvider testData, Review review) {
    final controller = TextEditingController(text: review.comment);
    int rating = review.rating;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Редактировать отзыв'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => IconButton(
                  icon: Icon(i < rating ? Icons.star : Icons.star_border, color: AppColors.orange),
                  onPressed: () => setState(() => rating = i + 1),
                )),
              ),
              TextField(controller: controller, maxLines: 3, decoration: const InputDecoration(labelText: 'Комментарий')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                testData.updateReview(review.id, rating, controller.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Отзыв обновлён')));
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
