import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:intl/intl.dart';

class BanGuard extends StatelessWidget {
  final Widget child;
  final String actionLabel;

  const BanGuard({super.key, required this.child, this.actionLabel = 'Действие'});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null || !user.isEffectivelyBanned) return child;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE53935).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.block, color: Color(0xFFE53935)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Доступ ограничен', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE53935))),
                    const SizedBox(height: 4),
                    Text(
                      user.frozenReason ?? '$actionLabel недоступно. Пользователь находится на проверке за обмен контактными данными.',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    if (user.contactBanUntil != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Бан до: ${DateFormat('dd.MM.yyyy HH:mm').format(user.contactBanUntil!)}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFFE53935)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        AbsorbPointer(
          child: Opacity(opacity: 0.4, child: child),
        ),
      ],
    );
  }
}

class BanAwareButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const BanAwareButton({super.key, this.onPressed, required this.child, this.style});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final isBanned = user?.isEffectivelyBanned ?? false;

    return ElevatedButton(
      onPressed: isBanned ? null : onPressed,
      style: style,
      child: isBanned
          ? Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.block, size: 16),
              const SizedBox(width: 4),
              Flexible(child: Text('Заблокировано', overflow: TextOverflow.ellipsis)),
            ])
          : child,
    );
  }
}
