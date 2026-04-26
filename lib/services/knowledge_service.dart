import 'package:oko_znaniy_mobile/config/api_config.dart';
import 'package:oko_znaniy_mobile/models/knowledge.dart';
import 'package:oko_znaniy_mobile/services/api_service.dart';

class KnowledgeService {
  final ApiService _api = ApiService();

  Future<List<KnowledgeQuestion>> getQuestions({
    int page = 1,
    String? search,
    String? subject,
  }) async {
    final response = await _api.get(
      ApiEndpoints.knowledgeQuestions,
      queryParameters: {
        'page': page,
        if (search != null) 'search': search,
        if (subject != null) 'subject': subject,
      },
    );
    final results = response.data is List
        ? response.data as List<dynamic>
        : (response.data['results'] as List<dynamic>? ?? []);
    return results
        .map((e) => KnowledgeQuestion.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<KnowledgeQuestion> getQuestionDetail(int id) async {
    final response =
        await _api.get(ApiEndpoints.knowledgeQuestionDetail(id));
    return KnowledgeQuestion.fromJson(
        response.data as Map<String, dynamic>);
  }

  Future<KnowledgeQuestion> createQuestion(Map<String, dynamic> data) async {
    final response =
        await _api.post(ApiEndpoints.knowledgeQuestions, data: data);
    return KnowledgeQuestion.fromJson(
        response.data as Map<String, dynamic>);
  }
}
