import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/admin_models.dart';

class AdminTestDataProvider extends ChangeNotifier {
  List<AdminPartner> _partners = [];
  List<AdminEarning> _earnings = [];
  List<AdminUser> _users = [];
  List<AdminOrder> _orders = [];
  List<SupportTicket> _tickets = [];
  List<ArbitrationCase> _arbitrationCases = [];
  List<AdminChatRoom> _chatRooms = [];
  List<CatalogItem> _catalogItems = [];
  AdminStats? _stats;

  List<AdminPartner> get partners => _partners;
  List<AdminEarning> get earnings => _earnings;
  List<AdminUser> get users => _users;
  List<AdminUser> get blockedUsers => _users.where((u) => u.isBlocked).toList();
  List<AdminUser> get contactBannedUsers => _users.where((u) => u.isContactBanned).toList();
  List<AdminOrder> get orders => _orders;
  List<AdminOrder> get problemOrders => _orders.where((o) => o.isProblem).toList();
  List<SupportTicket> get tickets => _tickets;
  List<ArbitrationCase> get arbitrationCases => _arbitrationCases;
  List<AdminChatRoom> get chatRooms => _chatRooms;
  List<CatalogItem> get catalogItems => _catalogItems;
  AdminStats? get stats => _stats;

  void initAdminTestData() {
    _initStats();
    _initPartners();
    _initEarnings();
    _initUsers();
    _initOrders();
    _initTickets();
    _initArbitrationCases();
    _initChatRooms();
    _initCatalog();
    notifyListeners();
  }

  void _initStats() {
    _stats = AdminStats(
      totalUsers: 1250,
      totalExperts: 340,
      totalOrders: 5680,
      activeOrders: 423,
      openTickets: 18,
      arbitrationCases: 7,
      totalRevenue: 12500000,
      platformCommission: 1250000,
    );
  }

  void _initPartners() {
    _partners = [
      AdminPartner(id: 1, username: 'partner_ivan', email: 'ivan@partner.ru', totalReferrals: 45, totalEarnings: 67500, commissionRate: 10, isActive: true, joinedAt: DateTime(2025, 1, 15)),
      AdminPartner(id: 2, username: 'partner_maria', email: 'maria@partner.ru', totalReferrals: 78, totalEarnings: 112000, commissionRate: 12, isActive: true, joinedAt: DateTime(2024, 8, 20)),
      AdminPartner(id: 3, username: 'partner_sergey', email: 'sergey@partner.ru', totalReferrals: 12, totalEarnings: 18500, commissionRate: 8, isActive: false, joinedAt: DateTime(2025, 6, 1)),
      AdminPartner(id: 4, username: 'partner_anna', email: 'anna@partner.ru', totalReferrals: 156, totalEarnings: 234000, commissionRate: 15, isActive: true, joinedAt: DateTime(2024, 3, 10)),
      AdminPartner(id: 5, username: 'partner_dmitry', email: 'dmitry@partner.ru', totalReferrals: 33, totalEarnings: 49500, commissionRate: 10, isActive: true, joinedAt: DateTime(2025, 4, 5)),
    ];
  }

  void _initEarnings() {
    _earnings = [
      AdminEarning(id: 1, partnerId: 1, partnerName: 'partner_ivan', referralName: 'Петров А.', amount: 1500, type: 'order_commission', isPaid: true, createdAt: DateTime(2026, 4, 20)),
      AdminEarning(id: 2, partnerId: 2, partnerName: 'partner_maria', referralName: 'Сидоров В.', amount: 2200, type: 'order_commission', isPaid: false, createdAt: DateTime(2026, 4, 19)),
      AdminEarning(id: 3, partnerId: 4, partnerName: 'partner_anna', referralName: 'Козлова Н.', amount: 3500, type: 'order_commission', isPaid: false, createdAt: DateTime(2026, 4, 18)),
      AdminEarning(id: 4, partnerId: 1, partnerName: 'partner_ivan', referralName: 'Иванов К.', amount: 800, type: 'registration_bonus', isPaid: true, createdAt: DateTime(2026, 4, 17)),
      AdminEarning(id: 5, partnerId: 2, partnerName: 'partner_maria', referralName: 'Белова Е.', amount: 4100, type: 'order_commission', isPaid: false, createdAt: DateTime(2026, 4, 16)),
      AdminEarning(id: 6, partnerId: 5, partnerName: 'partner_dmitry', referralName: 'Морозов Д.', amount: 1900, type: 'order_commission', isPaid: true, createdAt: DateTime(2026, 4, 15)),
    ];
  }

  void _initUsers() {
    _users = [
      AdminUser(id: 1, username: 'Иванов Иван', email: 'ivanov@mail.ru', role: 'client', isBlocked: false, createdAt: DateTime(2025, 3, 15), ordersCount: 12),
      AdminUser(id: 2, username: 'Петрова Мария', email: 'petrova@mail.ru', role: 'expert', isBlocked: false, createdAt: DateTime(2024, 11, 1), ordersCount: 45),
      AdminUser(id: 3, username: 'Сидоров Алексей', email: 'sidorov@mail.ru', role: 'client', isBlocked: true, blockReason: 'Мошенничество при оплате', createdAt: DateTime(2025, 1, 20), ordersCount: 3),
      AdminUser(id: 4, username: 'Козлова Наталья', email: 'kozlova@mail.ru', role: 'expert', isBlocked: false, createdAt: DateTime(2024, 6, 10), ordersCount: 89),
      AdminUser(id: 5, username: 'Морозов Дмитрий', email: 'morozov@mail.ru', role: 'client', isBlocked: false, createdAt: DateTime(2025, 7, 5), ordersCount: 7, isContactBanned: true, contactBanReason: 'Обмен контактными данными в чате', contactBanUntil: DateTime(2026, 5, 10)),
      AdminUser(id: 6, username: 'Белова Елена', email: 'belova@mail.ru', role: 'client', isBlocked: true, blockReason: 'Спам в чатах', createdAt: DateTime(2025, 9, 12), ordersCount: 1),
      AdminUser(id: 7, username: 'Волков Андрей', email: 'volkov@mail.ru', role: 'expert', isBlocked: false, createdAt: DateTime(2024, 4, 22), ordersCount: 134),
      AdminUser(id: 8, username: 'Новикова Ольга', email: 'novikova@mail.ru', role: 'client', isBlocked: false, createdAt: DateTime(2025, 12, 1), ordersCount: 23, isContactBanned: true, contactBanReason: 'Передача номера телефона', contactBanUntil: null),
    ];
  }

  void _initOrders() {
    _orders = [
      AdminOrder(id: 101, title: 'Курсовая по микроэкономике', status: 'in_progress', clientName: 'Иванов И.', expertName: 'Петрова М.', price: 4500, deadline: DateTime(2026, 5, 8), createdAt: DateTime(2026, 4, 1)),
      AdminOrder(id: 102, title: 'Дипломная по менеджменту', status: 'new', clientName: 'Козлова Н.', price: 20000, deadline: DateTime(2026, 6, 15), createdAt: DateTime(2026, 4, 10)),
      AdminOrder(id: 103, title: 'Контрольная по статистике', status: 'completed', clientName: 'Морозов Д.', expertName: 'Волков А.', price: 2500, deadline: DateTime(2026, 4, 20), createdAt: DateTime(2026, 4, 5)),
      AdminOrder(id: 104, title: 'Реферат по философии', status: 'overdue', clientName: 'Белова Е.', expertName: 'Петрова М.', price: 1200, deadline: DateTime(2026, 4, 10), createdAt: DateTime(2026, 3, 25), isProblem: true, problemType: 'Просрочка дедлайна'),
      AdminOrder(id: 105, title: 'Эссе по корпоративным финансам', status: 'frozen', clientName: 'Иванов И.', price: 3000, deadline: DateTime(2026, 5, 1), createdAt: DateTime(2026, 3, 28), isProblem: true, problemType: 'Заморозка заказа'),
      AdminOrder(id: 106, title: 'Бизнес-план стартапа', status: 'on_review', clientName: 'Новикова О.', expertName: 'Козлова Н.', price: 15000, deadline: DateTime(2026, 5, 20), createdAt: DateTime(2026, 4, 12)),
      AdminOrder(id: 107, title: 'Лабораторная по физике', status: 'in_progress', clientName: 'Морозов Д.', expertName: 'Волков А.', price: 1800, deadline: DateTime(2026, 4, 28), createdAt: DateTime(2026, 4, 15)),
      AdminOrder(id: 108, title: 'Перевод текста 10 стр.', status: 'dispute', clientName: 'Белова Е.', expertName: 'Петрова М.', price: 5000, deadline: DateTime(2026, 4, 22), createdAt: DateTime(2026, 4, 8), isProblem: true, problemType: 'Спор'),
    ];
  }

  void _initTickets() {
    _tickets = [
      SupportTicket(id: 1, title: 'Не могу оплатить заказ', category: 'payment', priority: 'high', status: 'new', authorName: 'Иванов И.', createdAt: DateTime(2026, 4, 24), tags: ['оплата', 'срочно'],
        messages: [TicketMessage(id: 1, senderName: 'Иванов И.', text: 'При попытке оплатить заказ #101 возникает ошибка "Платёж отклонён". Карта рабочая, проверял.', createdAt: DateTime(2026, 4, 24))]),
      SupportTicket(id: 2, title: 'Эксперт не выходит на связь', category: 'expert_complaint', priority: 'medium', status: 'in_progress', authorName: 'Козлова Н.', assigneeName: 'Админ Алексей', createdAt: DateTime(2026, 4, 23), tags: ['эксперт', 'коммуникация'],
        messages: [
          TicketMessage(id: 2, senderName: 'Козлова Н.', text: 'Эксперт Петрова М. не отвечает уже 3 дня по заказу #106.', createdAt: DateTime(2026, 4, 23)),
          TicketMessage(id: 3, senderName: 'Админ Алексей', text: 'Связались с экспертом, ожидаем ответ.', createdAt: DateTime(2026, 4, 23, 15), isAdmin: true),
        ]),
      SupportTicket(id: 3, title: 'Нарушение: обмен контактами в чате', category: 'contact_violation', priority: 'high', status: 'new', authorName: 'Система', createdAt: DateTime(2026, 4, 22), tags: ['контакты', 'нарушение'],
        messages: [TicketMessage(id: 4, senderName: 'Система', text: 'Автоматически обнаружен обмен контактными данными между пользователями Морозов Д. и Волков А.', createdAt: DateTime(2026, 4, 22))]),
      SupportTicket(id: 4, title: 'Просьба вернуть деньги', category: 'refund', priority: 'medium', status: 'new', authorName: 'Белова Е.', createdAt: DateTime(2026, 4, 21), tags: ['возврат'],
        messages: [TicketMessage(id: 5, senderName: 'Белова Е.', text: 'Хочу вернуть деньги за заказ #108. Работа выполнена некачественно.', createdAt: DateTime(2026, 4, 21))]),
      SupportTicket(id: 5, title: 'Ошибка в работе сайта', category: 'technical', priority: 'low', status: 'completed', authorName: 'Морозов Д.', assigneeName: 'Админ Мария', createdAt: DateTime(2026, 4, 18), tags: ['баг'],
        messages: [
          TicketMessage(id: 6, senderName: 'Морозов Д.', text: 'Не загружаются файлы больше 10МБ.', createdAt: DateTime(2026, 4, 18)),
          TicketMessage(id: 7, senderName: 'Админ Мария', text: 'Исправлено, лимит увеличен до 50МБ.', createdAt: DateTime(2026, 4, 19), isAdmin: true),
        ]),
    ];
  }

  void _initArbitrationCases() {
    _arbitrationCases = [
      ArbitrationCase(id: 1, title: 'Некачественное выполнение работы', status: 'in_progress', claimantName: 'Белова Е.', respondentName: 'Петрова М.', orderId: 108, assigneeName: 'Арбитр Сергей', createdAt: DateTime(2026, 4, 22),
        messages: [
          TicketMessage(id: 10, senderName: 'Белова Е.', text: 'Работа не соответствует требованиям. Много ошибок в тексте.', createdAt: DateTime(2026, 4, 22)),
          TicketMessage(id: 11, senderName: 'Петрова М.', text: 'Работа выполнена согласно ТЗ. Готова доработать.', createdAt: DateTime(2026, 4, 22, 14)),
          TicketMessage(id: 12, senderName: 'Арбитр Сергей', text: 'Рассматриваю обе стороны. Жду дополнительные материалы.', createdAt: DateTime(2026, 4, 23), isAdmin: true),
        ]),
      ArbitrationCase(id: 2, title: 'Нарушение сроков выполнения', status: 'new', claimantName: 'Иванов И.', respondentName: 'Козлова Н.', orderId: 104, createdAt: DateTime(2026, 4, 25),
        messages: [TicketMessage(id: 13, senderName: 'Иванов И.', text: 'Эксперт сдал работу с опозданием на 5 дней.', createdAt: DateTime(2026, 4, 25))]),
      ArbitrationCase(id: 3, title: 'Плагиат в выполненной работе', status: 'resolved', claimantName: 'Козлова Н.', respondentName: 'Волков А.', orderId: 103, assigneeName: 'Арбитр Анна', decision: 'Подтверждён плагиат 35%. Полный возврат средств клиенту.', refundAmount: 2500, createdAt: DateTime(2026, 4, 10),
        messages: [
          TicketMessage(id: 14, senderName: 'Козлова Н.', text: 'Обнаружен плагиат в работе. Антиплагиат показывает 35%.', createdAt: DateTime(2026, 4, 10)),
          TicketMessage(id: 15, senderName: 'Арбитр Анна', text: 'Решение: полный возврат средств. Эксперту вынесено предупреждение.', createdAt: DateTime(2026, 4, 15), isAdmin: true),
        ]),
    ];
  }

  void _initChatRooms() {
    _chatRooms = [
      AdminChatRoom(id: 1, name: 'Общий чат сотрудников', isPrivate: false, membersCount: 8, messages: [
        TicketMessage(id: 20, senderName: 'Админ Алексей', text: 'Напоминаю про совещание в 15:00', createdAt: DateTime(2026, 4, 25, 10), isAdmin: true),
        TicketMessage(id: 21, senderName: 'Админ Мария', text: 'Буду!', createdAt: DateTime(2026, 4, 25, 10, 5), isAdmin: true),
      ]),
      AdminChatRoom(id: 2, name: 'Арбитражная группа', isPrivate: false, membersCount: 4, messages: [
        TicketMessage(id: 22, senderName: 'Арбитр Сергей', text: 'Новое дело по заказу #108 требует внимания', createdAt: DateTime(2026, 4, 24), isAdmin: true),
      ]),
      AdminChatRoom(id: 3, name: 'Алексей — Мария', isPrivate: true, membersCount: 2, messages: [
        TicketMessage(id: 23, senderName: 'Админ Алексей', text: 'Посмотри тикет #1, клиент жалуется на оплату', createdAt: DateTime(2026, 4, 25, 9), isAdmin: true),
        TicketMessage(id: 24, senderName: 'Админ Мария', text: 'Да, уже смотрю. Похоже на проблему с банком.', createdAt: DateTime(2026, 4, 25, 9, 10), isAdmin: true),
      ]),
    ];
  }

  void _initCatalog() {
    _catalogItems = [
      CatalogItem(id: 1, name: 'Экономика', type: 'subject', isActive: true),
      CatalogItem(id: 2, name: 'Менеджмент', type: 'subject', isActive: true),
      CatalogItem(id: 3, name: 'Статистика', type: 'subject', isActive: true),
      CatalogItem(id: 4, name: 'Философия', type: 'subject', isActive: true),
      CatalogItem(id: 5, name: 'Курсовая работа', type: 'work_type', isActive: true),
      CatalogItem(id: 6, name: 'Дипломная работа', type: 'work_type', isActive: true),
      CatalogItem(id: 7, name: 'Контрольная работа', type: 'work_type', isActive: true),
      CatalogItem(id: 8, name: 'Реферат', type: 'work_type', isActive: true),
      CatalogItem(id: 9, name: 'Эссе', type: 'work_type', isActive: true),
    ];
  }

  // Partners
  void updatePartner(int id, {double? commissionRate, bool? isActive}) {
    final index = _partners.indexWhere((p) => p.id == id);
    if (index != -1) {
      final old = _partners[index];
      _partners[index] = AdminPartner(
        id: old.id, username: old.username, email: old.email,
        totalReferrals: old.totalReferrals, totalEarnings: old.totalEarnings,
        commissionRate: commissionRate ?? old.commissionRate,
        isActive: isActive ?? old.isActive, joinedAt: old.joinedAt,
      );
      notifyListeners();
    }
  }

  // Earnings
  void markEarningPaid(int id) {
    final index = _earnings.indexWhere((e) => e.id == id);
    if (index != -1) {
      _earnings[index] = _earnings[index].copyWith(isPaid: true);
      notifyListeners();
    }
  }

  // Users
  void blockUser(int id, String reason) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(isBlocked: true, blockReason: reason);
      notifyListeners();
    }
  }

  void unblockUser(int id) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(isBlocked: false, blockReason: '');
      notifyListeners();
    }
  }

  void changeUserRole(int id, String role) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(role: role);
      notifyListeners();
    }
  }

  void banUserForContacts(int id, String reason, {int? days}) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(
        isContactBanned: true,
        contactBanReason: reason,
        contactBanUntil: days != null ? DateTime.now().add(Duration(days: days)) : null,
      );
      notifyListeners();
    }
  }

  void unbanUserForContacts(int id) {
    final index = _users.indexWhere((u) => u.id == id);
    if (index != -1) {
      _users[index] = _users[index].copyWith(isContactBanned: false, contactBanReason: '', contactBanUntil: DateTime(1970));
      notifyListeners();
    }
  }

  // Orders
  void changeOrderStatus(int id, String status) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: status);
      notifyListeners();
    }
  }

  // Tickets
  void takeTicket(int id, String adminName) {
    final index = _tickets.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tickets[index] = _tickets[index].copyWith(status: 'in_progress', assigneeName: adminName);
      notifyListeners();
    }
  }

  void completeTicket(int id) {
    final index = _tickets.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tickets[index] = _tickets[index].copyWith(status: 'completed');
      notifyListeners();
    }
  }

  void updateTicketTags(int id, List<String> tags) {
    final index = _tickets.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tickets[index] = _tickets[index].copyWith(tags: tags);
      notifyListeners();
    }
  }

  // Arbitration
  void takeArbitrationCase(int id, String adminName) {
    final index = _arbitrationCases.indexWhere((c) => c.id == id);
    if (index != -1) {
      _arbitrationCases[index] = _arbitrationCases[index].copyWith(status: 'in_progress', assigneeName: adminName);
      notifyListeners();
    }
  }

  void resolveArbitrationCase(int id, String decision, {double? refundAmount}) {
    final index = _arbitrationCases.indexWhere((c) => c.id == id);
    if (index != -1) {
      _arbitrationCases[index] = _arbitrationCases[index].copyWith(status: 'resolved', decision: decision, refundAmount: refundAmount);
      notifyListeners();
    }
  }

  void closeArbitrationCase(int id) {
    final index = _arbitrationCases.indexWhere((c) => c.id == id);
    if (index != -1) {
      _arbitrationCases[index] = _arbitrationCases[index].copyWith(status: 'closed');
      notifyListeners();
    }
  }
}
