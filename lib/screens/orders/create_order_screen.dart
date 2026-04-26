import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/providers/orders_provider.dart';
import 'package:intl/intl.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  String _workType = 'Курсовая работа';
  String _subject = '';
  String _priority = 'medium';
  DateTime? _deadline;

  final _workTypes = [
    'Курсовая работа',
    'Дипломная работа',
    'Реферат',
    'Контрольная работа',
    'Эссе',
    'Лабораторная работа',
    'Отчет по практике',
    'Диссертация',
    'Другое',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _deadline = date);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<OrdersProvider>();
    final success = await provider.createOrder({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'work_type': _workType,
      'subject': _subject,
      'priority': _priority,
      if (_budgetController.text.isNotEmpty)
        'budget': double.parse(_budgetController.text),
      if (_deadline != null) 'deadline': _deadline!.toIso8601String(),
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заказ успешно создан!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdersProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Новый заказ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название работы *',
                  hintText: 'Например: Курсовая по экономике',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _workType,
                decoration: const InputDecoration(labelText: 'Тип работы *'),
                items: _workTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _workType = v ?? _workType),
              ),
              const SizedBox(height: 16),

              TextFormField(
                onChanged: (v) => _subject = v,
                decoration: const InputDecoration(
                  labelText: 'Предмет',
                  hintText: 'Например: Экономика предприятия',
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Описание задания *',
                  hintText: 'Подробно опишите требования к работе...',
                  alignLabelWithHint: true,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Введите описание' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _priority,
                decoration: const InputDecoration(labelText: 'Приоритет'),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Низкий')),
                  DropdownMenuItem(value: 'medium', child: Text('Средний')),
                  DropdownMenuItem(value: 'high', child: Text('Высокий')),
                  DropdownMenuItem(value: 'urgent', child: Text('Срочный')),
                ],
                onChanged: (v) =>
                    setState(() => _priority = v ?? _priority),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Бюджет (руб.)',
                  prefixText: '\u20BD ',
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Дедлайн'),
                subtitle: Text(
                  _deadline != null
                      ? DateFormat('dd.MM.yyyy').format(_deadline!)
                      : 'Не указан',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDeadline,
              ),
              const SizedBox(height: 16),

              // TODO: File attachment
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: file picker
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Прикрепить файлы'),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: provider.isLoading ? null : _handleSubmit,
                child: provider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Разместить заказ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
