import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/order.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
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
  final _noteController = TextEditingController();
  String _workType = 'Курсовая работа';
  String _subject = '';
  DateTime? _deadline;
  TimeOfDay? _deadlineTime;

  final _workTypes = [
    'Курсовая работа', 'Дипломная работа', 'Реферат', 'Контрольная работа',
    'Эссе', 'Лабораторная работа', 'Отчет по практике', 'Диссертация', 'Другое',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 23, minute: 59));
      setState(() {
        _deadline = date;
        _deadlineTime = time;
      });
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Укажите дату сдачи')));
      return;
    }

    final isTest = context.read<AuthProvider>().isTestUser;
    if (isTest) {
      final testData = context.read<TestDataProvider>();
      final deadlineWithTime = _deadlineTime != null
          ? DateTime(_deadline!.year, _deadline!.month, _deadline!.day, _deadlineTime!.hour, _deadlineTime!.minute)
          : _deadline!;
      final order = Order(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text,
        description: _descriptionController.text,
        workType: _workType,
        subject: _subject,
        status: 'new',
        budget: _budgetController.text.isNotEmpty ? double.tryParse(_budgetController.text) : null,
        deadline: deadlineWithTime,
        createdAt: DateTime.now(),
        clientId: 0,
        clientName: 'Иван Иванов',
      );
      testData.addOrder(order);
    }

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заказ успешно создан!')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(labelText: 'Название работы *', hintText: 'Например: Курсовая по экономике'),
                validator: (v) => v == null || v.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _workType,
                decoration: const InputDecoration(labelText: 'Тип работы *'),
                items: _workTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _workType = v ?? _workType),
              ),
              const SizedBox(height: 16),
              TextFormField(
                onChanged: (v) => _subject = v,
                decoration: const InputDecoration(labelText: 'Предмет', hintText: 'Например: Экономика предприятия'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Описание задания *', hintText: 'Подробно опишите требования...', alignLabelWithHint: true),
                validator: (v) => v == null || v.isEmpty ? 'Введите описание' : null,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDeadline,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Дата и время сдачи *', prefixIcon: Icon(Icons.calendar_today)),
                  child: Text(
                    _deadline != null
                        ? '${DateFormat('dd.MM.yyyy').format(_deadline!)}${_deadlineTime != null ? ' ${_deadlineTime!.format(context)}' : ''}'
                        : 'Выберите дату',
                    style: TextStyle(color: _deadline != null ? AppColors.textPrimary : AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetController,
                decoration: const InputDecoration(labelText: 'Стоимость (₽)', hintText: 'Необязательно', prefixIcon: Icon(Icons.attach_money)),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final n = double.tryParse(v);
                    if (n == null || n <= 0 || n > 99999999.99) return 'Введите корректную сумму';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Прикрепление файлов (демо)')));
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Прикрепить файлы'),
              ),
              const SizedBox(height: 4),
              Text('До 50 МБ: doc, pdf, jpg, png, zip и др.', style: TextStyle(fontSize: 12, color: AppColors.textTertiary)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Приватная заметка', hintText: 'Видна только вам', alignLabelWithHint: true, prefixIcon: Icon(Icons.note_outlined)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _handleSubmit, child: const Text('Создать заказ')),
            ],
          ),
        ),
      ),
    );
  }
}
