import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/notifications_provider.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _icon(String type) {
    switch (type) {
      case 'order': return Icons.assignment;
      case 'chat': return Icons.chat;
      case 'payment': return Icons.payment;
      case 'bid': return Icons.gavel;
      case 'review': return Icons.star;
      case 'revision': return Icons.refresh;
      case 'ticket': return Icons.support_agent;
      case 'violation': return Icons.warning;
      case 'arbitration': return Icons.balance;
      case 'application': return Icons.description;
      case 'meeting': return Icons.event;
      case 'referral': return Icons.person_add;
      default: return Icons.notifications;
    }
  }

  Color _iconColor(String type) {
    switch (type) {
      case 'order': return AppColors.primary;
      case 'payment': return const Color(0xFF2E7D32);
      case 'bid': return const Color(0xFFFF9800);
      case 'review': return const Color(0xFFFFC107);
      case 'revision': return const Color(0xFFE53935);
      case 'violation': return const Color(0xFFE53935);
      case 'arbitration': return const Color(0xFF7B1FA2);
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final notifications = provider.notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        actions: [
          if (provider.unreadCount > 0)
            TextButton(
              onPressed: () => provider.markAllRead(),
              child: const Text('Прочитать все'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const EmptyState(icon: Icons.notifications_none, title: 'Нет уведомлений')
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return ListTile(
                  tileColor: n.isRead ? null : AppColors.primary.withValues(alpha: 0.03),
                  leading: CircleAvatar(
                    backgroundColor: (n.isRead ? AppColors.textSecondary : _iconColor(n.type)).withValues(alpha: 0.1),
                    child: Icon(_icon(n.type), color: n.isRead ? AppColors.textSecondary : _iconColor(n.type), size: 20),
                  ),
                  title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.w600, fontSize: 14)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.message, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(_formatTime(n.createdAt), style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    if (!n.isRead) provider.markRead(n.id);
                  },
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин. назад';
    if (diff.inHours < 24) return '${diff.inHours} ч. назад';
    return DateFormat('dd.MM.yyyy HH:mm').format(dt);
  }
}
