import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';
import 'package:intl/intl.dart';

class DirectorCommunicationSection extends StatefulWidget {
  const DirectorCommunicationSection({super.key});

  @override
  State<DirectorCommunicationSection> createState() => _DirectorCommunicationSectionState();
}

class _DirectorCommunicationSectionState extends State<DirectorCommunicationSection> with SingleTickerProviderStateMixin {
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
    final data = context.watch<DirectorTestDataProvider>();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Чат-комнаты'),
            Tab(text: 'Встречи (${data.meetingRequests.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ChatRoomsList(),
              _MeetingRequestsList(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatRoomsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rooms = [
      _RoomData('Директор — Админы', Icons.admin_panel_settings, 4, '14:30'),
      _RoomData('Директор — Арбитры', Icons.gavel, 3, '11:20'),
      _RoomData('Общий штаб', Icons.groups, 8, '15:00'),
    ];

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: FilledButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Создание комнаты (тестовый режим)'))),
            icon: const Icon(Icons.add),
            label: const Text('Создать комнату'),
          ),
        ),
        ...rooms.map((r) => Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF7B1FA2).withValues(alpha: 0.1),
              child: Icon(r.icon, color: const Color(0xFF7B1FA2), size: 20),
            ),
            title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('${r.members} участников · Последнее сообщение ${r.lastTime}', style: const TextStyle(fontSize: 11)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.chat, size: 18, color: Color(0xFF7B1FA2)),
                  onPressed: () => _showChatDialog(context, r.name),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, size: 18),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Приглашение в "${r.name}"'))),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  void _showChatDialog(BuildContext context, String roomName) {
    final controller = TextEditingController();
    final messages = [
      _Msg('Директор', 'Всем привет, какие обновления?', '09:00', true),
      _Msg('Сергей', 'Новых тикетов 5, 2 срочных', '09:05', false),
      _Msg('Директор', 'Принял, обсудим на созвоне', '09:10', true),
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
                  color: const Color(0xFF7B1FA2).withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.chat, color: Color(0xFF7B1FA2)),
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
                        color: m.isMe ? const Color(0xFF7B1FA2).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.sender, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: m.isMe ? const Color(0xFF7B1FA2) : Colors.grey[700])),
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
                    Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: 'Сообщение...', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)))),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF7B1FA2)),
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

class _MeetingRequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = context.watch<DirectorTestDataProvider>();

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: FilledButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Запрос встречи создан (тестовый режим)'))),
            icon: const Icon(Icons.calendar_today),
            label: const Text('Запросить встречу'),
          ),
        ),
        ...data.meetingRequests.map((m) {
          final statusColor = m.status == 'approved' ? const Color(0xFF4CAF50) : m.status == 'rejected' ? const Color(0xFFE53935) : const Color(0xFFFF9800);
          final statusLabel = m.status == 'approved' ? 'Одобрена' : m.status == 'rejected' ? 'Отклонена' : 'Ожидает';

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(m.topic, style: const TextStyle(fontWeight: FontWeight.w600))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(statusLabel, style: TextStyle(fontSize: 11, color: statusColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('От: ${m.fromName}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text('Запрос: ${DateFormat('dd.MM.yyyy').format(m.requestedAt)}${m.meetingDate != null ? ' · Встреча: ${DateFormat('dd.MM HH:mm').format(m.meetingDate!)}' : ''}',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  if (m.status == 'pending') ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            context.read<DirectorTestDataProvider>().approveMeeting(m.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Встреча одобрена')));
                          },
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF4CAF50), visualDensity: VisualDensity.compact),
                          child: const Text('Одобрить', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            context.read<DirectorTestDataProvider>().rejectMeeting(m.id);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Встреча отклонена')));
                          },
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFE53935), visualDensity: VisualDensity.compact),
                          child: const Text('Отклонить', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _RoomData {
  final String name;
  final IconData icon;
  final int members;
  final String lastTime;
  _RoomData(this.name, this.icon, this.members, this.lastTime);
}

class _Msg {
  final String sender;
  final String text;
  final String time;
  final bool isMe;
  _Msg(this.sender, this.text, this.time, this.isMe);
}
