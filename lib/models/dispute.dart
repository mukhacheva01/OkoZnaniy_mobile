class Dispute {
  final int id;
  final int orderId;
  final String reason;
  final String status; // 'new', 'in_progress', 'resolved', 'closed'
  final String? resolution;
  final int? claimantId;
  final String? claimantName;
  final int? respondentId;
  final String? respondentName;
  final DateTime createdAt;

  Dispute({
    required this.id,
    required this.orderId,
    required this.reason,
    required this.status,
    this.resolution,
    this.claimantId,
    this.claimantName,
    this.respondentId,
    this.respondentName,
    required this.createdAt,
  });

  factory Dispute.fromJson(Map<String, dynamic> json) => Dispute(
    id: json['id'] as int,
    orderId: json['order_id'] as int? ?? json['order'] as int? ?? 0,
    reason: json['reason'] as String? ?? '',
    status: json['status'] as String? ?? 'new',
    resolution: json['resolution'] as String?,
    claimantId: json['claimant_id'] as int?,
    claimantName: json['claimant_name'] as String?,
    respondentId: json['respondent_id'] as int?,
    respondentName: json['respondent_name'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
  );

  String get statusLabel {
    const labels = {'new': 'Новый', 'in_progress': 'В работе', 'resolved': 'Решён', 'closed': 'Закрыт'};
    return labels[status] ?? status;
  }
}
