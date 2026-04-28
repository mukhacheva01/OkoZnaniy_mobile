import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/partner_test_data_provider.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  String _cityFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final data = context.watch<PartnerTestDataProvider>();
    final entries = _cityFilter == 'all'
        ? data.mapEntries
        : data.mapEntries.where((e) => e.city == _cityFilter).toList();
    final cities = data.mapEntries.map((e) => e.city).toSet().toList()..sort();

    return Column(
      children: [
        Container(
          height: 200,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map, size: 48, color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
                    const SizedBox(height: 4),
                    Text('Карта партнёров', style: TextStyle(color: const Color(0xFF2E7D32).withValues(alpha: 0.5), fontSize: 12)),
                    Text('${entries.length} партнёров на карте', style: TextStyle(color: const Color(0xFF2E7D32).withValues(alpha: 0.5), fontSize: 11)),
                  ],
                ),
              ),
              ...entries.asMap().entries.map((e) {
                final idx = e.key;
                final p = e.value;
                final x = 30.0 + (idx * 40.0) % 280;
                final y = 30.0 + (idx * 25.0) % 130;
                return Positioned(
                  left: x, top: y,
                  child: Tooltip(
                    message: '${p.name} (${p.city})',
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: p.isActive ? const Color(0xFF2E7D32) : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4)],
                      ),
                      child: Center(child: Text('${p.referrals}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonFormField<String>(
            initialValue: _cityFilter,
            decoration: const InputDecoration(labelText: 'Город', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            items: [
              const DropdownMenuItem(value: 'all', child: Text('Все города')),
              ...cities.map((c) => DropdownMenuItem(value: c, child: Text(c))),
            ],
            onChanged: (v) => setState(() => _cityFilter = v ?? 'all'),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final p = entries[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: p.isActive ? const Color(0xFF2E7D32).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                    radius: 18,
                    child: Icon(Icons.location_on, color: p.isActive ? const Color(0xFF2E7D32) : Colors.grey, size: 18),
                  ),
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                  subtitle: Text('${p.city} · ${p.referrals} рефералов', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: p.isActive ? const Color(0xFF2E7D32).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(p.isActive ? 'Активен' : 'Неактивен', style: TextStyle(fontSize: 10, color: p.isActive ? const Color(0xFF2E7D32) : Colors.grey)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
