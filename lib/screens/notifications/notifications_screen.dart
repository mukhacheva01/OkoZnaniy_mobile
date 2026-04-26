import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _icon(String type) {
    switch (type) {
      case 'order': return Icons.assignment;
      case 'chat': return Icons.chat;
      case 'payment': return Icons.payment;
      default: return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTest = context.watch<AuthProvider>().isTestUser;
    final testData = context.watch<TestDataProvider>();
    final notifications = isTest ? testData.notifications : <dynamic>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Уведомления')),
      body: notifications.isEmpty
          ? const EmptyState(icon: Icons.notifications_none, title: 'Нет уведомлений')
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final n = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: n.isRead ? AppColors.surface : AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(_icon(n.type), color: n.isRead ? AppColors.textSecondary : AppColors.primary),
                  ),
                  title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600)),
                  subtitle: Text(n.message, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  trailing: Text(DateFormat('dd.MM').format(n.createdAt), style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  onTap: () {
                    if (!n.isRead) testData.markNotificationRead(n.id);
                  },
                );
              },
            ),
    );
  }
}
