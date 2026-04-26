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
  final bool isExpert;
  final bool isPartner;
  final String? referralCode;
  final double rating;
  final int completedOrders;

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
    this.isExpert = false,
    this.isPartner = false,
    this.referralCode,
    this.rating = 0,
    this.completedOrders = 0,
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
      isExpert: json['is_expert'] as bool? ?? false,
      isPartner: json['is_partner'] as bool? ?? false,
      referralCode: json['referral_code'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      completedOrders: json['completed_orders'] as int? ?? 0,
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
      'is_expert': isExpert,
      'is_partner': isPartner,
      'referral_code': referralCode,
    };
  }

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      return '$firstName ${lastName ?? ''}'.trim();
    }
    return username;
  }
}
