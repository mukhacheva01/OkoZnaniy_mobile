import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComplaintFormScreen extends StatefulWidget {
  final int orderId;

  const ComplaintFormScreen({super.key, required this.orderId});

  @override
  State<ComplaintFormScreen> createState() => _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _complaintType = 'quality';
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // TODO: submit complaint via API
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Жалоба отправлена')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка отправки')),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Подать жалобу')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Заказ #${widget.orderId}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _complaintType,
                decoration: const InputDecoration(labelText: 'Тип жалобы'),
                items: const [
                  DropdownMenuItem(
                      value: 'quality', child: Text('Качество работы')),
                  DropdownMenuItem(
                      value: 'deadline', child: Text('Нарушение сроков')),
                  DropdownMenuItem(
                      value: 'communication',
                      child: Text('Проблемы с коммуникацией')),
                  DropdownMenuItem(
                      value: 'other', child: Text('Другое')),
                ],
                onChanged: (v) =>
                    setState(() => _complaintType = v ?? _complaintType),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Причина *',
                  hintText: 'Кратко опишите причину жалобы',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Подробное описание *',
                  hintText: 'Опишите ситуацию подробно...',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: () {
                  // TODO: attach files
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Прикрепить доказательства'),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Отправить жалобу'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
