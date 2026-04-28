import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';
import 'package:intl/intl.dart';

class PartnerChatsSection extends StatelessWidget {
  const PartnerChatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PartnerTestDataProvider>();

    return ListView(
      padding: const EdgeInsets.all(8),
      children: data.chatRooms.map((room) => Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF2E7D32).withValues(alpha: 0.1),
            child: Icon(room.membersCount > 2 ? Icons.groups : Icons.person, color: const Color(0xFF2E7D32), size: 20),
          ),
          title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room.lastMessage, style: TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text('${room.membersCount} участников · ${DateFormat('dd.MM HH:mm').format(room.lastMessageAt)}',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.chat, size: 18, color: Color(0xFF2E7D32)),
            onPressed: () => _showChat(context, room.name),
          ),
        ),
      )).toList(),
    );
  }

  void _showChat(BuildContext context, String roomName) {
    final controller = TextEditingController();
    final messages = [
      _Msg('Менеджер', 'Добрый день! Как дела с привлечением?', '10:00', false),
      _Msg('Вы', 'Привет! Привлёк 3 новых реферала на этой неделе', '10:05', true),
      _Msg('Менеджер', 'Отлично! Новые промо-материалы уже доступны в разделе', '10:10', false),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scroll) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chat, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(roomName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scroll,
                  padding: const EdgeInsets.all(12),
                  children: messages.map((m) => Align(
                    alignment: m.isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: m.isMe ? const Color(0xFF2E7D32).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.sender, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: m.isMe ? const Color(0xFF2E7D32) : Colors.grey[700])),
                          Text(m.text, style: const TextStyle(fontSize: 13)),
                          Align(alignment: Alignment.bottomRight, child: Text(m.time, style: TextStyle(fontSize: 9, color: AppColors.textSecondary))),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file, size: 20),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Загрузка файла (тестовый режим)'))),
                    ),
                    Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Сообщение...', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF2E7D32)),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Отправлено: ${controller.text}')));
                          controller.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Msg {
  final String sender, text, time;
  final bool isMe;
  _Msg(this.sender, this.text, this.time, this.isMe);
}
