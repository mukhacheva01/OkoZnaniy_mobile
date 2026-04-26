import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/models/order.dart';

class AvailableOrdersScreen extends StatefulWidget {
  const AvailableOrdersScreen({super.key});

  @override
  State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  String _sortBy = 'date';
  String? _filterSubject;
  String? _filterType;

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final isTest = context.watch<AuthProvider>().isTestUser;
    var orders = isTest ? List<Order>.from(testData.availableOrders) : <Order>[];

    if (_filterSubject != null) {
      orders = orders.where((o) => o.subject == _filterSubject).toList();
    }
    if (_filterType != null) {
      orders = orders.where((o) => o.workType == _filterType).toList();
    }
    switch (_sortBy) {
      case 'budget_asc':
        orders.sort((a, b) => (a.budget ?? 0).compareTo(b.budget ?? 0));
        break;
      case 'budget_desc':
        orders.sort((a, b) => (b.budget ?? 0).compareTo(a.budget ?? 0));
        break;
      case 'deadline':
        orders.sort((a, b) => (a.deadline ?? DateTime(2099)).compareTo(b.deadline ?? DateTime(2099)));
        break;
      default:
        orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    final subjects = testData.availableOrders.map((o) => o.subject).toSet().toList();
    final types = testData.availableOrders.map((o) => o.workType).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Доступные заказы'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (v) => setState(() => _sortBy = v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'date', child: Text('По дате')),
              const PopupMenuItem(value: 'budget_desc', child: Text('Бюджет ↓')),
              const PopupMenuItem(value: 'budget_asc', child: Text('Бюджет ↑')),
              const PopupMenuItem(value: 'deadline', child: Text('По дедлайну')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildFilterChip('Все предметы', _filterSubject == null, () => setState(() => _filterSubject = null)),
                ...subjects.map((s) => _buildFilterChip(s, _filterSubject == s, () => setState(() => _filterSubject = s))),
                const SizedBox(width: 8),
                Container(width: 1, height: 24, color: AppColors.divider, margin: const EdgeInsets.symmetric(vertical: 12)),
                const SizedBox(width: 8),
                _buildFilterChip('Все типы', _filterType == null, () => setState(() => _filterType = null)),
                ...types.map((t) => _buildFilterChip(t, _filterType == t, () => setState(() => _filterType = t))),
              ],
            ),
          ),
          Expanded(
            child: orders.isEmpty
                ? Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
                      const SizedBox(height: 16),
                      const Text('Нет доступных заказов'),
                    ],
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) => _buildOrderCard(context, orders[index], testData),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.textPrimary)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order, TestDataProvider testData) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showOrderDetail(context, order, testData),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(order.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold))),
                  if (order.budget != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
                      child: Text('${order.budget!.toStringAsFixed(0)} ₽', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(order.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildTag(Icons.book_outlined, order.subject),
                  const SizedBox(width: 8),
                  _buildTag(Icons.assignment_outlined, order.workType),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(order.clientName ?? 'Клиент', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const Spacer(),
                  if (order.deadline != null) ...[
                    Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text('до ${_formatDate(order.deadline!)}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                  const SizedBox(width: 12),
                  Icon(Icons.how_to_vote_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${order.bidsCount} откл.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(64)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 12, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: AppColors.primary)),
      ]),
    );
  }

  void _showOrderDetail(BuildContext context, Order order, TestDataProvider testData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) => _OrderDetailSheet(order: order, testData: testData, scrollController: scrollController),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _OrderDetailSheet extends StatefulWidget {
  final Order order;
  final TestDataProvider testData;
  final ScrollController scrollController;

  const _OrderDetailSheet({required this.order, required this.testData, required this.scrollController});

  @override
  State<_OrderDetailSheet> createState() => _OrderDetailSheetState();
}

class _OrderDetailSheetState extends State<_OrderDetailSheet> {
  final _priceController = TextEditingController();
  final _prepayController = TextEditingController(text: '0');
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _prepayController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        controller: widget.scrollController,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 16),
          Text(order.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(children: [
            if (order.budget != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
                child: Text('${order.budget!.toStringAsFixed(0)} ₽', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(64)),
              child: Text(order.workType, style: TextStyle(color: AppColors.primary, fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 16),
          Text(order.description, style: const TextStyle(fontSize: 14)),
          const Divider(height: 32),
          _buildInfo('Предмет', order.subject),
          _buildInfo('Клиент', order.clientName ?? '-'),
          if (order.deadline != null) _buildInfo('Дедлайн', _formatDate(order.deadline!)),
          _buildInfo('Откликов', '${order.bidsCount}'),
          const Divider(height: 32),

          Text('Разместить ставку', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Сумма (₽) *', prefixIcon: Icon(Icons.attach_money)),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _prepayController,
            decoration: const InputDecoration(labelText: 'Предоплата (%)', prefixIcon: Icon(Icons.percent), hintText: '0-100'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: 'Комментарий', prefixIcon: Icon(Icons.comment_outlined)),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              final price = double.tryParse(_priceController.text);
              if (price == null || price <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Укажите сумму')));
                return;
              }
              final bid = Bid(
                id: DateTime.now().millisecondsSinceEpoch,
                orderId: order.id,
                expertId: 0,
                expertName: 'Алексей Петров',
                expertRating: 4.9,
                expertCompletedOrders: 156,
                price: price,
                days: 7,
                prepayPercent: int.tryParse(_prepayController.text) ?? 0,
                comment: _commentController.text,
                createdAt: DateTime.now(),
              );
              widget.testData.addBid(bid);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ставка размещена')));
            },
            child: const Text('Разместить ставку'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
