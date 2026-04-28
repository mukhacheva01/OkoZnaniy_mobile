class StaffMember {
  final int id;
  final String fullName;
  final String email;
  final String role;
  final bool isActive;
  final bool isArchived;
  final DateTime createdAt;

  StaffMember({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    this.isArchived = false,
    required this.createdAt,
  });

  StaffMember copyWith({bool? isActive, bool? isArchived}) {
    return StaffMember(
      id: id, fullName: fullName, email: email, role: role,
      isActive: isActive ?? this.isActive,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt,
    );
  }
}

class ExpertApplication {
  final int id;
  final String fullName;
  final String email;
  final int experienceYears;
  final String university;
  final List<String> subjects;
  final String status;
  final DateTime createdAt;

  ExpertApplication({
    required this.id,
    required this.fullName,
    required this.email,
    required this.experienceYears,
    required this.university,
    required this.subjects,
    required this.status,
    required this.createdAt,
  });

  ExpertApplication copyWith({String? status}) {
    return ExpertApplication(
      id: id, fullName: fullName, email: email,
      experienceYears: experienceYears, university: university,
      subjects: subjects, status: status ?? this.status, createdAt: createdAt,
    );
  }
}

class FinanceRecord {
  final int id;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final bool isIncome;

  FinanceRecord({
    required this.id,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    required this.isIncome,
  });
}

class DirectorPartner {
  final int id;
  final String username;
  final String email;
  final int referrals;
  final double earned;
  final double paid;
  final double commissionRate;
  final bool isActive;

  DirectorPartner({
    required this.id,
    required this.username,
    required this.email,
    required this.referrals,
    required this.earned,
    required this.paid,
    required this.commissionRate,
    required this.isActive,
  });

  DirectorPartner copyWith({double? commissionRate, bool? isActive}) {
    return DirectorPartner(
      id: id, username: username, email: email, referrals: referrals,
      earned: earned, paid: paid,
      commissionRate: commissionRate ?? this.commissionRate,
      isActive: isActive ?? this.isActive,
    );
  }
}

class PlatformKPI {
  final int totalOrders;
  final double avgCheck;
  final double conversionRate;
  final int activeUsers;
  final int newUsersThisMonth;
  final int completedOrdersThisMonth;
  final double revenueThisMonth;
  final double profitThisMonth;

  PlatformKPI({
    required this.totalOrders,
    required this.avgCheck,
    required this.conversionRate,
    required this.activeUsers,
    required this.newUsersThisMonth,
    required this.completedOrdersThisMonth,
    required this.revenueThisMonth,
    required this.profitThisMonth,
  });
}

class MeetingRequest {
  final int id;
  final String fromName;
  final String topic;
  final String status;
  final DateTime requestedAt;
  final DateTime? meetingDate;

  MeetingRequest({
    required this.id,
    required this.fromName,
    required this.topic,
    required this.status,
    required this.requestedAt,
    this.meetingDate,
  });

  MeetingRequest copyWith({String? status}) {
    return MeetingRequest(
      id: id, fromName: fromName, topic: topic,
      status: status ?? this.status,
      requestedAt: requestedAt, meetingDate: meetingDate,
    );
  }
}

class ImprovementSuggestion {
  final int id;
  final String authorName;
  final String authorRole;
  final String text;
  final DateTime createdAt;

  ImprovementSuggestion({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.text,
    required this.createdAt,
  });
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}
