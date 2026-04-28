import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/overview_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/partners_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/earnings_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/blocking_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/contact_bans_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/orders_management_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/tickets_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/arbitration_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/communication_section.dart';
import 'package:oko_znaniy_mobile/screens/admin/sections/catalog_section.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _selectedMenu = 'overview';

  static const _menuItems = [
    _MenuItem('overview', Icons.dashboard_outlined, 'Обзор'),
    _MenuItem('partners', Icons.handshake_outlined, 'Партнёры'),
    _MenuItem('earnings', Icons.payments_outlined, 'Начисления'),
    _MenuItem('blocking', Icons.block_outlined, 'Блокировка'),
    _MenuItem('contact_bans', Icons.phone_disabled_outlined, 'Баны контактов'),
    _MenuItem('orders_management', Icons.assignment_outlined, 'Заказы'),
    _MenuItem('tickets', Icons.support_agent_outlined, 'Обращения'),
    _MenuItem('arbitration', Icons.gavel_outlined, 'Арбитраж'),
    _MenuItem('communication', Icons.chat_outlined, 'Коммуникация'),
    _MenuItem('catalog', Icons.category_outlined, 'Каталог'),
  ];

  Widget _buildSection() {
    switch (_selectedMenu) {
      case 'overview': return const OverviewSection();
      case 'partners': return const PartnersSection();
      case 'earnings': return const EarningsSection();
      case 'blocking': return const BlockingSection();
      case 'contact_bans': return const ContactBansSection();
      case 'orders_management': return const OrdersManagementSection();
      case 'tickets': return const TicketsSection();
      case 'arbitration': return const ArbitrationSection();
      case 'communication': return const CommunicationSection();
      case 'catalog': return const CatalogSection();
      default: return const OverviewSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final isDirector = user?.role == 'director';

    return Scaffold(
      appBar: AppBar(
        title: Text(isDirector ? 'Панель директора' : 'Панель администратора'),
        backgroundColor: isDirector ? const Color(0xFF7B1FA2) : const Color(0xFFE53935),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDirector
                      ? [const Color(0xFF7B1FA2), const Color(0xFF9C27B0)]
                      : [const Color(0xFFE53935), const Color(0xFFEF5350)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.admin_panel_settings, size: 28, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Администратор',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isDirector ? 'Директор' : 'Администратор',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _menuItems.map((item) {
                  final isSelected = _selectedMenu == item.key;
                  return ListTile(
                    leading: Icon(item.icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                    title: Text(item.label, style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    )),
                    selected: isSelected,
                    selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
                    onTap: () {
                      setState(() => _selectedMenu = item.key);
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

class _MenuItem {
  final String key;
  final IconData icon;
  final String label;
  const _MenuItem(this.key, this.icon, this.label);
}
