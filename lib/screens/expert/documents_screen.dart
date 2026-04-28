import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final docs = testData.documents;

    return Scaffold(
      appBar: AppBar(title: const Text('Документы')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUploadDialog(context, testData),
        child: const Icon(Icons.upload_file),
      ),
      body: docs.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.description_outlined, size: 64, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              const Text('Нет документов'),
              const SizedBox(height: 16),
              FilledButton.icon(onPressed: () => _showUploadDialog(context, testData), icon: const Icon(Icons.upload_file), label: const Text('Загрузить документ')),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _typeColor(doc.type).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(_typeIcon(doc.type), color: _typeColor(doc.type)),
                    ),
                    title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${doc.typeLabel} • ${doc.sizeLabel}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        _buildStatusChip(doc.verificationStatus, doc.statusLabel),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) {
                        if (action == 'delete') {
                          testData.deleteDocument(doc.id);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Документ удалён')));
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text('Удалить')])),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusChip(String status, String label) {
    final colors = {'pending': AppColors.orange, 'verified': AppColors.success, 'rejected': AppColors.error};
    final color = colors[status] ?? AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
    );
  }

  Color _typeColor(String type) {
    const colors = {'diploma': AppColors.primary, 'certificate': AppColors.success, 'award': AppColors.orange, 'other': AppColors.textSecondary};
    return colors[type] ?? AppColors.textSecondary;
  }

  IconData _typeIcon(String type) {
    const icons = {'diploma': Icons.school, 'certificate': Icons.verified, 'award': Icons.emoji_events, 'other': Icons.description};
    return icons[type] ?? Icons.description;
  }

  void _showUploadDialog(BuildContext context, TestDataProvider testData) {
    final nameCtrl = TextEditingController();
    String selectedType = 'diploma';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Загрузить документ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Название документа *')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: const InputDecoration(labelText: 'Тип документа'),
                items: const [
                  DropdownMenuItem(value: 'diploma', child: Text('Диплом')),
                  DropdownMenuItem(value: 'certificate', child: Text('Сертификат')),
                  DropdownMenuItem(value: 'award', child: Text('Награда')),
                  DropdownMenuItem(value: 'other', child: Text('Другое')),
                ],
                onChanged: (v) => setDialogState(() => selectedType = v!),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Выбор файла (демо)')));
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Выбрать файл'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.isEmpty) return;
                testData.addDocument(ExpertDocument(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: nameCtrl.text,
                  type: selectedType,
                  fileName: '${nameCtrl.text.replaceAll(' ', '_')}.pdf',
                  fileSize: 1024000,
                  uploadedAt: DateTime.now(),
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Документ загружен')));
              },
              child: const Text('Загрузить'),
            ),
          ],
        ),
      ),
    );
  }
}
