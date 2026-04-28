import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/personnel_section.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/finance_section.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/partners_section.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/statistics_section.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/communication_section.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/contact_bans_section.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/recommendations_section.dart';
import 'package:oko_znaniy_mobile/screens/director/sections/faq_section.dart';

class DirectorDashboardScreen extends StatefulWidget {
  const DirectorDashboardScreen({super.key});

  @override
  State<DirectorDashboardScreen> createState() => _DirectorDashboardScreenState();
}

class _DirectorDashboardScreenState extends State<DirectorDashboardScreen> {
  String _selectedMenu = 'personnel';

  static const _menuItems = [
    {'key': 'personnel', 'label': 'Персонал', 'icon': Icons.people},
    {'key': 'finance', 'label': 'Финансы', 'icon': Icons.account_balance},
    {'key': 'partners', 'label': 'Партнёры', 'icon': Icons.handshake},
    {'key': 'statistics', 'label': 'Статистика', 'icon': Icons.bar_chart},
    {'key': 'communication', 'label': 'Коммуникация', 'icon': Icons.chat},
    {'key': 'contact_bans', 'label': 'Баны контактов', 'icon': Icons.block},
    {'key': 'recommendations', 'label': 'Рекомендации', 'icon': Icons.lightbulb},
    {'key': 'faq', 'label': 'FAQ', 'icon': Icons.help_outline},
  ];

  Widget _buildSection() {
    switch (_selectedMenu) {
      case 'personnel': return const PersonnelSection();
      case 'finance': return const FinanceSection();
      case 'partners': return const DirectorPartnersSection();
      case 'statistics': return const StatisticsSection();
      case 'communication': return const DirectorCommunicationSection();
      case 'contact_bans': return const DirectorContactBansSection();
      case 'recommendations': return const RecommendationsSection();
      case 'faq': return const FaqSection();
      default: return const PersonnelSection();
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
        backgroundColor: const Color(0xFF7B1FA2),
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
                gradient: LinearGradient(colors: [Color(0xFF7B1FA2), Color(0xFF9C27B0)]),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.business, color: Color(0xFF7B1FA2), size: 30),
              ),
              accountName: Text(user?.username ?? 'Директор', style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(user?.email ?? '', style: const TextStyle(fontSize: 12)),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _menuItems.map((item) {
                  final key = item['key'] as String;
                  final isSelected = _selectedMenu == key;
                  return ListTile(
                    leading: Icon(item['icon'] as IconData, color: isSelected ? const Color(0xFF7B1FA2) : AppColors.textSecondary),
                    title: Text(item['label'] as String, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF7B1FA2) : null)),
                    selected: isSelected,
                    selectedTileColor: const Color(0xFF7B1FA2).withValues(alpha: 0.08),
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
