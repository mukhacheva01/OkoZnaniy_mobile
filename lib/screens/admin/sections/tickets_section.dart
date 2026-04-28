import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/admin_models.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class TicketsSection extends StatefulWidget {
  const TicketsSection({super.key});

  @override
  State<TicketsSection> createState() => _TicketsSectionState();
}

class _TicketsSectionState extends State<TicketsSection> {
  String _statusFilter = 'all';
  String _categoryFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    var tickets = List<SupportTicket>.from(data.tickets);

    if (_statusFilter != 'all') {
      tickets = tickets.where((t) => t.status == _statusFilter).toList();
    }
    if (_categoryFilter != 'all') {
      tickets = tickets.where((t) => t.category == _categoryFilter).toList();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _statusFilter,
                  decoration: const InputDecoration(labelText: 'Статус', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Все')),
                    DropdownMenuItem(value: 'new', child: Text('Новые')),
                    DropdownMenuItem(value: 'in_progress', child: Text('В работе')),
                    DropdownMenuItem(value: 'completed', child: Text('Завершённые')),
                  ],
                  onChanged: (v) => setState(() => _statusFilter = v ?? 'all'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _categoryFilter,
                  decoration: const InputDecoration(labelText: 'Категория', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Все')),
                    DropdownMenuItem(value: 'payment', child: Text('Оплата')),
                    DropdownMenuItem(value: 'expert_complaint', child: Text('Жалоба')),
                    DropdownMenuItem(value: 'contact_violation', child: Text('Контакты')),
                    DropdownMenuItem(value: 'refund', child: Text('Возврат')),
                    DropdownMenuItem(value: 'technical', child: Text('Тех.')),
                  ],
                  onChanged: (v) => setState(() => _categoryFilter = v ?? 'all'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: tickets.isEmpty
              ? const Center(child: Text('Нет обращений'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final t = tickets[index];
                    return Card(
                      child: InkWell(
                        onTap: () => _openTicket(context, t),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _PriorityDot(t.priority),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('#${t.id} ${t.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                                  _TicketStatusBadge(t.status),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(t.authorName, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                  const Spacer(),
                                  if (t.assigneeName != null) Text('→ ${t.assigneeName}', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                                ],
                              ),
                              if (t.tags.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 4,
                                  children: t.tags.map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(4)),
                                    child: Text(tag, style: TextStyle(fontSize: 10, color: AppColors.primary)),
                                  )).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _openTicket(BuildContext context, SupportTicket ticket) {
    final messageController = TextEditingController();
    final isContactViolation = ticket.category == 'contact_violation';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (ctx, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 12),
                  Text('#${ticket.id} ${ticket.title}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _TicketStatusBadge(ticket.status),
                      const SizedBox(width: 8),
                      Text('${_categoryLabel(ticket.category)} · ${_priorityLabel(ticket.priority)}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (ticket.status == 'new')
                        _ActionChip('Взять в работу', Icons.work, () {
                          context.read<AdminTestDataProvider>().takeTicket(ticket.id, 'Админ Сергей');
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Тикет взят в работу')));
                        }),
                      if (ticket.status != 'completed')
                        _ActionChip('Завершить', Icons.check_circle, () {
                          context.read<AdminTestDataProvider>().completeTicket(ticket.id);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Тикет завершён')));
                        }),
                      if (isContactViolation) ...[
                        _ActionChip('Разморозить чат', Icons.lock_open, () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Чат разморожен')));
                        }),
                        _ActionChip('Забанить постоянно', Icons.block, () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Пользователь забанен')));
                        }),
                        _ActionChip('Бан на период', Icons.timer, () {
                          _showBanPeriodPicker(context, ticket);
                          Navigator.pop(ctx);
                        }),
                      ],
                    ],
                  ),
                  const Divider(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: ticket.messages.length,
                itemBuilder: (ctx, i) {
                  final m = ticket.messages[i];
                  return _MessageBubble(message: m);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(ctx).viewInsets.bottom + 8),
              decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(hintText: 'Сообщение...', isDense: true, border: OutlineInputBorder()),
                    ),
                  ),
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

  void _showBanPeriodPicker(BuildContext context, SupportTicket ticket) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        final days = date.difference(DateTime.now()).inDays;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Бан на $days дней установлен')));
      }
    });
  }

  static String _categoryLabel(String c) {
    const map = {'payment': 'Оплата', 'expert_complaint': 'Жалоба на эксперта', 'contact_violation': 'Нарушение контактов', 'refund': 'Возврат', 'technical': 'Техническая'};
    return map[c] ?? c;
  }

  static String _priorityLabel(String p) {
    const map = {'high': 'Высокий', 'medium': 'Средний', 'low': 'Низкий'};
    return map[p] ?? p;
  }
}

class _PriorityDot extends StatelessWidget {
  final String priority;
  const _PriorityDot(this.priority);

  Color get _color {
    switch (priority) { case 'high': return const Color(0xFFE53935); case 'medium': return const Color(0xFFFF9800); default: return const Color(0xFF4CAF50); }
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: _color));
  }
}

class _TicketStatusBadge extends StatelessWidget {
  final String status;
  const _TicketStatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'new': color = AppColors.primary; label = 'Новый'; break;
      case 'in_progress': color = const Color(0xFFFF9800); label = 'В работе'; break;
      case 'completed': color = const Color(0xFF4CAF50); label = 'Завершён'; break;
      default: color = Colors.grey; label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionChip(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 11)),
      onPressed: onTap,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final TicketMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isAdmin = message.isAdmin;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isAdmin ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isAdmin ? AppColors.primary.withValues(alpha: 0.2) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(message.senderName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isAdmin ? AppColors.primary : AppColors.textPrimary)),
              const Spacer(),
              Text(DateFormat('dd.MM HH:mm').format(message.createdAt), style: TextStyle(fontSize: 10, color: AppColors.textTertiary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(message.text, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
