import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpertApplicationScreen extends StatefulWidget {
  const ExpertApplicationScreen({super.key});

  @override
  State<ExpertApplicationScreen> createState() =>
      _ExpertApplicationScreenState();
}

class _ExpertApplicationScreenState extends State<ExpertApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _educationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _subjectsController = TextEditingController();
  final _aboutController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _educationController.dispose();
    _experienceController.dispose();
    _subjectsController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // TODO: submit expert application via API
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Заявка отправлена!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка отправки заявки')),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Заявка эксперта')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(
                  labelText: 'Образование *',
                  hintText: 'ВУЗ, специальность, год выпуска',
                ),
                maxLines: 2,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: 'Опыт работы *',
                  hintText: 'Опишите ваш опыт в написании работ',
                ),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _subjectsController,
                decoration: const InputDecoration(
                  labelText: 'Предметы *',
                  hintText: 'Перечислите предметы через запятую',
                ),
                maxLines: 2,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _aboutController,
                decoration: const InputDecoration(
                  labelText: 'О себе',
                  hintText: 'Дополнительная информация',
                ),
                maxLines: 3,
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
                    : const Text('Отправить заявку'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
