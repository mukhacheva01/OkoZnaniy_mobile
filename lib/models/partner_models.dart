class PartnerReferral {
  final int id;
  final String username;
  final String email;
  final String role;
  final int ordersCount;
  final DateTime registeredAt;

  PartnerReferral({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.ordersCount,
    required this.registeredAt,
  });
}

class PartnerEarning {
  final int id;
  final int? orderId;
  final String referralName;
  final String type;
  final double amount;
  final bool isPaid;
  final bool isCancelled;
  final DateTime createdAt;

  PartnerEarning({
    required this.id,
    this.orderId,
    required this.referralName,
    required this.type,
    required this.amount,
    required this.isPaid,
    this.isCancelled = false,
    required this.createdAt,
  });
}

class PartnerStats {
  final int totalReferrals;
  final int activeReferrals;
  final double totalEarned;
  final double pendingPayout;
  final double commissionRate;
  final String referralLink;
  final String referralCode;

  PartnerStats({
    required this.totalReferrals,
    required this.activeReferrals,
    required this.totalEarned,
    required this.pendingPayout,
    required this.commissionRate,
    required this.referralLink,
    required this.referralCode,
  });
}

class PromoMaterial {
  final int id;
  final String title;
  final String description;
  final String type;
  final String? imageUrl;

  PromoMaterial({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.imageUrl,
  });
}

class PartnerChatRoom {
  final int id;
  final String name;
  final int membersCount;
  final String lastMessage;
  final DateTime lastMessageAt;

  PartnerChatRoom({
    required this.id,
    required this.name,
    required this.membersCount,
    required this.lastMessage,
    required this.lastMessageAt,
  });
}

class PartnerFaqItem {
  final String question;
  final String answer;

  PartnerFaqItem({required this.question, required this.answer});
}

class PartnerMapEntry {
  final int id;
  final String name;
  final String city;
  final double lat;
  final double lng;
  final int referrals;
  final bool isActive;

  PartnerMapEntry({
    required this.id,
    required this.name,
    required this.city,
    required this.lat,
    required this.lng,
    required this.referrals,
    required this.isActive,
  });
}
