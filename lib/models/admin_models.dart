class AdminPartner {
  final int id;
  final String username;
  final String email;
  final int totalReferrals;
  final double totalEarnings;
  final double commissionRate;
  final bool isActive;
  final DateTime joinedAt;

  AdminPartner({
    required this.id,
    required this.username,
    required this.email,
    required this.totalReferrals,
    required this.totalEarnings,
    required this.commissionRate,
    required this.isActive,
    required this.joinedAt,
  });
}

class AdminEarning {
  final int id;
  final int partnerId;
  final String partnerName;
  final String referralName;
  final double amount;
  final String type;
  final bool isPaid;
  final DateTime createdAt;

  AdminEarning({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.referralName,
    required this.amount,
    required this.type,
    required this.isPaid,
    required this.createdAt,
  });

  AdminEarning copyWith({bool? isPaid}) {
    return AdminEarning(
      id: id,
      partnerId: partnerId,
      partnerName: partnerName,
      referralName: referralName,
      amount: amount,
      type: type,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt,
    );
  }
}

class AdminUser {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isBlocked;
  final String? blockReason;
  final DateTime createdAt;
  final int ordersCount;
  final bool isContactBanned;
  final DateTime? contactBanUntil;
  final String? contactBanReason;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isBlocked,
    this.blockReason,
    required this.createdAt,
    required this.ordersCount,
    this.isContactBanned = false,
    this.contactBanUntil,
    this.contactBanReason,
  });

  AdminUser copyWith({
    bool? isBlocked,
    String? blockReason,
    String? role,
    bool? isContactBanned,
    DateTime? contactBanUntil,
    String? contactBanReason,
  }) {
    return AdminUser(
      id: id,
      username: username,
      email: email,
      role: role ?? this.role,
      isBlocked: isBlocked ?? this.isBlocked,
      blockReason: blockReason ?? this.blockReason,
      createdAt: createdAt,
      ordersCount: ordersCount,
      isContactBanned: isContactBanned ?? this.isContactBanned,
      contactBanUntil: contactBanUntil ?? this.contactBanUntil,
      contactBanReason: contactBanReason ?? this.contactBanReason,
    );
  }
}

class AdminOrder {
  final int id;
  final String title;
  final String status;
  final String clientName;
  final String? expertName;
  final double? price;
  final DateTime? deadline;
  final DateTime createdAt;
  final bool isProblem;
  final String? problemType;

  AdminOrder({
    required this.id,
    required this.title,
    required this.status,
    required this.clientName,
    this.expertName,
    this.price,
    this.deadline,
    required this.createdAt,
    this.isProblem = false,
    this.problemType,
  });

  AdminOrder copyWith({String? status}) {
    return AdminOrder(
      id: id,
      title: title,
      status: status ?? this.status,
      clientName: clientName,
      expertName: expertName,
      price: price,
      deadline: deadline,
      createdAt: createdAt,
      isProblem: isProblem,
      problemType: problemType,
    );
  }
}

class SupportTicket {
  final int id;
  final String title;
  final String category;
  final String priority;
  final String status;
  final String authorName;
  final String? assigneeName;
  final List<String> tags;
  final DateTime createdAt;
  final List<TicketMessage> messages;

  SupportTicket({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.status,
    required this.authorName,
    this.assigneeName,
    this.tags = const [],
    required this.createdAt,
    this.messages = const [],
  });

  SupportTicket copyWith({String? status, String? assigneeName, List<String>? tags}) {
    return SupportTicket(
      id: id,
      title: title,
      category: category,
      priority: priority,
      status: status ?? this.status,
      authorName: authorName,
      assigneeName: assigneeName ?? this.assigneeName,
      tags: tags ?? this.tags,
      createdAt: createdAt,
      messages: messages,
    );
  }
}

class TicketMessage {
  final int id;
  final String senderName;
  final String text;
  final DateTime createdAt;
  final bool isAdmin;

  TicketMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.createdAt,
    this.isAdmin = false,
  });
}

class ArbitrationCase {
  final int id;
  final String title;
  final String status;
  final String claimantName;
  final String respondentName;
  final int orderId;
  final String? assigneeName;
  final String? decision;
  final double? refundAmount;
  final DateTime createdAt;
  final List<TicketMessage> messages;

  ArbitrationCase({
    required this.id,
    required this.title,
    required this.status,
    required this.claimantName,
    required this.respondentName,
    required this.orderId,
    this.assigneeName,
    this.decision,
    this.refundAmount,
    required this.createdAt,
    this.messages = const [],
  });

  ArbitrationCase copyWith({String? status, String? assigneeName, String? decision, double? refundAmount}) {
    return ArbitrationCase(
      id: id,
      title: title,
      status: status ?? this.status,
      claimantName: claimantName,
      respondentName: respondentName,
      orderId: orderId,
      assigneeName: assigneeName ?? this.assigneeName,
      decision: decision ?? this.decision,
      refundAmount: refundAmount ?? this.refundAmount,
      createdAt: createdAt,
      messages: messages,
    );
  }
}

class AdminChatRoom {
  final int id;
  final String name;
  final bool isPrivate;
  final int membersCount;
  final List<TicketMessage> messages;

  AdminChatRoom({
    required this.id,
    required this.name,
    required this.isPrivate,
    required this.membersCount,
    this.messages = const [],
  });
}

class AdminStats {
  final int totalUsers;
  final int totalExperts;
  final int totalOrders;
  final int activeOrders;
  final int openTickets;
  final int arbitrationCases;
  final double totalRevenue;
  final double platformCommission;

  AdminStats({
    required this.totalUsers,
    required this.totalExperts,
    required this.totalOrders,
    required this.activeOrders,
    required this.openTickets,
    required this.arbitrationCases,
    required this.totalRevenue,
    required this.platformCommission,
  });
}

class CatalogItem {
  final int id;
  final String name;
  final String type;
  final bool isActive;

  CatalogItem({
    required this.id,
    required this.name,
    required this.type,
    required this.isActive,
  });
}
