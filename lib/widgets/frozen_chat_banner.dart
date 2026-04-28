import 'package:flutter/material.dart';

class FrozenChatBanner extends StatelessWidget {
  final String? reason;

  const FrozenChatBanner({super.key, this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE53935).withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Icon(Icons.lock, color: Color(0xFFE53935), size: 32),
          const SizedBox(height: 8),
          const Text('Чат заморожен', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFE53935), fontSize: 16)),
          const SizedBox(height: 4),
          Text(
            reason ?? 'Обнаружен обмен контактными данными. Чат заморожен до завершения проверки.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
