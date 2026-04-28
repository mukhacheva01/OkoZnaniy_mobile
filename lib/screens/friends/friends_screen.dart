import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/test_data_provider.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testData = context.watch<TestDataProvider>();
    final friends = testData.friends;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Друзья'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            onPressed: () => _showAddFriendDialog(context, testData),
          ),
        ],
      ),
      body: friends.isEmpty
          ? const EmptyState(icon: Icons.people_outline, title: 'Нет друзей', subtitle: 'Добавьте друзей')
          : ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Text(friend.name[0], style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ),
                      if (friend.isOnline)
                        Positioned(right: 0, bottom: 0, child: Container(
                          width: 12, height: 12,
                          decoration: BoxDecoration(color: AppColors.success, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        )),
                    ],
                  ),
                  title: Text(friend.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(friend.role == 'expert' ? 'Эксперт' : 'Клиент', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline, size: 20),
                        onPressed: () => context.push('/chats/1'),
                      ),
                      IconButton(
                        icon: Icon(Icons.person_remove_outlined, size: 20, color: AppColors.error),
                        onPressed: () {
                          testData.removeFriend(friend.id);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${friend.name} удалён из друзей')));
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    if (friend.role == 'expert') {
                      context.push('/experts/${friend.id}');
                    }
                  },
                );
              },
            ),
    );
  }

  void _showAddFriendDialog(BuildContext context, TestDataProvider testData) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Добавить друга'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Имя или email', prefixIcon: Icon(Icons.search))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                testData.addFriend(Friend(
                  id: DateTime.now().millisecondsSinceEpoch,
                  name: controller.text,
                  role: 'client',
                ));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Друг добавлен')));
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }
}
