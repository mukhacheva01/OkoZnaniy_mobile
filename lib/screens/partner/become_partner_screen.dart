import 'package:flutter/material.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';

class BecomePartnerScreen extends StatelessWidget {
  const BecomePartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Стать партнером')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.handshake, size: 80, color: AppColors.primary),
            const SizedBox(height: 24),
            Text(
              'Партнерская программа',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Приглашайте друзей и зарабатывайте вместе с нами',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 32),
            _buildStep(context, '1', 'Зарегистрируйтесь как партнер'),
            _buildStep(context, '2', 'Получите уникальную реферальную ссылку'),
            _buildStep(context, '3', 'Делитесь ссылкой с друзьями'),
            _buildStep(context, '4', 'Получайте % от каждого заказа рефералов'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: apply to become partner
              },
              child: const Text('Подать заявку'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Text(number,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
