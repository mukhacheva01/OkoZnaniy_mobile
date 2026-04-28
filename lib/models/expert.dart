class ExpertMatch {
  final int id;
  final String name;
  final String? avatar;
  final double rating;
  final int completedOrders;
  final List<String> specializations;
  final double? hourlyRate;
  final int reviewsCount;

  ExpertMatch({
    required this.id,
    required this.name,
    this.avatar,
    this.rating = 0,
    this.completedOrders = 0,
    this.specializations = const [],
    this.hourlyRate,
    this.reviewsCount = 0,
  });

  factory ExpertMatch.fromJson(Map<String, dynamic> json) => ExpertMatch(
    id: json['id'] as int,
    name: json['name'] as String? ?? json['username'] as String? ?? '',
    avatar: json['avatar'] as String?,
    rating: (json['rating'] as num?)?.toDouble() ?? 0,
    completedOrders: json['completed_orders'] as int? ?? 0,
    specializations: (json['specializations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
    reviewsCount: json['reviews_count'] as int? ?? 0,
  );
}

class ExpertStats {
  final int totalOrders;
  final int completedOrders;
  final double avgRating;
  final double totalEarnings;
  final int activeOrders;
  final int totalReviews;
  final double responseRate;

  ExpertStats({
    this.totalOrders = 0,
    this.completedOrders = 0,
    this.avgRating = 0,
    this.totalEarnings = 0,
    this.activeOrders = 0,
    this.totalReviews = 0,
    this.responseRate = 0,
  });

  factory ExpertStats.fromJson(Map<String, dynamic> json) => ExpertStats(
    totalOrders: json['total_orders'] as int? ?? 0,
    completedOrders: json['completed_orders'] as int? ?? 0,
    avgRating: (json['avg_rating'] as num?)?.toDouble() ?? 0,
    totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0,
    activeOrders: json['active_orders'] as int? ?? 0,
    totalReviews: json['total_reviews'] as int? ?? 0,
    responseRate: (json['response_rate'] as num?)?.toDouble() ?? 0,
  );
}
