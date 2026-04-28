import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';

class EditExpertProfileScreen extends StatefulWidget {
  const EditExpertProfileScreen({super.key});

  @override
  State<EditExpertProfileScreen> createState() => _EditExpertProfileScreenState();
}

class _EditExpertProfileScreenState extends State<EditExpertProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _educationController;
  late TextEditingController _experienceController;
  late TextEditingController _hourlyRateController;
  late TextEditingController _skillsController;
  late TextEditingController _portfolioController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _educationController = TextEditingController(text: user?.education ?? '');
    _experienceController = TextEditingController(text: '${user?.experienceYears ?? 0}');
    _hourlyRateController = TextEditingController(text: user?.hourlyRate.toStringAsFixed(0) ?? '0');
    _skillsController = TextEditingController(text: user?.skills.join(', ') ?? '');
    _portfolioController = TextEditingController(text: user?.portfolioUrl ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _educationController.dispose();
    _experienceController.dispose();
    _hourlyRateController.dispose();
    _skillsController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    await authProvider.updateProfile({
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'bio': _bioController.text,
      'education': _educationController.text,
      'experience_years': int.tryParse(_experienceController.text) ?? 0,
      'hourly_rate': double.tryParse(_hourlyRateController.text) ?? 0,
      'skills': _skillsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
      'portfolio_url': _portfolioController.text,
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Профиль обновлён')));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        actions: [
          TextButton(onPressed: authProvider.isLoading ? null : _save, child: const Text('Сохранить')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person, size: 48, color: AppColors.primary),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primary,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Загрузка аватара (демо)')));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Основная информация', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Имя', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => v == null || v.isEmpty ? 'Введите имя' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Фамилия', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Введите корректный email',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Телефон', prefixIcon: Icon(Icons.phone_outlined)),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),
              Text('Профессиональная информация', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'О себе', prefixIcon: Icon(Icons.info_outline), alignLabelWithHint: true),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _educationController,
                decoration: const InputDecoration(labelText: 'Образование', prefixIcon: Icon(Icons.school_outlined)),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: 'Опыт работы (лет)', prefixIcon: Icon(Icons.work_outline)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _hourlyRateController,
                decoration: const InputDecoration(labelText: 'Почасовая ставка (₽)', prefixIcon: Icon(Icons.attach_money)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(labelText: 'Навыки (через запятую)', prefixIcon: Icon(Icons.psychology_outlined), alignLabelWithHint: true),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _portfolioController,
                decoration: const InputDecoration(labelText: 'Ссылка на портфолио', prefixIcon: Icon(Icons.link)),
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: authProvider.isLoading ? null : _save,
                child: authProvider.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Сохранить изменения'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
