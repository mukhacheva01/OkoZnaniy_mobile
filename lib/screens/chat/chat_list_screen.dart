import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/providers/chat_provider.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Чаты')),
      body: RefreshIndicator(
        onRefresh: () => chatProvider.fetchRooms(),
        child: chatProvider.isLoading && chatProvider.rooms.isEmpty
            ? const AppLoading(message: 'Загрузка чатов...')
            : chatProvider.rooms.isEmpty
                ? const EmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'Нет чатов',
                    subtitle: 'Чаты появятся при создании заказов',
                  )
                : ListView.builder(
                    itemCount: chatProvider.rooms.length,
                    itemBuilder: (context, index) {
                      final room = chatProvider.rooms[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.chat,
                              color: AppColors.primary),
                        ),
                        title: Text(
                          room.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: room.lastMessage != null
                            ? Text(
                                room.lastMessage!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              )
                            : null,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (room.lastMessageAt != null)
                              Text(
                                DateFormat('HH:mm')
                                    .format(room.lastMessageAt!),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            if (room.unreadCount > 0) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${room.unreadCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        onTap: () => context.push('/chats/${room.id}'),
                      );
                    },
                  ),
      ),
    );
  }
}
