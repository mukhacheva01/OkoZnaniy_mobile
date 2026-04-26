import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class ExpertApplicationViewScreen extends StatefulWidget {
  const ExpertApplicationViewScreen({super.key});

  @override
  State<ExpertApplicationViewScreen> createState() => _ExpertApplicationViewScreenState();
}

class _ExpertApplicationViewScreenState extends State<ExpertApplicationViewScreen> {
  bool _isEditing = false;
  late TextEditingController _fullNameController;
  late TextEditingController _experienceController;
  late TextEditingController _universityController;
  late TextEditingController _yearsController;
  late TextEditingController _degreeController;
  List<String> _selectedSubjects = [];

  final List<String> _allSubjects = [
    'Экономика', 'Менеджмент', 'Бухгалтерский учёт', 'Статистика',
    'Финансовый менеджмент', 'Маркетинг', 'Математика', 'Физика',
    'Информатика', 'Философия', 'Психология', 'Социология',
    'Юриспруденция', 'Медицина', 'Биология', 'Химия',
  ];

  @override
  void initState() {
    super.initState();
    final app = context.read<TestDataProvider>().expertApplication;
    _fullNameController = TextEditingController(text: app?.fullName ?? '');
    _experienceController = TextEditingController(text: '${app?.experienceYears ?? 0}');
    _universityController = TextEditingController(text: app?.university ?? '');
    _yearsController = TextEditingController(text: app?.graduationYears ?? '');
    _degreeController = TextEditingController(text: app?.degree ?? '');
    _selectedSubjects = List.from(app?.subjects ?? []);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _experienceController.dispose();
    _universityController.dispose();
    _yearsController.dispose();
    _degreeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final authProvider = context.watch<AuthProvider>();
    final application = testData.expertApplication;

    if (application == null && !authProvider.isTestUser) {
      return Scaffold(
        appBar: AppBar(title: const Text('Анкета эксперта')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text('Анкета не подана'),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => setState(() => _isEditing = true), child: const Text('Подать анкету')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Анкета эксперта'),
        actions: [
          if (!_isEditing && application?.status != 'approved')
            IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => setState(() => _isEditing = true)),
        ],
      ),
      body: _isEditing ? _buildEditForm(context) : _buildViewMode(context, application!),
    );
  }

  Widget _buildViewMode(BuildContext context, ExpertApplication app) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _statusColor(app.status).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _statusColor(app.status).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(_statusIcon(app.status), color: _statusColor(app.status), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Статус анкеты', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text(app.statusLabel, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _statusColor(app.status))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (app.status == 'rejected' && app.rejectionReason != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.error.withValues(alpha: 0.2))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Причина отклонения', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
                  const SizedBox(height: 8),
                  Text(app.rejectionReason!, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          _buildField('ФИО', app.fullName),
          _buildField('Опыт работы', '${app.experienceYears} лет'),
          _buildField('ВУЗ', app.university),
          _buildField('Годы обучения', app.graduationYears),
          _buildField('Степень', app.degree),
          const SizedBox(height: 16),
          Text('Специализации', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: app.subjects.map((s) => Chip(label: Text(s, style: const TextStyle(fontSize: 12)), backgroundColor: AppColors.primary.withValues(alpha: 0.1), side: BorderSide.none, visualDensity: VisualDensity.compact)).toList(),
          ),
          const SizedBox(height: 12),
          Text('Дата подачи: ${_formatDate(app.createdAt)}', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'ФИО *', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _experienceController,
            decoration: const InputDecoration(labelText: 'Опыт работы (лет) *', prefixIcon: Icon(Icons.work_outline)),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Text('Специализации', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _allSubjects.map((subject) {
              final selected = _selectedSubjects.contains(subject);
              return FilterChip(
                label: Text(subject, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.textPrimary)),
                selected: selected,
                onSelected: (val) {
                  setState(() {
                    if (val) { _selectedSubjects.add(subject); } else { _selectedSubjects.remove(subject); }
                  });
                },
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Образование', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(controller: _universityController, decoration: const InputDecoration(labelText: 'ВУЗ *', prefixIcon: Icon(Icons.school_outlined))),
          const SizedBox(height: 12),
          TextFormField(controller: _yearsController, decoration: const InputDecoration(labelText: 'Годы обучения *', hintText: '2010-2014', prefixIcon: Icon(Icons.calendar_today_outlined))),
          const SizedBox(height: 12),
          TextFormField(controller: _degreeController, decoration: const InputDecoration(labelText: 'Степень *', prefixIcon: Icon(Icons.military_tech_outlined))),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () => setState(() => _isEditing = false), child: const Text('Отмена'))),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Анкета сохранена')));
                    setState(() => _isEditing = false);
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    const colors = {'pending': AppColors.orange, 'approved': AppColors.success, 'rejected': AppColors.error, 'revision': AppColors.primary, 'deactivated': AppColors.textSecondary};
    return colors[status] ?? AppColors.textSecondary;
  }

  IconData _statusIcon(String status) {
    const icons = {'pending': Icons.hourglass_empty, 'approved': Icons.check_circle, 'rejected': Icons.cancel, 'revision': Icons.edit_note, 'deactivated': Icons.block};
    return icons[status] ?? Icons.help_outline;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
