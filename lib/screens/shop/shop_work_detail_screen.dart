import 'package:flutter/material.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/shop_work.dart';
import 'package:oko_znaniy_mobile/services/shop_service.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/app_error.dart';

class ShopWorkDetailScreen extends StatefulWidget {
  final int workId;

  const ShopWorkDetailScreen({super.key, required this.workId});

  @override
  State<ShopWorkDetailScreen> createState() => _ShopWorkDetailScreenState();
}

class _ShopWorkDetailScreenState extends State<ShopWorkDetailScreen> {
  final ShopService _shopService = ShopService();
  ShopWork? _work;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWork();
  }

  Future<void> _loadWork() async {
    setState(() => _isLoading = true);
    try {
      _work = await _shopService.getWorkDetail(widget.workId);
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки';
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _handlePurchase() async {
    try {
      await _shopService.purchaseWork(widget.workId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Работа успешно куплена!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка покупки')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Работа')),
      bottomNavigationBar: _work != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Цена',
                          style: TextStyle(color: AppColors.textSecondary)),
                      Text(
                        '${_work!.price.toStringAsFixed(0)} \u20BD',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handlePurchase,
                      child: const Text('Купить'),
                    ),
                  ),
                ],
              ),
            )
          : null,
      body: _isLoading
          ? const AppLoading()
          : _error != null
              ? AppError(message: _error!, onRetry: _loadWork)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _work!.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (_work!.workType.isNotEmpty)
                            Chip(label: Text(_work!.workType)),
                          if (_work!.subject.isNotEmpty)
                            Chip(label: Text(_work!.subject)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_work!.authorName != null) ...[
                        Row(
                          children: [
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            const SizedBox(width: 8),
                            Text('Автор: ${_work!.authorName}'),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'Описание',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(_work!.description),
                    ],
                  ),
                ),
    );
  }
}
