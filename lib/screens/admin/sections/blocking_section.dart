import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/admin_models.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class BlockingSection extends StatefulWidget {
  const BlockingSection({super.key});

  @override
  State<BlockingSection> createState() => _BlockingSectionState();
}

class _BlockingSectionState extends State<BlockingSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Все (${data.users.length})'),
            Tab(text: 'Заблокированные (${data.blockedUsers.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _UsersList(users: data.users),
              _UsersList(users: data.blockedUsers),
            ],
          ),
        ),
      ],
    );
  }
}

class _UsersList extends StatelessWidget {
  final List<AdminUser> users;
  const _UsersList({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final u = users[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: u.isBlocked ? const Color(0xFFE53935).withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
              child: Text(u.username[0], style: TextStyle(color: u.isBlocked ? const Color(0xFFE53935) : AppColors.primary)),
            ),
            title: Text(u.username, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${u.email} · ${u.role} · ${u.ordersCount} заказов', style: const TextStyle(fontSize: 11)),
                if (u.isBlocked) Text('Причина: ${u.blockReason}', style: const TextStyle(fontSize: 11, color: Color(0xFFE53935))),
              ],
            ),
            isThreeLine: u.isBlocked,
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleAction(context, u, value),
              itemBuilder: (context) => [
                if (!u.isBlocked) const PopupMenuItem(value: 'block', child: Text('Заблокировать')),
                if (u.isBlocked) const PopupMenuItem(value: 'unblock', child: Text('Разблокировать')),
                const PopupMenuItem(value: 'role', child: Text('Сменить роль')),
                const PopupMenuItem(value: 'history', child: Text('История')),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAction(BuildContext context, AdminUser user, String action) {
    final adminData = context.read<AdminTestDataProvider>();

    if (action == 'block') {
      final reasonController = TextEditingController();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Заблокировать ${user.username}?'),
          content: TextField(controller: reasonController, decoration: const InputDecoration(labelText: 'Причина блокировки')),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
            FilledButton(
              onPressed: () {
                adminData.blockUser(user.id, reasonController.text.isEmpty ? 'Нарушение правил' : reasonController.text);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.username} заблокирован')));
              },
              child: const Text('Заблокировать'),
            ),
          ],
        ),
      );
    } else if (action == 'unblock') {
      adminData.unblockUser(user.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.username} разблокирован')));
    } else if (action == 'role') {
      showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
          title: Text('Роль для ${user.username}'),
          children: ['client', 'expert', 'admin', 'director', 'partner'].map((role) {
            return SimpleDialogOption(
              onPressed: () {
                adminData.changeUserRole(user.id, role);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Роль изменена на $role')));
              },
              child: Text(role, style: TextStyle(fontWeight: role == user.role ? FontWeight.bold : FontWeight.normal)),
            );
          }).toList(),
        ),
      );
    } else if (action == 'history') {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('История: ${user.username}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListTile(leading: const Icon(Icons.assignment), title: const Text('Заказы'), trailing: Text('${user.ordersCount}')),
              ListTile(leading: const Icon(Icons.calendar_today), title: const Text('Дата регистрации'), trailing: Text(DateFormat('dd.MM.yyyy').format(user.createdAt))),
              ListTile(leading: Icon(Icons.block, color: user.isBlocked ? const Color(0xFFE53935) : Colors.grey), title: const Text('Статус'), trailing: Text(user.isBlocked ? 'Заблокирован' : 'Активен')),
              if (user.isContactBanned)
                ListTile(leading: const Icon(Icons.phone_disabled, color: Color(0xFFFF9800)), title: const Text('Бан контактов'), trailing: Text(user.contactBanUntil != null ? 'До ${DateFormat('dd.MM.yyyy').format(user.contactBanUntil!)}' : 'Постоянный')),
            ],
          ),
        ),
      );
    }
  }
}
