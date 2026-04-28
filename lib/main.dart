import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/orders_provider.dart';
import 'package:oko_znaniy_mobile/providers/chat_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/providers/admin_test_data_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OkoZnaniyApp());
}

class OkoZnaniyApp extends StatelessWidget {
  const OkoZnaniyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => TestDataProvider()),
        ChangeNotifierProvider(create: (_) => AdminTestDataProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final router = AppRoutes.router(authProvider);
          return MaterialApp.router(
            title: 'Око Знаний',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            routerConfig: router,
            locale: const Locale('ru', 'RU'),
          );
        },
      ),
    );
  }
}
