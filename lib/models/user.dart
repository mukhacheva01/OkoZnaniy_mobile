class User {
  final int id;
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final String role;
  final String? avatar;
  final String? phone;
  final double balance;
  final double frozenBalance;
  final bool isExpert;
  final bool isPartner;
  final String? referralCode;
  final double rating;
  final int completedOrders;
  final int activeOrders;
  final int totalOrders;
  final double totalSpent;
  final bool emailVerified;
  // Expert-specific fields
  final String? bio;
  final String? education;
  final int experienceYears;
  final double hourlyRate;
  final List<String> skills;
  final String? portfolioUrl;
  final String verificationStatus; // 'none', 'pending', 'verified', 'rejected'
  final double totalEarnings;
  final int totalReviews;
  final String avgResponseTime;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    required this.role,
    this.avatar,
    this.phone,
    this.balance = 0,
    this.frozenBalance = 0,
    this.isExpert = false,
    this.isPartner = false,
    this.referralCode,
    this.rating = 0,
    this.completedOrders = 0,
    this.activeOrders = 0,
    this.totalOrders = 0,
    this.totalSpent = 0,
    this.emailVerified = false,
    this.bio,
    this.education,
    this.experienceYears = 0,
    this.hourlyRate = 0,
    this.skills = const [],
    this.portfolioUrl,
    this.verificationStatus = 'none',
    this.totalEarnings = 0,
    this.totalReviews = 0,
    this.avgResponseTime = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String? ?? 'client',
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      frozenBalance: (json['frozen_balance'] as num?)?.toDouble() ?? 0,
      isExpert: json['is_expert'] as bool? ?? false,
      isPartner: json['is_partner'] as bool? ?? false,
      referralCode: json['referral_code'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      completedOrders: json['completed_orders'] as int? ?? 0,
      activeOrders: json['active_orders'] as int? ?? 0,
      totalOrders: json['total_orders'] as int? ?? 0,
      totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
      emailVerified: json['email_verified'] as bool? ?? false,
      bio: json['bio'] as String?,
      education: json['education'] as String?,
      experienceYears: json['experience_years'] as int? ?? 0,
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble() ?? 0,
      skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? [],
      portfolioUrl: json['portfolio_url'] as String?,
      verificationStatus: json['verification_status'] as String? ?? 'none',
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      avgResponseTime: json['avg_response_time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'avatar': avatar,
      'phone': phone,
      'balance': balance,
      'frozen_balance': frozenBalance,
      'is_expert': isExpert,
      'is_partner': isPartner,
      'referral_code': referralCode,
      'rating': rating,
      'completed_orders': completedOrders,
      'active_orders': activeOrders,
      'total_orders': totalOrders,
      'total_spent': totalSpent,
      'email_verified': emailVerified,
      'bio': bio,
      'education': education,
      'experience_years': experienceYears,
      'hourly_rate': hourlyRate,
      'skills': skills,
      'portfolio_url': portfolioUrl,
      'verification_status': verificationStatus,
      'total_earnings': totalEarnings,
      'total_reviews': totalReviews,
      'avg_response_time': avgResponseTime,
    };
  }

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      return '$firstName ${lastName ?? ''}'.trim();
    }
    return username;
  }

  double get avgOrderCost => totalOrders > 0 ? totalSpent / totalOrders : 0;
  double get successRate =>
      totalOrders > 0 ? (completedOrders / totalOrders) * 100 : 0;
}
