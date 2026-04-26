class KnowledgeQuestion {
  final int id;
  final String title;
  final String content;
  final String? subject;
  final int authorId;
  final String authorName;
  final int answersCount;
  final int viewsCount;
  final bool isSolved;
  final DateTime createdAt;

  KnowledgeQuestion({
    required this.id,
    required this.title,
    required this.content,
    this.subject,
    required this.authorId,
    required this.authorName,
    this.answersCount = 0,
    this.viewsCount = 0,
    this.isSolved = false,
    required this.createdAt,
  });

  factory KnowledgeQuestion.fromJson(Map<String, dynamic> json) {
    return KnowledgeQuestion(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      subject: json['subject'] as String?,
      authorId: json['author_id'] as int? ?? 0,
      authorName: json['author_name'] as String? ?? '',
      answersCount: json['answers_count'] as int? ?? 0,
      viewsCount: json['views_count'] as int? ?? 0,
      isSolved: json['is_solved'] as bool? ?? false,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}

class KnowledgeAnswer {
  final int id;
  final int questionId;
  final String content;
  final int authorId;
  final String authorName;
  final bool isAccepted;
  final int likesCount;
  final DateTime createdAt;

  KnowledgeAnswer({
    required this.id,
    required this.questionId,
    required this.content,
    required this.authorId,
    required this.authorName,
    this.isAccepted = false,
    this.likesCount = 0,
    required this.createdAt,
  });

  factory KnowledgeAnswer.fromJson(Map<String, dynamic> json) {
    return KnowledgeAnswer(
      id: json['id'] as int,
      questionId: json['question_id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      authorId: json['author_id'] as int? ?? 0,
      authorName: json['author_name'] as String? ?? '',
      isAccepted: json['is_accepted'] as bool? ?? false,
      likesCount: json['likes_count'] as int? ?? 0,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}
