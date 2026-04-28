class Order {
  final int id;
  final String title;
  final String description;
  final String workType;
  final String subject;
  final String status;
  final String priority;
  final double? price;
  final double? budget;
  final DateTime? deadline;
  final DateTime createdAt;
  final int? clientId;
  final String? clientName;
  final int? expertId;
  final String? expertName;
  final int filesCount;
  final int commentsCount;
  final int bidsCount;
  final bool hasNewMessages;
  final bool isFrozen;
  final String? frozenReason;
  final String? complexityLevel;
  final String? topic;

  Order({
    required this.id,
    required this.title,
    required this.description,
    required this.workType,
    required this.subject,
    required this.status,
    this.priority = 'medium',
    this.price,
    this.budget,
    this.deadline,
    required this.createdAt,
    this.clientId,
    this.clientName,
    this.expertId,
    this.expertName,
    this.filesCount = 0,
    this.commentsCount = 0,
    this.bidsCount = 0,
    this.hasNewMessages = false,
    this.isFrozen = false,
    this.frozenReason,
    this.complexityLevel,
    this.topic,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      workType: json['work_type'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      status: json['status'] as String? ?? 'new',
      priority: json['priority'] as String? ?? 'medium',
      price: (json['price'] as num?)?.toDouble(),
      budget: (json['budget'] as num?)?.toDouble(),
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'] as String)
          : null,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      clientId: json['client_id'] as int?,
      clientName: json['client_name'] as String?,
      expertId: json['expert_id'] as int?,
      expertName: json['expert_name'] as String?,
      filesCount: json['files_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      bidsCount: json['bids_count'] as int? ?? 0,
      hasNewMessages: json['has_new_messages'] as bool? ?? false,
      isFrozen: json['is_frozen'] as bool? ?? false,
      frozenReason: json['frozen_reason'] as String?,
      complexityLevel: json['complexity_level'] as String?,
      topic: json['topic'] as String?,
    );
  }

  String get statusLabel {
    const labels = {
      'new': 'Новый',
      'confirming': 'На подтверждении',
      'in_progress': 'В работе',
      'waiting_payment': 'Ожидает оплаты',
      'review': 'На проверке',
      'completed': 'Завершен',
      'revision': 'На доработке',
      'download': 'Ожидает скачивания',
      'closed': 'Закрыт',
      'cancelled': 'Отменен',
      'dispute': 'Спор',
      'frozen': 'Заморожен',
      'overdue': 'Просрочен',
    };
    return labels[status] ?? status;
  }

  String get priorityLabel {
    const labels = {
      'low': 'Низкий',
      'medium': 'Средний',
      'high': 'Высокий',
      'urgent': 'Срочный',
    };
    return labels[priority] ?? priority;
  }
}
