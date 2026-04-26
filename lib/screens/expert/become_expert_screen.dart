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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Column(
                children: [
                  const Icon(Icons.school, size: 64, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    'Присоединяйтесь к команде экспертов',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Зарабатывайте, помогая студентам с учебными работами',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildBenefit(context, Icons.attach_money,
                      'Достойная оплата', 'Устанавливайте свои цены за работу',
                      AppColors.orange),
                  _buildBenefit(context, Icons.schedule, 'Гибкий график',
                      'Работайте когда удобно, откуда удобно',
                      AppColors.primary),
                  _buildBenefit(context, Icons.trending_up, 'Карьерный рост',
                      'Развивайте навыки и повышайте рейтинг',
                      AppColors.purple),
                  _buildBenefit(context, Icons.shield, 'Безопасные сделки',
                      'Гарантия оплаты через платформу', AppColors.success),

                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => context.push(AppRoutes.expertApplication),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: AppColors.grey700,
                    ),
                    child: const Text('Подать заявку'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefit(BuildContext context, IconData icon, String title,
      String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
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
