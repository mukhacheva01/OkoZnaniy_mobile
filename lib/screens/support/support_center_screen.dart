import 'package:flutter/material.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Центр поддержки')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Support chat button
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chat, color: AppColors.primary),
                ),
                title: const Text('Написать в поддержку'),
                subtitle: const Text('Мы ответим в течение нескольких минут'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: open support chat
                },
              ),
            ),
            const SizedBox(height: 24),

            Text('Частые вопросы',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _buildFaqItem(context, 'Как создать заказ?',
                'Нажмите кнопку "Создать заказ" на главной странице, заполните форму с описанием работы, укажите дедлайн и бюджет.'),
            _buildFaqItem(context, 'Как оплатить работу?',
                'Оплата происходит после подтверждения заказа. Деньги замораживаются на платформе до завершения работы.'),
            _buildFaqItem(context, 'Что делать если работа не устраивает?',
                'Вы можете отправить работу на доработку или подать жалобу в арбитраж.'),
            _buildFaqItem(context, 'Как стать экспертом?',
                'Заполните заявку в разделе "Стать экспертом". После проверки квалификации вы получите статус эксперта.'),
            _buildFaqItem(context, 'Как работает реферальная программа?',
                'Поделитесь своей реферальной ссылкой. За каждого нового пользователя вы получите бонус.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(question,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
