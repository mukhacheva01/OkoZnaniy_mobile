import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class DirectorContactBansSection extends StatelessWidget {
  const DirectorContactBansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    final banned = data.contactBannedUsers;

    if (banned.isEmpty) {
      return const Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 48, color: Color(0xFF4CAF50)),
          SizedBox(height: 8),
          Text('Нет забаненных пользователей', style: TextStyle(fontSize: 16)),
        ],
      ));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: banned.length,
      itemBuilder: (context, index) {
        final u = banned[index];
        final isPermanent = u.contactBanUntil == null;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE53935).withValues(alpha: 0.1),
                      radius: 18,
                      child: const Icon(Icons.block, color: Color(0xFFE53935), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.username, style: const TextStyle(fontWeight: FontWeight.w600)),
                          Text(u.email, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Icon(
                      isPermanent ? Icons.block : Icons.timer,
                      color: isPermanent ? const Color(0xFFE53935) : const Color(0xFFFF9800),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (u.contactBanReason != null)
                  Text('Причина: ${u.contactBanReason}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text(
                  isPermanent ? 'Постоянный бан' : 'До ${DateFormat('dd.MM.yyyy').format(u.contactBanUntil!)}',
                  style: TextStyle(fontSize: 12, color: isPermanent ? const Color(0xFFE53935) : const Color(0xFFFF9800), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AdminTestDataProvider>().unbanUserForContacts(u.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Бан снят с ${u.username}')));
                    },
                    icon: const Icon(Icons.lock_open, size: 16),
                    label: const Text('Снять бан'),
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF4CAF50)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
