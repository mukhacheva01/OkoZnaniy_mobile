import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class SpecializationsScreen extends StatelessWidget {
  const SpecializationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final specs = testData.specializations;

    return Scaffold(
      appBar: AppBar(title: const Text('Специализации')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(context, testData, null),
        child: const Icon(Icons.add),
      ),
      body: specs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  const Text('Нет специализаций'),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: () => _showAddEditDialog(context, testData, null), child: const Text('Добавить специализацию')),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: specs.length,
              itemBuilder: (context, index) {
                final spec = specs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(spec.name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
                            _buildStatusChip(spec.verificationStatus, spec.statusLabel),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildRow(Icons.book_outlined, spec.subject),
                        _buildRow(Icons.work_outline, '${spec.experienceYears} лет опыта'),
                        _buildRow(Icons.attach_money, '${spec.hourlyRate.toStringAsFixed(0)} ₽/час'),
                        const SizedBox(height: 8),
                        Text(spec.description, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6, runSpacing: 6,
                          children: spec.skills.map((s) => Chip(
                            label: Text(s, style: const TextStyle(fontSize: 11)),
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            side: BorderSide.none, padding: EdgeInsets.zero, visualDensity: VisualDensity.compact,
                          )).toList(),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showAddEditDialog(context, testData, spec),
                              icon: const Icon(Icons.edit_outlined, size: 18),
                              label: const Text('Изменить'),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                testData.deleteSpecialization(spec.id);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Специализация удалена')));
                              },
                              icon: Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                              label: Text('Удалить', style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ]),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    final colors = {'pending': AppColors.orange, 'verified': AppColors.success, 'rejected': AppColors.error};
    final color = colors[status] ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  void _showAddEditDialog(BuildContext context, TestDataProvider testData, Specialization? spec) {
    final nameCtrl = TextEditingController(text: spec?.name ?? '');
    final subjectCtrl = TextEditingController(text: spec?.subject ?? '');
    final expCtrl = TextEditingController(text: spec != null ? '${spec.experienceYears}' : '');
    final rateCtrl = TextEditingController(text: spec != null ? spec.hourlyRate.toStringAsFixed(0) : '');
    final descCtrl = TextEditingController(text: spec?.description ?? '');
    final skillsCtrl = TextEditingController(text: spec?.skills.join(', ') ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(spec == null ? 'Добавить специализацию' : 'Редактировать'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Название *')),
              const SizedBox(height: 8),
              TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: 'Предмет *')),
              const SizedBox(height: 8),
              TextField(controller: expCtrl, decoration: const InputDecoration(labelText: 'Опыт (лет)'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: rateCtrl, decoration: const InputDecoration(labelText: 'Ставка (₽/час)'), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Описание'), maxLines: 3),
              const SizedBox(height: 8),
              TextField(controller: skillsCtrl, decoration: const InputDecoration(labelText: 'Навыки (через запятую)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          FilledButton(
            onPressed: () {
              final skills = skillsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
              final newSpec = Specialization(
                id: spec?.id ?? DateTime.now().millisecondsSinceEpoch,
                name: nameCtrl.text,
                subject: subjectCtrl.text,
                experienceYears: int.tryParse(expCtrl.text) ?? 0,
                hourlyRate: double.tryParse(rateCtrl.text) ?? 0,
                description: descCtrl.text,
                skills: skills,
                verificationStatus: spec?.verificationStatus ?? 'pending',
              );
              if (spec == null) {
                testData.addSpecialization(newSpec);
              } else {
                testData.updateSpecialization(spec.id, newSpec);
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(spec == null ? 'Специализация добавлена' : 'Специализация обновлена')));
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
