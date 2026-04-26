import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oko_znaniy_mobile/models/shop_work.dart';
import 'package:oko_znaniy_mobile/services/shop_service.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';

class PurchasedWorksScreen extends StatefulWidget {
  const PurchasedWorksScreen({super.key});

  @override
  State<PurchasedWorksScreen> createState() => _PurchasedWorksScreenState();
}

class _PurchasedWorksScreenState extends State<PurchasedWorksScreen> {
  final ShopService _shopService = ShopService();
  List<ShopWork> _works = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorks();
  }

  Future<void> _loadWorks() async {
    setState(() => _isLoading = true);
    try {
      _works = await _shopService.getPurchasedWorks();
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Купленные работы')),
      body: RefreshIndicator(
        onRefresh: _loadWorks,
        child: _isLoading
            ? const AppLoading()
            : _works.isEmpty
                ? const EmptyState(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Нет купленных работ',
                  )
                : ListView.builder(
                    itemCount: _works.length,
                    itemBuilder: (context, index) {
                      final work = _works[index];
                      return ListTile(
                        title: Text(work.title),
                        subtitle: Text(work.workType),
                        trailing: Text(
                          '${work.price.toStringAsFixed(0)} \u20BD',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () =>
                            context.push('/shop/works/${work.id}'),
                      );
                    },
                  ),
      ),
    );
  }
}
