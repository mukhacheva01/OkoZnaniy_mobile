import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';

class ProgramSection extends StatelessWidget {
  const ProgramSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PartnerTestDataProvider>();
    final stats = data.stats;
    if (stats == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF43A047)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.handshake, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              const Text('Партнёрская программа', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Ваша комиссия: ${stats.commissionRate.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ваша реферальная ссылка', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(stats.referralLink, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 18, color: Color(0xFF2E7D32)),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: stats.referralLink));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ссылка скопирована!')));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: stats.referralLink));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ссылка скопирована!')));
                        },
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('Поделиться', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF2E7D32)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<PartnerTestDataProvider>().regenerateReferralLink();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ссылка пересоздана!')));
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Пересоздать', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Условия участия', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _ConditionCard(Icons.people, 'Привлекайте рефералов', 'Делитесь ссылкой — каждый зарегистрировавшийся становится вашим рефералом'),
        _ConditionCard(Icons.monetization_on, 'Получайте комиссию', 'За каждый заказ реферала вы получаете ${stats.commissionRate.toStringAsFixed(0)}% комиссии'),
        const _ConditionCard(Icons.card_giftcard, 'Бонус за регистрацию', 'За каждого нового реферала — бонус 500₽'),
        const _ConditionCard(Icons.calendar_today, 'Выплаты', 'Раз в месяц, 25 числа. Минимум для вывода — 1000₽'),
        const _ConditionCard(Icons.trending_up, 'Рост комиссии', 'При 50+ рефералах — повышение ставки до 15%'),
      ],
    );
  }
}

class _ConditionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const _ConditionCard(this.icon, this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
          radius: 18,
          child: Icon(icon, color: const Color(0xFF2E7D32), size: 18),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        subtitle: Text(description, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ),
    );
  }
}
