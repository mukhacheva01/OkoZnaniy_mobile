import 'package:flutter/material.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/notification.dart';
import 'package:oko_znaniy_mobile/services/notification_service.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();
  List<AppNotification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      _notifications = await _service.getNotifications();
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  IconData _notificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.assignment;
      case 'chat':
        return Icons.chat;
      case 'payment':
        return Icons.payment;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Уведомления')),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        child: _isLoading
            ? const AppLoading()
            : _notifications.isEmpty
                ? const EmptyState(
                    icon: Icons.notifications_none,
                    title: 'Нет уведомлений',
                  )
                : ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: n.isRead
                              ? AppColors.surface
                              : AppColors.primary.withValues(alpha: 0.1),
                          child: Icon(
                            _notificationIcon(n.type),
                            color: n.isRead
                                ? AppColors.textSecondary
                                : AppColors.primary,
                          ),
                        ),
                        title: Text(
                          n.title,
                          style: TextStyle(
                            fontWeight:
                                n.isRead ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          n.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                        trailing: Text(
                          DateFormat('dd.MM').format(n.createdAt),
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                        onTap: () async {
                          if (!n.isRead) {
                            await _service.markAsRead(n.id);
                            _loadNotifications();
                          }
                        },
                      );
                    },
                  ),
      ),
    );
  }
}
