class ChatRoom {
  final int id;
  final String title;
  final int? orderId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final List<ChatParticipant> participants;
  final bool isFrozen;
  final String? frozenReason;

  ChatRoom({
    required this.id,
    required this.title,
    this.orderId,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.participants = const [],
    this.isFrozen = false,
    this.frozenReason,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      orderId: json['order_id'] as int?,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.tryParse(json['last_message_at'] as String)
          : null,
      unreadCount: json['unread_count'] as int? ?? 0,
      isFrozen: json['is_frozen'] as bool? ?? false,
      frozenReason: json['frozen_reason'] as String?,
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) =>
                  ChatParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ChatParticipant {
  final int userId;
  final String username;
  final String? avatar;

  ChatParticipant({
    required this.userId,
    required this.username,
    this.avatar,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      userId: json['user_id'] as int,
      username: json['username'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }
}

class ChatMessage {
  final int id;
  final int roomId;
  final int senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final String? fileUrl;
  final String? fileName;
  final DateTime createdAt;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    this.fileUrl,
    this.fileName,
    required this.createdAt,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int,
      roomId: json['room_id'] as int? ?? 0,
      senderId: json['sender_id'] as int? ?? 0,
      senderName: json['sender_name'] as String? ?? '',
      senderAvatar: json['sender_avatar'] as String?,
      content: json['content'] as String? ?? '',
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      isRead: json['is_read'] as bool? ?? false,
    );
  }
}
