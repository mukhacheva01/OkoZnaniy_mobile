import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/admin_models.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';
import 'package:intl/intl.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<AdminTestDataProvider>();
    final partners = data.partners;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Партнёры (${partners.length})', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: partners.length,
            itemBuilder: (context, index) {
              final p = partners[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: p.isActive ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                    child: Icon(Icons.handshake, color: p.isActive ? const Color(0xFF4CAF50) : Colors.grey),
                  ),
                  title: Text(p.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${p.totalReferrals} рефералов · ${p.totalEarnings.toStringAsFixed(0)} ₽ · ${p.commissionRate}%'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: p.isActive ? const Color(0xFF4CAF50).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(p.isActive ? 'Активен' : 'Неактивен', style: TextStyle(fontSize: 11, color: p.isActive ? const Color(0xFF4CAF50) : Colors.grey)),
                  ),
                  onTap: () => _showPartnerModal(context, p),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showPartnerModal(BuildContext context, AdminPartner partner) {
    final commissionController = TextEditingController(text: partner.commissionRate.toStringAsFixed(0));
    bool isActive = partner.isActive;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              Text(partner.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(partner.email, style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _InfoChip('Рефералов', '${partner.totalReferrals}'),
                  const SizedBox(width: 8),
                  _InfoChip('Заработок', '${partner.totalEarnings.toStringAsFixed(0)} ₽'),
                  const SizedBox(width: 8),
                  _InfoChip('С', DateFormat('dd.MM.yyyy').format(partner.joinedAt)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              TextFormField(
                controller: commissionController,
                decoration: const InputDecoration(labelText: 'Комиссия (%)', prefixIcon: Icon(Icons.percent)),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Активен'),
                value: isActive,
                onChanged: (v) => setModalState(() => isActive = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    context.read<AdminTestDataProvider>().updatePartner(
                      partner.id,
                      commissionRate: double.tryParse(commissionController.text),
                      isActive: isActive,
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Партнёр обновлён')));
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
