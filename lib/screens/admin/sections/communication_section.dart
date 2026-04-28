import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/admin_models.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class CommunicationSection extends StatelessWidget {
  const CommunicationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    final rooms = data.chatRooms;
    final publicRooms = rooms.where((r) => !r.isPrivate).toList();
    final privateRooms = rooms.where((r) => r.isPrivate).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Чат-комнаты', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              FilledButton.icon(
                onPressed: () => _showCreateRoomDialog(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Создать'),
                style: FilledButton.styleFrom(minimumSize: const Size(0, 36)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (publicRooms.isNotEmpty) ...[
            Text('Общие', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            ...publicRooms.map((r) => _ChatRoomCard(room: r)),
          ],
          if (privateRooms.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Личные', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            ...privateRooms.map((r) => _ChatRoomCard(room: r)),
          ],
        ],
      ),
    );
  }

  void _showCreateRoomDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Новая комната'),
        content: TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Название')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Комната "${nameController.text}" создана')));
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }
}

class _ChatRoomCard extends StatelessWidget {
  final AdminChatRoom room;
  const _ChatRoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _openChat(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: room.isPrivate ? const Color(0xFF7B1FA2).withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
                child: Icon(room.isPrivate ? Icons.person : Icons.group, color: room.isPrivate ? const Color(0xFF7B1FA2) : AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${room.membersCount} участников · ${room.messages.length} сообщений', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (room.messages.isNotEmpty)
                Text(DateFormat('HH:mm').format(room.messages.last.createdAt), style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
            ],
          ),
        ),
      ),
    );
  }

  void _openChat(BuildContext context) {
    final messageController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(room.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      PopupMenuButton<String>(
                        onSelected: (v) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(v == 'invite' ? 'Пользователь приглашён' : v == 'add_staff' ? 'Все сотрудники добавлены' : 'Вы покинули комнату')));
                        },
                        itemBuilder: (c) => [
                          const PopupMenuItem(value: 'invite', child: Text('Пригласить')),
                          if (!room.isPrivate) const PopupMenuItem(value: 'add_staff', child: Text('Добавить всех сотрудников')),
                          const PopupMenuItem(value: 'leave', child: Text('Выйти')),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            Expanded(
              child: room.messages.isEmpty
                  ? const Center(child: Text('Нет сообщений'))
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: room.messages.length,
                      itemBuilder: (ctx, i) {
                        final m = room.messages[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.04),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(m.senderName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  const Spacer(),
                                  Text(DateFormat('dd.MM HH:mm').format(m.createdAt), style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(m.text, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(ctx).viewInsets.bottom + 8),
              decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: messageController, decoration: const InputDecoration(hintText: 'Сообщение...', isDense: true, border: OutlineInputBorder()))),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppColors.primary),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Сообщение отправлено')));
                        messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
