import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/program_section.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/map_section.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/promo_section.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/partner_chats_section.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/partner_statistics_section.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/referrals_section.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/partner_earnings_section.dart';
import 'package:oko_znaniy_mobile/screens/partner/sections/partner_faq_section.dart';

class PartnerDashboardScreen extends StatefulWidget {
  const PartnerDashboardScreen({super.key});

  @override
  State<PartnerDashboardScreen> createState() => _PartnerDashboardScreenState();
}

class _PartnerDashboardScreenState extends State<PartnerDashboardScreen> {
  String _selectedMenu = 'program';

  static const _menuItems = [
    {'key': 'program', 'label': 'Программа', 'icon': Icons.handshake},
    {'key': 'map', 'label': 'Карта партнёров', 'icon': Icons.map},
    {'key': 'promo', 'label': 'Промо-материалы', 'icon': Icons.campaign},
    {'key': 'chats', 'label': 'Коммуникация', 'icon': Icons.chat},
    {'key': 'statistics', 'label': 'Статистика', 'icon': Icons.bar_chart},
    {'key': 'referrals', 'label': 'Мои рефералы', 'icon': Icons.people},
    {'key': 'earnings', 'label': 'Начисления', 'icon': Icons.monetization_on},
    {'key': 'faq', 'label': 'FAQ', 'icon': Icons.help_outline},
  ];

  Widget _buildSection() {
    switch (_selectedMenu) {
      case 'program': return const ProgramSection();
      case 'map': return const MapSection();
      case 'promo': return const PromoSection();
      case 'chats': return const PartnerChatsSection();
      case 'statistics': return const PartnerStatisticsSection();
      case 'referrals': return const ReferralsSection();
      case 'earnings': return const PartnerEarningsSection();
      case 'faq': return const PartnerFaqSection();
      default: return const ProgramSection();
    }
  }

  String _sectionTitle() {
    final item = _menuItems.firstWhere((m) => m['key'] == _selectedMenu, orElse: () => _menuItems.first);
    return item['label'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(_sectionTitle()),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF43A047)]),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.handshake, color: Color(0xFF2E7D32), size: 30),
              ),
              accountName: Text(user?.username ?? 'Партнёр', style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(user?.email ?? '', style: const TextStyle(fontSize: 12)),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _menuItems.map((item) {
                  final key = item['key'] as String;
                  final isSelected = _selectedMenu == key;
                  return ListTile(
                    leading: Icon(item['icon'] as IconData, color: isSelected ? const Color(0xFF2E7D32) : AppColors.textSecondary),
                    title: Text(item['label'] as String, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF2E7D32) : null)),
                    selected: isSelected,
                    selectedTileColor: const Color(0xFF2E7D32).withValues(alpha: 0.08),
                    onTap: () {
                      setState(() => _selectedMenu = key);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      body: _buildSection(),
    );
  }
}
