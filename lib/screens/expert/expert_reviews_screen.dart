import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertReviewsScreen extends StatefulWidget {
  const ExpertReviewsScreen({super.key});

  @override
  State<ExpertReviewsScreen> createState() => _ExpertReviewsScreenState();
}

class _ExpertReviewsScreenState extends State<ExpertReviewsScreen> {
  int? _filterRating;
  String _sortBy = 'date_desc';

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    var reviews = List<Review>.from(testData.expertReviews);

    if (_filterRating != null) {
      reviews = reviews.where((r) => r.rating == _filterRating).toList();
    }
    if (_sortBy == 'date_asc') {
      reviews.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else if (_sortBy == 'rating_desc') {
      reviews.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'rating_asc') {
      reviews.sort((a, b) => a.rating.compareTo(b.rating));
    } else {
      reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final avgRating = testData.expertReviews.isNotEmpty ? testData.expertReviews.map((r) => r.rating).reduce((a, b) => a + b) / testData.expertReviews.length : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Отзывы обо мне'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => _sortBy = v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'date_desc', child: Text('Новые сначала')),
              const PopupMenuItem(value: 'date_asc', child: Text('Старые сначала')),
              const PopupMenuItem(value: 'rating_desc', child: Text('Рейтинг ↓')),
              const PopupMenuItem(value: 'rating_asc', child: Text('Рейтинг ↑')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(avgRating.toStringAsFixed(1), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  Row(children: List.generate(5, (i) => Icon(i < avgRating.round() ? Icons.star : Icons.star_border, color: AppColors.orange, size: 16))),
                ]),
                Column(children: [
                  Text('${testData.expertReviews.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('отзывов', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                ]),
              ],
            ),
          ),

          // Rating filter
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildFilterChip('Все', _filterRating == null, () => setState(() => _filterRating = null)),
                ...List.generate(5, (i) => _buildFilterChip(
                  '⭐' * (5 - i),
                  _filterRating == 5 - i,
                  () => setState(() => _filterRating = 5 - i),
                )),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: reviews.isEmpty
                ? const Center(child: Text('Нет отзывов'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) => _buildReviewCard(context, reviews[index], testData),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.textPrimary)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review, TestDataProvider testData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 18, backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: Text((review.clientName ?? '?')[0], style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(review.clientName ?? 'Клиент', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text('Заказ #${review.orderId}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(children: List.generate(5, (i) => Icon(i < review.rating ? Icons.star : Icons.star_border, color: AppColors.orange, size: 16))),
                  Text(_formatDate(review.createdAt), style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                ]),
              ],
            ),
            const SizedBox(height: 12),
            Text(review.comment, style: const TextStyle(fontSize: 14)),

            // Expert reply
            if (review.expertReply != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ваш ответ:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Text(review.expertReply!, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],

            // Appeal status
            if (review.appealStatus != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (review.appealStatus == 'pending' ? AppColors.orange : review.appealStatus == 'approved' ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(64),
                ),
                child: Text(
                  review.appealStatus == 'pending' ? 'Обжалование на рассмотрении' : review.appealStatus == 'approved' ? 'Обжалование одобрено' : 'Обжалование отклонено',
                  style: TextStyle(fontSize: 12, color: review.appealStatus == 'pending' ? AppColors.orange : review.appealStatus == 'approved' ? AppColors.success : AppColors.error, fontWeight: FontWeight.w500),
                ),
              ),
            ],

            // Actions
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (review.expertReply == null)
                  TextButton.icon(
                    onPressed: () => _showReplyDialog(context, review, testData),
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text('Ответить', style: TextStyle(fontSize: 12)),
                  ),
                if (review.appealStatus == null)
                  TextButton.icon(
                    onPressed: () => _showAppealDialog(context, review, testData),
                    icon: Icon(Icons.flag_outlined, size: 16, color: AppColors.orange),
                    label: Text('Обжаловать', style: TextStyle(fontSize: 12, color: AppColors.orange)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showReplyDialog(BuildContext context, Review review, TestDataProvider testData) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ответить на отзыв'),
        content: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Ваш ответ...'), maxLines: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                testData.replyToReview(review.id, controller.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ответ добавлен')));
              }
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void _showAppealDialog(BuildContext context, Review review, TestDataProvider testData) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Обжаловать отзыв'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Укажите причину обжалования:', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 12),
            TextField(controller: controller, decoration: const InputDecoration(hintText: 'Причина...'), maxLines: 4),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                testData.appealReview(review.id, controller.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Обжалование отправлено')));
              }
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
