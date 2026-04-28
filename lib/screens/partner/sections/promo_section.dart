import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  IconData _typeIcon(String type) {
    switch (type) { case 'banner': return Icons.image; case 'social_post': return Icons.chat_bubble; case 'email': return Icons.email; case 'asset': return Icons.download; default: return Icons.description; }
  }

  Color _typeColor(String type) {
    switch (type) { case 'banner': return const Color(0xFF1E88E5); case 'social_post': return const Color(0xFF7B1FA2); case 'email': return const Color(0xFFFF9800); case 'asset': return const Color(0xFF2E7D32); default: return Colors.grey; }
  }

  String _typeLabel(String type) {
    const map = {'banner': 'Баннер', 'social_post': 'Соцсети', 'email': 'Email', 'asset': 'Ассет'};
    return map[type] ?? type;
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PartnerTestDataProvider>();
    final stats = data.stats;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (stats != null) Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.link, color: Color(0xFF2E7D32)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ваша ссылка для промо', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                      Text(stats.referralLink, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: stats.referralLink));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ссылка скопирована!')));
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...data.promos.map((p) => Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _typeColor(p.type).withValues(alpha: 0.1),
              radius: 20,
              child: Icon(_typeIcon(p.type), color: _typeColor(p.type), size: 20),
            ),
            title: Text(p.title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.description, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: _typeColor(p.type).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(_typeLabel(p.type), style: TextStyle(fontSize: 10, color: _typeColor(p.type))),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.download, size: 20),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Скачивание: ${p.title}'))),
            ),
          ),
        )),
      ],
    );
  }
}
