import 'package:flutter/material.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _controller = TextEditingController();

  final _messages = [
    _SupportMessage(isUser: false, text: 'Здравствуйте! Чем могу помочь?', time: '10:00'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_SupportMessage(isUser: true, text: _controller.text.trim(), time: TimeOfDay.now().format(context)));
      _controller.clear();
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _messages.add(_SupportMessage(isUser: false, text: 'Спасибо за обращение! Мы рассмотрим ваш вопрос в ближайшее время.', time: TimeOfDay.now().format(context)));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поддержка')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.confirmation_number_outlined), label: const Text('Создать тикет'), onPressed: () => _showTicketDialog(context))),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.lightbulb_outline), label: const Text('Предложение'), onPressed: () => _showSuggestionDialog(context))),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: msg.isUser ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(msg.text, style: TextStyle(color: msg.isUser ? Colors.white : AppColors.textPrimary)),
                        Text(msg.time, style: TextStyle(fontSize: 10, color: msg.isUser ? Colors.white70 : AppColors.textTertiary)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.background, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, -2))]),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Сообщение...', filled: true, fillColor: AppColors.surface, border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(backgroundColor: AppColors.primary, child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 20), onPressed: _send)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTicketDialog(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Создать тикет'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: 'Тема')),
            const SizedBox(height: 8),
            TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Описание')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Тикет создан')));
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showSuggestionDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Предложение по улучшению'),
        content: TextField(controller: ctrl, maxLines: 4, decoration: const InputDecoration(hintText: 'Опишите вашу идею...')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Спасибо за предложение!')));
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }
}

class _SupportMessage {
  final bool isUser;
  final String text;
  final String time;
  _SupportMessage({required this.isUser, required this.text, required this.time});
}
