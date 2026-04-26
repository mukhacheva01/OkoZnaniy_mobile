import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';

class BecomeExpertScreen extends StatelessWidget {
  const BecomeExpertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Стать экспертом')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'Присоединяйтесь к команде экспертов',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Зарабатывайте, помогая студентам с учебными работами',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 32),

            _buildBenefit(context, Icons.attach_money, 'Достойная оплата',
                'Устанавливайте свои цены за работу'),
            _buildBenefit(context, Icons.schedule, 'Гибкий график',
                'Работайте когда удобно, откуда удобно'),
            _buildBenefit(context, Icons.trending_up, 'Карьерный рост',
                'Развивайте навыки и повышайте рейтинг'),
            _buildBenefit(context, Icons.shield, 'Безопасные сделки',
                'Гарантия оплаты через платформу'),

            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.expertApplication),
              child: const Text('Подать заявку'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
