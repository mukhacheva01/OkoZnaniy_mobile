import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/director_models.dart';
import 'package:oko_znaniy_mobile/providers/director_test_data_provider.dart';
import 'package:intl/intl.dart';

class PersonnelSection extends StatefulWidget {
  const PersonnelSection({super.key});

  @override
  State<PersonnelSection> createState() => _PersonnelSectionState();
}

class _PersonnelSectionState extends State<PersonnelSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DirectorTestDataProvider>();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: 'Сотрудники (${data.staff.length})'),
            Tab(text: 'Заявки (${data.expertApplications.length})'),
            Tab(text: 'Архив (${data.archivedStaff.length})'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _StaffList(staff: data.staff, isArchive: false),
              _ApplicationsList(applications: data.expertApplications),
              _StaffList(staff: data.archivedStaff, isArchive: true),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _showRegisterDialog(context),
              icon: const Icon(Icons.person_add),
              label: const Text('Зарегистрировать сотрудника'),
            ),
          ),
        ),
      ],
    );
  }

  void _showRegisterDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'admin';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Новый сотрудник'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'ФИО')),
              const SizedBox(height: 8),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                decoration: const InputDecoration(labelText: 'Роль'),
                items: const [
                  DropdownMenuItem(value: 'admin', child: Text('Администратор')),
                  DropdownMenuItem(value: 'arbiter', child: Text('Арбитр')),
                  DropdownMenuItem(value: 'partner', child: Text('Партнёр')),
                ],
                onChanged: (v) => setDialogState(() => selectedRole = v ?? 'admin'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
            FilledButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
                  context.read<DirectorTestDataProvider>().addStaff(StaffMember(
                    id: DateTime.now().millisecondsSinceEpoch,
                    fullName: nameController.text,
                    email: emailController.text,
                    role: selectedRole,
                    isActive: true,
                    createdAt: DateTime.now(),
                  ));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Сотрудник ${nameController.text} зарегистрирован')));
                }
              },
              child: const Text('Зарегистрировать'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffList extends StatelessWidget {
  final List<StaffMember> staff;
  final bool isArchive;
  const _StaffList({required this.staff, required this.isArchive});

  String _roleLabel(String role) {
    const map = {'admin': 'Администратор', 'expert': 'Эксперт', 'arbiter': 'Арбитр', 'partner': 'Партнёр'};
    return map[role] ?? role;
  }

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) return const Center(child: Text('Нет сотрудников'));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: staff.length,
      itemBuilder: (context, index) {
        final s = staff[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: s.isActive ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
              child: Text(s.fullName[0], style: TextStyle(color: s.isActive ? const Color(0xFF4CAF50) : Colors.grey)),
            ),
            title: Text(s.fullName, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('${s.email} · ${_roleLabel(s.role)} · ${DateFormat('dd.MM.yyyy').format(s.createdAt)}', style: const TextStyle(fontSize: 11)),
            trailing: isArchive
                ? IconButton(
                    icon: const Icon(Icons.restore, color: Color(0xFF4CAF50)),
                    onPressed: () {
                      context.read<DirectorTestDataProvider>().restoreStaff(s.id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${s.fullName} восстановлен')));
                    },
                  )
                : PopupMenuButton<String>(
                    onSelected: (v) {
                      final provider = context.read<DirectorTestDataProvider>();
                      if (v == 'activate') { provider.activateStaff(s.id); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${s.fullName} активирован'))); }
                      if (v == 'deactivate') { provider.deactivateStaff(s.id); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${s.fullName} деактивирован'))); }
                      if (v == 'archive') { provider.archiveStaff(s.id); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${s.fullName} в архиве'))); }
                    },
                    itemBuilder: (c) => [
                      if (!s.isActive) const PopupMenuItem(value: 'activate', child: Text('Активировать')),
                      if (s.isActive) const PopupMenuItem(value: 'deactivate', child: Text('Деактивировать')),
                      const PopupMenuItem(value: 'archive', child: Text('В архив')),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _ApplicationsList extends StatelessWidget {
  final List<ExpertApplication> applications;
  const _ApplicationsList({required this.applications});

  Color _statusColor(String status) {
    switch (status) { case 'pending': return const Color(0xFFFF9800); case 'approved': return const Color(0xFF4CAF50); case 'rejected': return const Color(0xFFE53935); case 'rework': return AppColors.primary; default: return Colors.grey; }
  }

  String _statusLabel(String status) {
    const map = {'pending': 'На рассмотрении', 'approved': 'Одобрена', 'rejected': 'Отклонена', 'rework': 'На доработке'};
    return map[status] ?? status;
  }

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) return const Center(child: Text('Нет заявок'));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final a = applications[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(a.fullName, style: const TextStyle(fontWeight: FontWeight.bold))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _statusColor(a.status).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text(_statusLabel(a.status), style: TextStyle(fontSize: 11, color: _statusColor(a.status))),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${a.email} · ${a.university} · ${a.experienceYears} лет', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text('Предметы: ${a.subjects.join(', ')}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                if (a.status == 'pending' || a.status == 'rework') ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _ActionBtn('Одобрить', const Color(0xFF4CAF50), () {
                        context.read<DirectorTestDataProvider>().approveExpertApplication(a.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заявка ${a.fullName} одобрена')));
                      }),
                      const SizedBox(width: 8),
                      _ActionBtn('Отклонить', const Color(0xFFE53935), () {
                        context.read<DirectorTestDataProvider>().rejectExpertApplication(a.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заявка ${a.fullName} отклонена')));
                      }),
                      const SizedBox(width: 8),
                      _ActionBtn('Доработка', AppColors.primary, () {
                        context.read<DirectorTestDataProvider>().reworkExpertApplication(a.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Заявка ${a.fullName} на доработке')));
                      }),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn(this.label, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
        child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
