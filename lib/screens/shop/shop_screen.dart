import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/config/routes.dart';
import 'package:oko_znaniy_mobile/models/shop_work.dart';
import 'package:oko_znaniy_mobile/services/shop_service.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopService _shopService = ShopService();
  List<ShopWork> _works = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWorks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWorks({String? search}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _works = await _shopService.getShopWorks(search: search);
    } catch (e) {
      _error = 'Ошибка загрузки магазина';
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Магазин готовых работ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => context.push(AppRoutes.purchasedWorks),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск работ...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadWorks();
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) => _loadWorks(search: value),
            ),
          ),

          // Works list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadWorks(),
              child: _isLoading
                  ? const AppLoading(message: 'Загрузка...')
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _works.isEmpty
                          ? const EmptyState(
                              icon: Icons.store_outlined,
                              title: 'Нет доступных работ',
                              subtitle: 'Попробуйте изменить запрос',
                            )
                          : ListView.builder(
                              itemCount: _works.length,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                return _buildWorkCard(_works[index]);
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkCard(ShopWork work) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/shop/works/${work.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                work.title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                work.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (work.workType.isNotEmpty)
                    Chip(
                      label: Text(work.workType,
                          style: const TextStyle(fontSize: 11)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  const Spacer(),
                  Text(
                    '${work.price.toStringAsFixed(0)} \u20BD',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
