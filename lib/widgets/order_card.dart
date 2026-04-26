import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/order.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

  Color _statusColor(String status) {
    const colors = {
      'new': Color(0xFF52C41A),
      'confirming': Color(0xFFFFB34A),
      'in_progress': Color(0xFF9B4AFF),
      'waiting_payment': Color(0xFFFFA831),
      'review': Color(0xFF2B9FE6),
      'completed': Color(0xFF52C41A),
      'revision': Color(0xFFFF4D4F),
      'download': Color(0xFF667EEA),
      'closed': Color(0xFF9CA3AF),
      'cancelled': Color(0xFFFF4D4F),
      'dispute': Color(0xFFFF4D4F),
    };
    return colors[status] ?? const Color(0xFF9CA3AF);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/orders/${order.id}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      order.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(order.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Text(
                      order.statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: _statusColor(order.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                order.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (order.workType.isNotEmpty) ...[
                    Icon(Icons.category_outlined,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(order.workType,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 12),
                  ],
                  if (order.deadline != null) ...[
                    Icon(Icons.schedule,
                        size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd.MM.yyyy').format(order.deadline!),
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                  ],
                  const Spacer(),
                  if (order.price != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(64),
                      ),
                      child: Text(
                        '${order.price!.toStringAsFixed(0)} \u20BD',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
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
