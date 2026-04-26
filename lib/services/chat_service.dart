import 'package:oko_znaniy_mobile/config/api_config.dart';
import 'package:oko_znaniy_mobile/models/chat_message.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';

class ChatService {
  final ApiService _api = ApiService();

  Future<List<ChatRoom>> getChatRooms() async {
    final response = await _api.get(ApiEndpoints.chatRooms);
    final results = response.data is List
        ? response.data as List<dynamic>
        : (response.data['results'] as List<dynamic>? ?? []);
    return results
        .map((e) => ChatRoom.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChatMessage>> getMessages(int roomId, {int page = 1}) async {
    final response = await _api.get(
      ApiEndpoints.chatMessages(roomId),
      queryParameters: {'page': page},
    );
    final results = response.data is List
        ? response.data as List<dynamic>
        : (response.data['results'] as List<dynamic>? ?? []);
    return results
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessage> sendMessage(int roomId, String content) async {
    final response = await _api.post(
      ApiEndpoints.chatMessages(roomId),
      data: {'content': content},
    );
    return ChatMessage.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> sendFileMessage(
      int roomId, String filePath, {String? content}) async {
    await _api.uploadFile(
      ApiEndpoints.chatMessages(roomId),
      filePath,
      extraFields: {if (content != null) 'content': content},
    );
  }
}
