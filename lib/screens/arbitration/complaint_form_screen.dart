import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ComplaintFormScreen extends StatefulWidget {
  final int orderId;
  const ComplaintFormScreen({super.key, required this.orderId});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String _reason = 'Некачественная работа';

  final _reasons = ['Некачественная работа', 'Нарушение сроков', 'Несоответствие требованиям', 'Плагиат', 'Другое'];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testData = context.read<TestDataProvider>();
    final order = testData.getOrderById(widget.orderId);

    return Scaffold(
      appBar: AppBar(title: const Text('Подать жалобу')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (order != null) ...[
                Text('Заказ: ${order.title}', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
              ],
              DropdownButtonFormField<String>(
                value: _reason,
                decoration: const InputDecoration(labelText: 'Причина жалобы'),
                items: _reasons.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _reason = v ?? _reason),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Описание *', hintText: 'Подробно опишите проблему...', alignLabelWithHint: true),
                validator: (v) => v == null || v.isEmpty ? 'Опишите проблему' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  testData.addComplaint(Complaint(
                    id: DateTime.now().millisecondsSinceEpoch,
                    orderId: widget.orderId,
                    orderTitle: order?.title ?? 'Заказ #${widget.orderId}',
                    reason: _reason,
                    description: _descriptionController.text,
                    status: 'open',
                    createdAt: DateTime.now(),
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Жалоба отправлена')));
                  context.pop();
                },
                child: const Text('Отправить жалобу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
