import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/chat_message.dart';
import 'package:oko_znaniy_mobile/services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  List<ChatRoom> _rooms = [];
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatRoom> get rooms => _rooms;
  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalUnread =>
      _rooms.fold(0, (sum, room) => sum + room.unreadCount);

  Future<void> fetchRooms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _rooms = await _service.getChatRooms();
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки чатов';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMessages(int roomId, {bool refresh = false}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages = await _service.getMessages(roomId);
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки сообщений';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendMessage(int roomId, String content) async {
    try {
      final message = await _service.sendMessage(roomId, content);
      _messages.add(message);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка отправки сообщения';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
