import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/orders-feed') ||
        location.startsWith('/works')) {
      return 1;
    }
    if (location.startsWith('/shop')) {
      return 2;
    }
    if (location.startsWith('/chats')) {
      return 3;
    }
    if (location.startsWith('/profile')) {
      return 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isExpert = authProvider.user?.isExpert ?? false;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
              break;
            case 1:
              context.go(
                  isExpert ? AppRoutes.ordersFeed : AppRoutes.myWorks);
              break;
            case 2:
              context.go(AppRoutes.shop);
              break;
            case 3:
              context.go(AppRoutes.chatList);
              break;
            case 4:
              context.go(AppRoutes.profile);
              break;
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment),
            label: isExpert ? 'Заказы' : 'Мои работы',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Магазин',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Чаты',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}
