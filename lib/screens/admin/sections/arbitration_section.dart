import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/admin_models.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class ArbitrationSection extends StatelessWidget {
  const ArbitrationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    final cases = data.arbitrationCases;
    final stats = data.stats;

    return Column(
      children: [
        if (stats != null) Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MiniStat('Всего дел', '${cases.length}'),
              _MiniStat('Активных', '${cases.where((c) => c.status == 'in_progress' || c.status == 'new').length}'),
              _MiniStat('Решено', '${cases.where((c) => c.status == 'resolved').length}'),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: cases.length,
            itemBuilder: (context, index) {
              final c = cases[index];
              return Card(
                child: InkWell(
                  onTap: () => _openCase(context, c),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('#${c.id} ${c.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                            _CaseStatusBadge(c.status),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('${c.claimantName} → ${c.respondentName}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Row(
                          children: [
                            Text('Заказ #${c.orderId}', style: TextStyle(fontSize: 11, color: AppColors.textTertiary)),
                            const Spacer(),
                            if (c.assigneeName != null) Text(c.assigneeName!, style: TextStyle(fontSize: 11, color: AppColors.primary)),
                          ],
                        ),
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

  void _openCase(BuildContext context, ArbitrationCase arCase) {
    final messageController = TextEditingController();
    final decisionController = TextEditingController();
    final refundController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
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
                  Text('#${arCase.id} ${arCase.title}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [_CaseStatusBadge(arCase.status), const SizedBox(width: 8), Text('Заказ #${arCase.orderId}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))]),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: Color(0xFFE53935)),
                      const SizedBox(width: 4),
                      Text(arCase.claimantName, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(Icons.person, size: 14, color: Color(0xFF607D8B)),
                      const SizedBox(width: 4),
                      Text(arCase.respondentName, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  if (arCase.decision != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFF4CAF50).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Решение:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(arCase.decision!, style: const TextStyle(fontSize: 12)),
                          if (arCase.refundAmount != null) Text('Возврат: ${arCase.refundAmount!.toStringAsFixed(0)} ₽', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (arCase.status == 'new')
                        ActionChip(
                          avatar: const Icon(Icons.work, size: 16),
                          label: const Text('Взять в работу', style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            context.read<AdminTestDataProvider>().takeArbitrationCase(arCase.id, 'Арбитр Сергей');
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Дело взято в работу')));
                          },
                        ),
                      if (arCase.status == 'in_progress') ...[
                        ActionChip(
                          avatar: const Icon(Icons.gavel, size: 16),
                          label: const Text('Принять решение', style: TextStyle(fontSize: 11)),
                          onPressed: () => _showDecisionDialog(context, arCase, decisionController, refundController),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.close, size: 16),
                          label: const Text('Закрыть', style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            context.read<AdminTestDataProvider>().closeArbitrationCase(arCase.id);
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Дело закрыто')));
                          },
                        ),
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
                itemCount: arCase.messages.length,
                itemBuilder: (ctx, i) {
                  final m = arCase.messages[i];
                  return _ArbitrationMessage(message: m);
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

  void _showDecisionDialog(BuildContext context, ArbitrationCase arCase, TextEditingController decisionController, TextEditingController refundController) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Принять решение'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: decisionController, decoration: const InputDecoration(labelText: 'Решение'), maxLines: 3),
            const SizedBox(height: 12),
            TextField(controller: refundController, decoration: const InputDecoration(labelText: 'Сумма возврата (₽, необязательно)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              if (decisionController.text.isNotEmpty) {
                context.read<AdminTestDataProvider>().resolveArbitrationCase(
                  arCase.id,
                  decisionController.text,
                  refundAmount: double.tryParse(refundController.text),
                );
                Navigator.pop(ctx);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Решение принято')));
              }
            },
            child: const Text('Принять'),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }
}

class _CaseStatusBadge extends StatelessWidget {
  final String status;
  const _CaseStatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'new': color = AppColors.primary; label = 'Новое'; break;
      case 'in_progress': color = const Color(0xFFFF9800); label = 'В работе'; break;
      case 'resolved': color = const Color(0xFF4CAF50); label = 'Решено'; break;
      case 'closed': color = const Color(0xFF607D8B); label = 'Закрыто'; break;
      default: color = Colors.grey; label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    );
  }
}

class _ArbitrationMessage extends StatelessWidget {
  final TicketMessage message;
  const _ArbitrationMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final isAdmin = message.isAdmin;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isAdmin ? const Color(0xFF7B1FA2).withValues(alpha: 0.06) : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isAdmin ? const Color(0xFF7B1FA2).withValues(alpha: 0.2) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(message.senderName, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isAdmin ? const Color(0xFF7B1FA2) : AppColors.textPrimary)),
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
