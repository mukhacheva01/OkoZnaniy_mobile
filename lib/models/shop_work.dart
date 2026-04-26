class ShopWork {
  final int id;
  final String title;
  final String description;
  final String workType;
  final String subject;
  final double price;
  final double? rating;
  final int salesCount;
  final String? previewUrl;
  final DateTime createdAt;
  final int? authorId;
  final String? authorName;

  ShopWork({
    required this.id,
    required this.title,
    required this.description,
    required this.workType,
    required this.subject,
    required this.price,
    this.rating,
    this.salesCount = 0,
    this.previewUrl,
    required this.createdAt,
    this.authorId,
    this.authorName,
  });

  factory ShopWork.fromJson(Map<String, dynamic> json) {
    return ShopWork(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      workType: json['work_type'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble(),
      salesCount: json['sales_count'] as int? ?? 0,
      previewUrl: json['preview_url'] as String?,
      createdAt: DateTime.parse(
          json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      authorId: json['author_id'] as int?,
      authorName: json['author_name'] as String?,
    );
  }
}
