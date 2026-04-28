import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class ContactBansSection extends StatelessWidget {
  const ContactBansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    final banned = data.contactBannedUsers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Баны за контакты (${banned.length})', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        if (banned.isEmpty)
          const Expanded(child: Center(child: Text('Нет забаненных пользователей')))
        else
          Expanded(
            child: ListView.builder(
              itemCount: banned.length,
              itemBuilder: (context, index) {
                final u = banned[index];
                final isPermanent = u.contactBanUntil == null;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFFFF9800).withValues(alpha: 0.1),
                              child: const Icon(Icons.phone_disabled, color: Color(0xFFFF9800)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(u.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(u.email, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isPermanent ? const Color(0xFFE53935).withValues(alpha: 0.1) : const Color(0xFFFF9800).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isPermanent ? 'Постоянный' : 'До ${DateFormat('dd.MM.yyyy').format(u.contactBanUntil!)}',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: isPermanent ? const Color(0xFFE53935) : const Color(0xFFFF9800)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Причина: ${u.contactBanReason ?? 'Не указана'}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              context.read<AdminTestDataProvider>().unbanUserForContacts(u.id);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Бан снят с ${u.username}')));
                            },
                            icon: const Icon(Icons.lock_open, size: 18),
                            label: const Text('Снять бан'),
                            style: TextButton.styleFrom(foregroundColor: const Color(0xFF4CAF50)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
