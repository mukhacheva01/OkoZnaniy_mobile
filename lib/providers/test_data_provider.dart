import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/order.dart';
import 'package:oko_znaniy_mobile/models/chat_message.dart';
import 'package:oko_znaniy_mobile/models/notification.dart';

class Review {
  final int id;
  final int orderId;
  final int expertId;
  final String expertName;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.orderId,
    required this.expertId,
    required this.expertName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}

class Transaction {
  final int id;
  final String type;
  final double amount;
  final String description;
  final DateTime createdAt;
  final int? orderId;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.createdAt,
    this.orderId,
  });

  String get typeLabel {
    const labels = {
      'freeze': 'Заморозка средств',
      'unfreeze': 'Разморозка',
      'payment': 'Выплата',
      'commission': 'Комиссия',
      'refund': 'Возврат',
      'deposit': 'Пополнение',
      'withdrawal': 'Вывод средств',
    };
    return labels[type] ?? type;
  }
}

class Friend {
  final int id;
  final String name;
  final String? avatar;
  final String role;
  final bool isOnline;

  Friend({
    required this.id,
    required this.name,
    this.avatar,
    required this.role,
    this.isOnline = false,
  });
}

class ExpertProfile {
  final int id;
  final String name;
  final String? avatar;
  final double rating;
  final int completedOrders;
  final List<String> specializations;
  final String description;
  final DateTime joinedAt;

  ExpertProfile({
    required this.id,
    required this.name,
    this.avatar,
    required this.rating,
    required this.completedOrders,
    required this.specializations,
    required this.description,
    required this.joinedAt,
  });
}

class Bid {
  final int id;
  final int orderId;
  final int expertId;
  final String expertName;
  final double expertRating;
  final int expertCompletedOrders;
  final double price;
  final int days;
  final String comment;
  final DateTime createdAt;

  Bid({
    required this.id,
    required this.orderId,
    required this.expertId,
    required this.expertName,
    required this.expertRating,
    required this.expertCompletedOrders,
    required this.price,
    required this.days,
    required this.comment,
    required this.createdAt,
  });
}

class OrderFile {
  final int id;
  final String name;
  final String type;
  final int size;
  final DateTime uploadedAt;

  OrderFile({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.uploadedAt,
  });

  String get sizeLabel {
    if (size < 1024) return '$size Б';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} КБ';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} МБ';
  }
}

class Complaint {
  final int id;
  final int orderId;
  final String orderTitle;
  final String reason;
  final String description;
  final String status;
  final String? resolution;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.orderId,
    required this.orderTitle,
    required this.reason,
    required this.description,
    required this.status,
    this.resolution,
    required this.createdAt,
  });

  String get statusLabel {
    const labels = {
      'open': 'Открыта',
      'in_review': 'На рассмотрении',
      'resolved': 'Решена',
      'closed': 'Закрыта',
    };
    return labels[status] ?? status;
  }
}

class TestDataProvider extends ChangeNotifier {
  List<Order> _orders = [];
  List<ChatRoom> _chatRooms = [];
  List<ChatMessage> _messages = [];
  List<AppNotification> _notifications = [];
  List<Review> _reviews = [];
  List<Transaction> _transactions = [];
  List<Friend> _friends = [];
  List<ExpertProfile> _experts = [];
  List<Bid> _bids = [];
  List<OrderFile> _files = [];
  List<Complaint> _complaints = [];

  List<Order> get orders => _orders;
  List<ChatRoom> get chatRooms => _chatRooms;
  List<ChatMessage> get messages => _messages;
  List<AppNotification> get notifications => _notifications;
  List<Review> get reviews => _reviews;
  List<Transaction> get transactions => _transactions;
  List<Friend> get friends => _friends;
  List<ExpertProfile> get experts => _experts;
  List<Bid> get bids => _bids;
  List<OrderFile> get files => _files;
  List<Complaint> get complaints => _complaints;

  void initTestData() {
    _initOrders();
    _initChatRooms();
    _initNotifications();
    _initReviews();
    _initTransactions();
    _initFriends();
    _initExperts();
    _initBids();
    _initFiles();
    _initComplaints();
    notifyListeners();
  }

  void _initOrders() {
    final now = DateTime.now();
    _orders = [
      Order(
        id: 1,
        title: 'Курсовая по экономике предприятия',
        description: 'Необходимо написать курсовую работу по теме "Анализ финансовой деятельности предприятия". Объем 30-35 страниц, оформление по ГОСТ.',
        workType: 'Курсовая работа',
        subject: 'Экономика предприятия',
        status: 'in_progress',
        price: 3500,
        deadline: now.add(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 3)),
        clientId: 0,
        clientName: 'Иван Иванов',
        expertId: 101,
        expertName: 'Мария Сидорова',
        filesCount: 2,
        commentsCount: 5,
        bidsCount: 3,
      ),
      Order(
        id: 2,
        title: 'Реферат по истории России',
        description: 'Реферат на тему "Реформы Петра I и их влияние на развитие России". 15-20 страниц.',
        workType: 'Реферат',
        subject: 'История России',
        status: 'new',
        budget: 1500,
        deadline: now.add(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(hours: 6)),
        clientId: 0,
        clientName: 'Иван Иванов',
        bidsCount: 2,
      ),
      Order(
        id: 3,
        title: 'Лабораторная работа по физике',
        description: 'Выполнить лабораторную работу №5 "Изучение электрических цепей постоянного тока". Оформить отчёт.',
        workType: 'Лабораторная работа',
        subject: 'Физика',
        status: 'completed',
        price: 1200,
        deadline: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 10)),
        clientId: 0,
        clientName: 'Иван Иванов',
        expertId: 102,
        expertName: 'Алексей Козлов',
        filesCount: 3,
        commentsCount: 8,
      ),
      Order(
        id: 4,
        title: 'Дипломная работа по менеджменту',
        description: 'Дипломная работа на тему "Совершенствование системы управления персоналом на предприятии". 60-70 страниц + презентация.',
        workType: 'Дипломная работа',
        subject: 'Менеджмент',
        status: 'review',
        price: 12000,
        deadline: now.add(const Duration(days: 14)),
        createdAt: now.subtract(const Duration(days: 20)),
        clientId: 0,
        clientName: 'Иван Иванов',
        expertId: 103,
        expertName: 'Елена Новикова',
        filesCount: 5,
        commentsCount: 12,
      ),
      Order(
        id: 5,
        title: 'Контрольная по математике',
        description: 'Решить 10 задач по высшей математике (интегралы, дифференциальные уравнения).',
        workType: 'Контрольная работа',
        subject: 'Высшая математика',
        status: 'waiting_payment',
        price: 2000,
        deadline: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 5)),
        clientId: 0,
        clientName: 'Иван Иванов',
        expertId: 104,
        expertName: 'Дмитрий Волков',
      ),
      Order(
        id: 6,
        title: 'Эссе по философии',
        description: 'Написать эссе на тему "Смысл жизни в философии экзистенциализма". 5-7 страниц.',
        workType: 'Эссе',
        subject: 'Философия',
        status: 'revision',
        price: 800,
        deadline: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 7)),
        clientId: 0,
        clientName: 'Иван Иванов',
        expertId: 105,
        expertName: 'Ольга Белова',
        filesCount: 1,
        commentsCount: 3,
      ),
      Order(
        id: 7,
        title: 'Отчёт по практике',
        description: 'Отчёт по производственной практике в ООО "Технология". 25-30 страниц + дневник практики.',
        workType: 'Отчет по практике',
        subject: 'Информатика',
        status: 'closed',
        price: 2500,
        deadline: now.subtract(const Duration(days: 15)),
        createdAt: now.subtract(const Duration(days: 30)),
        clientId: 0,
        clientName: 'Иван Иванов',
        expertId: 101,
        expertName: 'Мария Сидорова',
        filesCount: 4,
        commentsCount: 6,
      ),
      Order(
        id: 8,
        title: 'Презентация по маркетингу',
        description: 'Подготовить презентацию на 20 слайдов по теме "Digital-маркетинг в B2B сегменте".',
        workType: 'Другое',
        subject: 'Маркетинг',
        status: 'confirming',
        price: 1800,
        deadline: now.add(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 1)),
        clientId: 0,
        clientName: 'Иван Иванов',
        expertId: 106,
        expertName: 'Наталья Морозова',
        bidsCount: 1,
      ),
    ];
  }

  void _initChatRooms() {
    _chatRooms = [
      ChatRoom(
        id: 1,
        title: 'Курсовая по экономике',
        orderId: 1,
        lastMessage: 'Добрый день! Начала работу над вашей курсовой.',
        lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 2,
        participants: [
          ChatParticipant(userId: 101, username: 'Мария Сидорова'),
        ],
      ),
      ChatRoom(
        id: 2,
        title: 'Дипломная по менеджменту',
        orderId: 4,
        lastMessage: 'Загрузила первую главу, проверьте пожалуйста.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 1,
        participants: [
          ChatParticipant(userId: 103, username: 'Елена Новикова'),
        ],
      ),
      ChatRoom(
        id: 3,
        title: 'Эссе по философии',
        orderId: 6,
        lastMessage: 'Внесла правки, посмотрите новую версию.',
        lastMessageAt: DateTime.now().subtract(const Duration(hours: 5)),
        unreadCount: 0,
        participants: [
          ChatParticipant(userId: 105, username: 'Ольга Белова'),
        ],
      ),
    ];
    _messages = [
      ChatMessage(
        id: 1,
        roomId: 1,
        senderId: 101,
        senderName: 'Мария Сидорова',
        content: 'Добрый день! Приступила к работе над вашей курсовой по экономике предприятия.',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      ChatMessage(
        id: 2,
        roomId: 1,
        senderId: 0,
        senderName: 'Иван Иванов',
        content: 'Здравствуйте! Отлично, жду результат. Не забудьте про оформление по ГОСТ.',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessage(
        id: 3,
        roomId: 1,
        senderId: 101,
        senderName: 'Мария Сидорова',
        content: 'Да, конечно. Первую главу планирую отправить завтра на проверку.',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      ChatMessage(
        id: 4,
        roomId: 1,
        senderId: 101,
        senderName: 'Мария Сидорова',
        content: 'Добрый день! Начала работу над вашей курсовой.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
    ];
  }

  void _initNotifications() {
    final now = DateTime.now();
    _notifications = [
      AppNotification(
        id: 1,
        title: 'Новая ставка',
        message: 'Эксперт Мария Сидорова сделала ставку на ваш заказ "Реферат по истории России" — 1200₽',
        type: 'order',
        isRead: false,
        createdAt: now.subtract(const Duration(minutes: 15)),
      ),
      AppNotification(
        id: 2,
        title: 'Работа на проверке',
        message: 'Эксперт Елена Новикова загрузила решение по заказу "Дипломная работа по менеджменту"',
        type: 'order',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: 3,
        title: 'Новое сообщение',
        message: 'Мария Сидорова: "Начала работу над вашей курсовой"',
        type: 'chat',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      AppNotification(
        id: 4,
        title: 'Заказ завершён',
        message: 'Лабораторная работа по физике успешно завершена',
        type: 'order',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: 5,
        title: 'Пополнение баланса',
        message: 'Ваш баланс пополнен на 5000₽',
        type: 'payment',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      AppNotification(
        id: 6,
        title: 'Просрочка дедлайна',
        message: 'Дедлайн по заказу "Контрольная по математике" скоро истекает',
        type: 'order',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  void _initReviews() {
    _reviews = [
      Review(
        id: 1,
        orderId: 3,
        expertId: 102,
        expertName: 'Алексей Козлов',
        rating: 5,
        comment: 'Отличная работа! Всё сделано качественно и в срок. Рекомендую.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Review(
        id: 2,
        orderId: 7,
        expertId: 101,
        expertName: 'Мария Сидорова',
        rating: 4,
        comment: 'Хорошая работа, но были небольшие замечания по оформлению.',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  void _initTransactions() {
    final now = DateTime.now();
    _transactions = [
      Transaction(id: 1, type: 'deposit', amount: 5000, description: 'Пополнение баланса', createdAt: now.subtract(const Duration(days: 2))),
      Transaction(id: 2, type: 'freeze', amount: -3500, description: 'Заморозка за заказ #1', createdAt: now.subtract(const Duration(days: 3)), orderId: 1),
      Transaction(id: 3, type: 'payment', amount: -1200, description: 'Оплата заказа #3', createdAt: now.subtract(const Duration(days: 10)), orderId: 3),
      Transaction(id: 4, type: 'commission', amount: -120, description: 'Комиссия сервиса 10%', createdAt: now.subtract(const Duration(days: 10)), orderId: 3),
      Transaction(id: 5, type: 'deposit', amount: 10000, description: 'Пополнение баланса', createdAt: now.subtract(const Duration(days: 15))),
      Transaction(id: 6, type: 'freeze', amount: -12000, description: 'Заморозка за заказ #4', createdAt: now.subtract(const Duration(days: 20)), orderId: 4),
      Transaction(id: 7, type: 'payment', amount: -2500, description: 'Оплата заказа #7', createdAt: now.subtract(const Duration(days: 30)), orderId: 7),
      Transaction(id: 8, type: 'refund', amount: 500, description: 'Возврат за отмену', createdAt: now.subtract(const Duration(days: 35))),
    ];
  }

  void _initFriends() {
    _friends = [
      Friend(id: 101, name: 'Мария Сидорова', role: 'expert', isOnline: true),
      Friend(id: 102, name: 'Алексей Козлов', role: 'expert', isOnline: false),
      Friend(id: 107, name: 'Анна Кузнецова', role: 'client', isOnline: true),
      Friend(id: 108, name: 'Сергей Попов', role: 'client', isOnline: false),
    ];
  }

  void _initExperts() {
    _experts = [
      ExpertProfile(
        id: 101,
        name: 'Мария Сидорова',
        rating: 4.9,
        completedOrders: 234,
        specializations: ['Экономика', 'Менеджмент', 'Бухгалтерский учёт'],
        description: 'Кандидат экономических наук, преподаватель вуза с 10-летним стажем.',
        joinedAt: DateTime(2022, 3, 15),
      ),
      ExpertProfile(
        id: 102,
        name: 'Алексей Козлов',
        rating: 4.7,
        completedOrders: 178,
        specializations: ['Физика', 'Математика', 'Инженерия'],
        description: 'Инженер-физик, аспирант технического университета.',
        joinedAt: DateTime(2022, 8, 1),
      ),
      ExpertProfile(
        id: 103,
        name: 'Елена Новикова',
        rating: 4.8,
        completedOrders: 312,
        specializations: ['Менеджмент', 'Маркетинг', 'Экономика'],
        description: 'MBA, управляющий партнёр консалтинговой компании.',
        joinedAt: DateTime(2021, 11, 20),
      ),
      ExpertProfile(
        id: 104,
        name: 'Дмитрий Волков',
        rating: 4.6,
        completedOrders: 145,
        specializations: ['Математика', 'Программирование', 'Статистика'],
        description: 'Разработчик, преподаватель математики в колледже.',
        joinedAt: DateTime(2023, 1, 10),
      ),
      ExpertProfile(
        id: 105,
        name: 'Ольга Белова',
        rating: 4.9,
        completedOrders: 267,
        specializations: ['Философия', 'Психология', 'Социология'],
        description: 'Кандидат философских наук, доцент кафедры гуманитарных наук.',
        joinedAt: DateTime(2022, 5, 8),
      ),
      ExpertProfile(
        id: 106,
        name: 'Наталья Морозова',
        rating: 4.5,
        completedOrders: 89,
        specializations: ['Маркетинг', 'Реклама', 'PR'],
        description: 'Директор по маркетингу в IT-компании.',
        joinedAt: DateTime(2023, 6, 1),
      ),
    ];
  }

  void _initBids() {
    final now = DateTime.now();
    _bids = [
      Bid(id: 1, orderId: 2, expertId: 101, expertName: 'Мария Сидорова', expertRating: 4.9, expertCompletedOrders: 234, price: 1200, days: 7, comment: 'Готова выполнить работу качественно и в срок.', createdAt: now.subtract(const Duration(minutes: 15))),
      Bid(id: 2, orderId: 2, expertId: 105, expertName: 'Ольга Белова', expertRating: 4.9, expertCompletedOrders: 267, price: 1400, days: 5, comment: 'Специализируюсь на гуманитарных науках, сделаю отлично.', createdAt: now.subtract(const Duration(hours: 2))),
      Bid(id: 3, orderId: 1, expertId: 101, expertName: 'Мария Сидорова', expertRating: 4.9, expertCompletedOrders: 234, price: 3500, days: 5, comment: 'Приступлю сразу, оформлю по ГОСТ.', createdAt: now.subtract(const Duration(days: 3))),
    ];
  }

  void _initFiles() {
    _files = [
      OrderFile(id: 1, name: 'Задание_курсовая.docx', type: 'task', size: 245760, uploadedAt: DateTime.now().subtract(const Duration(days: 3))),
      OrderFile(id: 2, name: 'Методичка.pdf', type: 'task', size: 1572864, uploadedAt: DateTime.now().subtract(const Duration(days: 3))),
      OrderFile(id: 3, name: 'Лаба_5_отчёт.pdf', type: 'solution', size: 524288, uploadedAt: DateTime.now().subtract(const Duration(days: 2))),
      OrderFile(id: 4, name: 'Диплом_глава1.docx', type: 'solution', size: 368640, uploadedAt: DateTime.now().subtract(const Duration(hours: 4))),
      OrderFile(id: 5, name: 'Эссе_v2.docx', type: 'revision', size: 163840, uploadedAt: DateTime.now().subtract(const Duration(hours: 6))),
    ];
  }

  void _initComplaints() {
    _complaints = [
      Complaint(
        id: 1,
        orderId: 6,
        orderTitle: 'Эссе по философии',
        reason: 'Некачественная работа',
        description: 'Работа не соответствует требованиям, много ошибок.',
        status: 'in_review',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  // Orders
  List<Order> getOrdersByStatus(String? status) {
    if (status == null || status == 'all') return _orders;
    return _orders.where((o) => o.status == status).toList();
  }

  Order? getOrderById(int id) {
    try {
      return _orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void updateOrderStatus(int id, String status) {
    final index = _orders.indexWhere((o) => o.id == id);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = Order(
        id: old.id,
        title: old.title,
        description: old.description,
        workType: old.workType,
        subject: old.subject,
        status: status,
        price: old.price,
        budget: old.budget,
        deadline: old.deadline,
        createdAt: old.createdAt,
        clientId: old.clientId,
        clientName: old.clientName,
        expertId: old.expertId,
        expertName: old.expertName,
        filesCount: old.filesCount,
        commentsCount: old.commentsCount,
        bidsCount: old.bidsCount,
      );
      notifyListeners();
    }
  }

  void deleteOrder(int id) {
    _orders.removeWhere((o) => o.id == id);
    notifyListeners();
  }

  // Bids
  List<Bid> getBidsForOrder(int orderId) {
    return _bids.where((b) => b.orderId == orderId).toList();
  }

  void acceptBid(Bid bid) {
    updateOrderStatus(bid.orderId, 'in_progress');
    final index = _orders.indexWhere((o) => o.id == bid.orderId);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = Order(
        id: old.id,
        title: old.title,
        description: old.description,
        workType: old.workType,
        subject: old.subject,
        status: 'in_progress',
        price: bid.price,
        deadline: old.deadline,
        createdAt: old.createdAt,
        clientId: old.clientId,
        clientName: old.clientName,
        expertId: bid.expertId,
        expertName: bid.expertName,
        filesCount: old.filesCount,
        commentsCount: old.commentsCount,
        bidsCount: old.bidsCount,
      );
    }
    _bids.removeWhere((b) => b.orderId == bid.orderId && b.id != bid.id);
    notifyListeners();
  }

  // Files
  List<OrderFile> getFilesForOrder(int orderId) {
    return _files;
  }

  // Chat messages for a room
  List<ChatMessage> getMessagesForRoom(int roomId) {
    return _messages.where((m) => m.roomId == roomId).toList();
  }

  void addMessage(ChatMessage message) {
    _messages.add(message);
    final roomIndex = _chatRooms.indexWhere((r) => r.id == message.roomId);
    if (roomIndex != -1) {
      final old = _chatRooms[roomIndex];
      _chatRooms[roomIndex] = ChatRoom(
        id: old.id,
        title: old.title,
        orderId: old.orderId,
        lastMessage: message.content,
        lastMessageAt: message.createdAt,
        unreadCount: old.unreadCount,
        participants: old.participants,
      );
    }
    notifyListeners();
  }

  // Reviews
  void addReview(Review review) {
    _reviews.insert(0, review);
    notifyListeners();
  }

  void updateReview(int id, int rating, String comment) {
    final index = _reviews.indexWhere((r) => r.id == id);
    if (index != -1) {
      final old = _reviews[index];
      _reviews[index] = Review(
        id: old.id,
        orderId: old.orderId,
        expertId: old.expertId,
        expertName: old.expertName,
        rating: rating,
        comment: comment,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  void deleteReview(int id) {
    _reviews.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  // Friends
  void addFriend(Friend friend) {
    _friends.add(friend);
    notifyListeners();
  }

  void removeFriend(int id) {
    _friends.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  // Transactions
  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  // Complaints
  void addComplaint(Complaint complaint) {
    _complaints.insert(0, complaint);
    notifyListeners();
  }

  // Notifications
  void markNotificationRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = _notifications[index];
      _notifications[index] = AppNotification(
        id: old.id,
        title: old.title,
        message: old.message,
        type: old.type,
        isRead: true,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }
}
