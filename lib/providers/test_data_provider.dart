import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/order.dart';
import 'package:oko_znaniy_mobile/models/chat_message.dart';
import 'package:oko_znaniy_mobile/models/notification.dart';

class Review {
  final int id;
  final int orderId;
  final int expertId;
  final String expertName;
  final String? clientName;
  final int rating;
  final String comment;
  final String? expertReply;
  final String? appealReason;
  final String? appealStatus; // null, 'pending', 'approved', 'rejected'
  final DateTime createdAt;

  Review({
    required this.id,
    required this.orderId,
    required this.expertId,
    required this.expertName,
    this.clientName,
    required this.rating,
    required this.comment,
    this.expertReply,
    this.appealReason,
    this.appealStatus,
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
      'earning': 'Заработок',
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
  final int prepayPercent;
  final String comment;
  final String status; // 'pending', 'accepted', 'rejected', 'cancelled'
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
    this.prepayPercent = 0,
    required this.comment,
    this.status = 'pending',
    required this.createdAt,
  });
}

class OrderFile {
  final int id;
  final int orderId;
  final String name;
  final String type; // 'task', 'solution', 'revision'
  final int size;
  final DateTime uploadedAt;

  OrderFile({
    required this.id,
    required this.orderId,
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
  final String? expertResponse;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.orderId,
    required this.orderTitle,
    required this.reason,
    required this.description,
    required this.status,
    this.resolution,
    this.expertResponse,
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

class Specialization {
  final int id;
  final String name;
  final String subject;
  final int experienceYears;
  final double hourlyRate;
  final String description;
  final List<String> skills;
  final String verificationStatus; // 'pending', 'verified', 'rejected'

  Specialization({
    required this.id,
    required this.name,
    required this.subject,
    required this.experienceYears,
    required this.hourlyRate,
    required this.description,
    required this.skills,
    this.verificationStatus = 'pending',
  });

  String get statusLabel {
    const labels = {
      'pending': 'На проверке',
      'verified': 'Подтверждена',
      'rejected': 'Отклонена',
    };
    return labels[verificationStatus] ?? verificationStatus;
  }
}

class ExpertApplication {
  final int id;
  final String fullName;
  final int experienceYears;
  final List<String> subjects;
  final String university;
  final String graduationYears;
  final String degree;
  final String status; // 'pending', 'approved', 'rejected', 'revision', 'deactivated'
  final String? rejectionReason;
  final DateTime createdAt;

  ExpertApplication({
    required this.id,
    required this.fullName,
    required this.experienceYears,
    required this.subjects,
    required this.university,
    required this.graduationYears,
    required this.degree,
    this.status = 'pending',
    this.rejectionReason,
    required this.createdAt,
  });

  String get statusLabel {
    const labels = {
      'pending': 'На рассмотрении',
      'approved': 'Одобрена',
      'rejected': 'Отклонена',
      'revision': 'На доработке',
      'deactivated': 'Деактивирована',
    };
    return labels[status] ?? status;
  }
}

class ExpertDocument {
  final int id;
  final String name;
  final String type; // 'diploma', 'certificate', 'award', 'other'
  final String fileName;
  final int fileSize;
  final String verificationStatus; // 'pending', 'verified', 'rejected'
  final DateTime uploadedAt;

  ExpertDocument({
    required this.id,
    required this.name,
    required this.type,
    required this.fileName,
    required this.fileSize,
    this.verificationStatus = 'pending',
    required this.uploadedAt,
  });

  String get typeLabel {
    const labels = {
      'diploma': 'Диплом',
      'certificate': 'Сертификат',
      'award': 'Награда',
      'other': 'Другое',
    };
    return labels[type] ?? type;
  }

  String get statusLabel {
    const labels = {
      'pending': 'На проверке',
      'verified': 'Подтверждён',
      'rejected': 'Отклонён',
    };
    return labels[verificationStatus] ?? verificationStatus;
  }

  String get sizeLabel {
    if (fileSize < 1024) return '$fileSize Б';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} КБ';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} МБ';
  }
}

class ShopWork {
  final int id;
  final String title;
  final String description;
  final String subject;
  final String workType;
  final double price;
  final int salesCount;
  final DateTime createdAt;

  ShopWork({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.workType,
    required this.price,
    this.salesCount = 0,
    required this.createdAt,
  });
}

class TestDataProvider extends ChangeNotifier {
  List<Order> _orders = [];
  List<Order> _expertOrders = []; // orders where expert is assigned
  List<Order> _availableOrders = []; // orders feed for expert
  List<ChatRoom> _chatRooms = [];
  List<ChatMessage> _messages = [];
  List<AppNotification> _notifications = [];
  List<Review> _reviews = [];
  List<Review> _expertReviews = []; // reviews FROM clients ABOUT expert
  List<Transaction> _transactions = [];
  List<Transaction> _expertTransactions = [];
  List<Friend> _friends = [];
  List<ExpertProfile> _experts = [];
  List<Bid> _bids = [];
  List<Bid> _expertBids = []; // bids placed BY expert
  List<OrderFile> _files = [];
  List<Complaint> _complaints = [];
  List<Specialization> _specializations = [];
  ExpertApplication? _expertApplication;
  List<ExpertDocument> _documents = [];
  List<ShopWork> _shopWorks = []; // expert's works for sale

  List<Order> get orders => _orders;
  List<Order> get expertOrders => _expertOrders;
  List<Order> get availableOrders => _availableOrders;
  List<ChatRoom> get chatRooms => _chatRooms;
  List<ChatMessage> get messages => _messages;
  List<AppNotification> get notifications => _notifications;
  List<Review> get reviews => _reviews;
  List<Review> get expertReviews => _expertReviews;
  List<Transaction> get transactions => _transactions;
  List<Transaction> get expertTransactions => _expertTransactions;
  List<Friend> get friends => _friends;
  List<ExpertProfile> get experts => _experts;
  List<Bid> get bids => _bids;
  List<Bid> get expertBids => _expertBids;
  List<OrderFile> get files => _files;
  List<Complaint> get complaints => _complaints;
  List<Specialization> get specializations => _specializations;
  ExpertApplication? get expertApplication => _expertApplication;
  List<ExpertDocument> get documents => _documents;
  List<ShopWork> get shopWorks => _shopWorks;

  void initTestData() {
    _initOrders();
    _initExpertOrders();
    _initAvailableOrders();
    _initChatRooms();
    _initNotifications();
    _initReviews();
    _initExpertReviews();
    _initTransactions();
    _initExpertTransactions();
    _initFriends();
    _initExperts();
    _initBids();
    _initExpertBids();
    _initFiles();
    _initComplaints();
    _initSpecializations();
    _initExpertApplication();
    _initDocuments();
    _initShopWorks();
    notifyListeners();
  }

  void _initOrders() {
    final now = DateTime.now();
    _orders = [
      Order(id: 1, title: 'Курсовая по экономике предприятия', description: 'Необходимо написать курсовую работу по теме "Анализ финансовой деятельности предприятия". Объем 30-35 страниц, оформление по ГОСТ.', workType: 'Курсовая работа', subject: 'Экономика предприятия', status: 'in_progress', price: 3500, deadline: now.add(const Duration(days: 5)), createdAt: now.subtract(const Duration(days: 3)), clientId: 0, clientName: 'Иван Иванов', expertId: 101, expertName: 'Мария Сидорова', filesCount: 2, commentsCount: 5, bidsCount: 3),
      Order(id: 2, title: 'Реферат по истории России', description: 'Реферат на тему "Реформы Петра I и их влияние на развитие России". 15-20 страниц.', workType: 'Реферат', subject: 'История России', status: 'new', budget: 1500, deadline: now.add(const Duration(days: 10)), createdAt: now.subtract(const Duration(hours: 6)), clientId: 0, clientName: 'Иван Иванов', bidsCount: 2),
      Order(id: 3, title: 'Лабораторная работа по физике', description: 'Выполнить лабораторную работу №5 "Изучение электрических цепей постоянного тока". Оформить отчёт.', workType: 'Лабораторная работа', subject: 'Физика', status: 'completed', price: 1200, deadline: now.subtract(const Duration(days: 1)), createdAt: now.subtract(const Duration(days: 10)), clientId: 0, clientName: 'Иван Иванов', expertId: 102, expertName: 'Алексей Козлов', filesCount: 3, commentsCount: 8),
      Order(id: 4, title: 'Дипломная работа по менеджменту', description: 'Дипломная работа на тему "Совершенствование системы управления персоналом на предприятии". 60-70 страниц + презентация.', workType: 'Дипломная работа', subject: 'Менеджмент', status: 'review', price: 12000, deadline: now.add(const Duration(days: 14)), createdAt: now.subtract(const Duration(days: 20)), clientId: 0, clientName: 'Иван Иванов', expertId: 103, expertName: 'Елена Новикова', filesCount: 5, commentsCount: 12),
      Order(id: 5, title: 'Контрольная по математике', description: 'Решить 10 задач по высшей математике (интегралы, дифференциальные уравнения).', workType: 'Контрольная работа', subject: 'Высшая математика', status: 'waiting_payment', price: 2000, deadline: now.add(const Duration(days: 2)), createdAt: now.subtract(const Duration(days: 5)), clientId: 0, clientName: 'Иван Иванов', expertId: 104, expertName: 'Дмитрий Волков'),
      Order(id: 6, title: 'Эссе по философии', description: 'Написать эссе на тему "Смысл жизни в философии экзистенциализма". 5-7 страниц.', workType: 'Эссе', subject: 'Философия', status: 'revision', price: 800, deadline: now.add(const Duration(days: 3)), createdAt: now.subtract(const Duration(days: 7)), clientId: 0, clientName: 'Иван Иванов', expertId: 105, expertName: 'Ольга Белова', filesCount: 1, commentsCount: 3),
      Order(id: 7, title: 'Отчёт по практике', description: 'Отчёт по производственной практике в ООО "Технология". 25-30 страниц + дневник практики.', workType: 'Отчет по практике', subject: 'Информатика', status: 'closed', price: 2500, deadline: now.subtract(const Duration(days: 15)), createdAt: now.subtract(const Duration(days: 30)), clientId: 0, clientName: 'Иван Иванов', expertId: 101, expertName: 'Мария Сидорова', filesCount: 4, commentsCount: 6),
      Order(id: 8, title: 'Презентация по маркетингу', description: 'Подготовить презентацию на 20 слайдов по теме "Digital-маркетинг в B2B сегменте".', workType: 'Другое', subject: 'Маркетинг', status: 'confirming', price: 1800, deadline: now.add(const Duration(days: 7)), createdAt: now.subtract(const Duration(days: 1)), clientId: 0, clientName: 'Иван Иванов', expertId: 106, expertName: 'Наталья Морозова', bidsCount: 1),
    ];
  }

  void _initExpertOrders() {
    final now = DateTime.now();
    _expertOrders = [
      Order(id: 101, title: 'Анализ финансовых показателей ООО "Рост"', description: 'Провести комплексный анализ финансовых показателей предприятия за 3 года.', workType: 'Курсовая работа', subject: 'Экономика', status: 'in_progress', price: 4500, deadline: now.add(const Duration(days: 7)), createdAt: now.subtract(const Duration(days: 5)), clientId: 201, clientName: 'Анна Кузнецова', expertId: 0, expertName: 'Алексей Петров', filesCount: 2, commentsCount: 3),
      Order(id: 102, title: 'Бизнес-план стартапа', description: 'Разработать полный бизнес-план для IT-стартапа. 40+ страниц.', workType: 'Дипломная работа', subject: 'Менеджмент', status: 'review', price: 15000, deadline: now.add(const Duration(days: 3)), createdAt: now.subtract(const Duration(days: 14)), clientId: 202, clientName: 'Сергей Попов', expertId: 0, expertName: 'Алексей Петров', filesCount: 4, commentsCount: 8),
      Order(id: 103, title: 'Контрольная по статистике', description: 'Решить 15 задач по математической статистике.', workType: 'Контрольная работа', subject: 'Статистика', status: 'completed', price: 2500, deadline: now.subtract(const Duration(days: 3)), createdAt: now.subtract(const Duration(days: 12)), clientId: 203, clientName: 'Мария Иванова', expertId: 0, expertName: 'Алексей Петров', filesCount: 2, commentsCount: 5),
      Order(id: 104, title: 'Отчёт по бухгалтерскому учёту', description: 'Составить бухгалтерскую отчётность и пояснительную записку.', workType: 'Отчет по практике', subject: 'Бухгалтерский учёт', status: 'revision', price: 3000, deadline: now.add(const Duration(days: 2)), createdAt: now.subtract(const Duration(days: 8)), clientId: 204, clientName: 'Елена Смирнова', expertId: 0, expertName: 'Алексей Петров', filesCount: 3, commentsCount: 4),
      Order(id: 105, title: 'Реферат по финансовому менеджменту', description: 'Реферат на тему "Управление оборотным капиталом". 20 страниц.', workType: 'Реферат', subject: 'Финансовый менеджмент', status: 'confirming', price: 1500, deadline: now.add(const Duration(days: 5)), createdAt: now.subtract(const Duration(days: 2)), clientId: 205, clientName: 'Дмитрий Козлов', expertId: 0, expertName: 'Алексей Петров'),
    ];
  }

  void _initAvailableOrders() {
    final now = DateTime.now();
    _availableOrders = [
      Order(id: 201, title: 'Курсовая по микроэкономике', description: 'Курсовая на тему "Рыночные структуры и ценообразование". 25-30 страниц.', workType: 'Курсовая работа', subject: 'Экономика', status: 'new', budget: 3000, deadline: now.add(const Duration(days: 12)), createdAt: now.subtract(const Duration(hours: 2)), clientId: 210, clientName: 'Ольга Петрова', bidsCount: 1),
      Order(id: 202, title: 'Расчёт себестоимости продукции', description: 'Рассчитать себестоимость продукции и составить калькуляцию.', workType: 'Контрольная работа', subject: 'Бухгалтерский учёт', status: 'new', budget: 2000, deadline: now.add(const Duration(days: 5)), createdAt: now.subtract(const Duration(hours: 8)), clientId: 211, clientName: 'Виктор Соколов', bidsCount: 0),
      Order(id: 203, title: 'Дипломная по управлению проектами', description: 'Дипломная работа + презентация + речь. Тема: "Управление проектами в IT-сфере".', workType: 'Дипломная работа', subject: 'Менеджмент', status: 'new', budget: 20000, deadline: now.add(const Duration(days: 30)), createdAt: now.subtract(const Duration(days: 1)), clientId: 212, clientName: 'Наталья Волкова', bidsCount: 3),
      Order(id: 204, title: 'Решение задач по эконометрике', description: '10 задач по эконометрике с подробным решением в SPSS.', workType: 'Контрольная работа', subject: 'Статистика', status: 'new', budget: 2500, deadline: now.add(const Duration(days: 4)), createdAt: now.subtract(const Duration(hours: 12)), clientId: 213, clientName: 'Алексей Морозов', bidsCount: 2),
      Order(id: 205, title: 'Эссе по корпоративным финансам', description: 'Эссе на тему "Дивидендная политика компаний". 8-10 страниц.', workType: 'Эссе', subject: 'Финансовый менеджмент', status: 'new', budget: 1000, deadline: now.add(const Duration(days: 6)), createdAt: now.subtract(const Duration(days: 2)), clientId: 214, clientName: 'Ирина Белова', bidsCount: 0),
    ];
  }

  void _initChatRooms() {
    _chatRooms = [
      ChatRoom(id: 1, title: 'Курсовая по экономике', orderId: 1, lastMessage: 'Добрый день! Начала работу над вашей курсовой.', lastMessageAt: DateTime.now().subtract(const Duration(minutes: 30)), unreadCount: 2, participants: [ChatParticipant(userId: 101, username: 'Мария Сидорова')]),
      ChatRoom(id: 2, title: 'Дипломная по менеджменту', orderId: 4, lastMessage: 'Загрузила первую главу, проверьте пожалуйста.', lastMessageAt: DateTime.now().subtract(const Duration(hours: 2)), unreadCount: 1, participants: [ChatParticipant(userId: 103, username: 'Елена Новикова')]),
      ChatRoom(id: 3, title: 'Эссе по философии', orderId: 6, lastMessage: 'Внесла правки, посмотрите новую версию.', lastMessageAt: DateTime.now().subtract(const Duration(hours: 5)), unreadCount: 0, participants: [ChatParticipant(userId: 105, username: 'Ольга Белова')]),
    ];
    _messages = [
      ChatMessage(id: 1, roomId: 1, senderId: 101, senderName: 'Мария Сидорова', content: 'Добрый день! Приступила к работе над вашей курсовой по экономике предприятия.', createdAt: DateTime.now().subtract(const Duration(hours: 3)), isRead: true),
      ChatMessage(id: 2, roomId: 1, senderId: 0, senderName: 'Иван Иванов', content: 'Здравствуйте! Отлично, жду результат. Не забудьте про оформление по ГОСТ.', createdAt: DateTime.now().subtract(const Duration(hours: 2)), isRead: true),
      ChatMessage(id: 3, roomId: 1, senderId: 101, senderName: 'Мария Сидорова', content: 'Да, конечно. Первую главу планирую отправить завтра на проверку.', createdAt: DateTime.now().subtract(const Duration(hours: 1)), isRead: true),
      ChatMessage(id: 4, roomId: 1, senderId: 101, senderName: 'Мария Сидорова', content: 'Добрый день! Начала работу над вашей курсовой.', createdAt: DateTime.now().subtract(const Duration(minutes: 30)), isRead: false),
    ];
  }

  void _initNotifications() {
    final now = DateTime.now();
    _notifications = [
      AppNotification(id: 1, title: 'Новая ставка', message: 'Эксперт Мария Сидорова сделала ставку на ваш заказ "Реферат по истории России" — 1200₽', type: 'order', isRead: false, createdAt: now.subtract(const Duration(minutes: 15))),
      AppNotification(id: 2, title: 'Работа на проверке', message: 'Эксперт Елена Новикова загрузила решение по заказу "Дипломная работа по менеджменту"', type: 'order', isRead: false, createdAt: now.subtract(const Duration(hours: 2))),
      AppNotification(id: 3, title: 'Новое сообщение', message: 'Мария Сидорова: "Начала работу над вашей курсовой"', type: 'chat', isRead: true, createdAt: now.subtract(const Duration(hours: 3))),
      AppNotification(id: 4, title: 'Заказ завершён', message: 'Лабораторная работа по физике успешно завершена', type: 'order', isRead: true, createdAt: now.subtract(const Duration(days: 1))),
      AppNotification(id: 5, title: 'Пополнение баланса', message: 'Ваш баланс пополнен на 5000₽', type: 'payment', isRead: true, createdAt: now.subtract(const Duration(days: 2))),
      AppNotification(id: 6, title: 'Просрочка дедлайна', message: 'Дедлайн по заказу "Контрольная по математике" скоро истекает', type: 'order', isRead: true, createdAt: now.subtract(const Duration(days: 3))),
    ];
  }

  void _initReviews() {
    _reviews = [
      Review(id: 1, orderId: 3, expertId: 102, expertName: 'Алексей Козлов', rating: 5, comment: 'Отличная работа! Всё сделано качественно и в срок. Рекомендую.', createdAt: DateTime.now().subtract(const Duration(days: 1))),
      Review(id: 2, orderId: 7, expertId: 101, expertName: 'Мария Сидорова', rating: 4, comment: 'Хорошая работа, но были небольшие замечания по оформлению.', createdAt: DateTime.now().subtract(const Duration(days: 15))),
    ];
  }

  void _initExpertReviews() {
    final now = DateTime.now();
    _expertReviews = [
      Review(id: 101, orderId: 103, expertId: 0, expertName: 'Алексей Петров', clientName: 'Мария Иванова', rating: 5, comment: 'Превосходная работа! Всё идеально, качественно и точно в срок. Буду обращаться ещё!', createdAt: now.subtract(const Duration(days: 3))),
      Review(id: 102, orderId: 100, expertId: 0, expertName: 'Алексей Петров', clientName: 'Андрей Николаев', rating: 5, comment: 'Очень профессиональный подход. Курсовая на отлично!', expertReply: 'Спасибо за отзыв! Рад, что вам понравилось.', createdAt: now.subtract(const Duration(days: 10))),
      Review(id: 103, orderId: 99, expertId: 0, expertName: 'Алексей Петров', clientName: 'Екатерина Волкова', rating: 4, comment: 'Хорошая работа, но небольшие замечания по оформлению списка литературы.', createdAt: now.subtract(const Duration(days: 20))),
      Review(id: 104, orderId: 98, expertId: 0, expertName: 'Алексей Петров', clientName: 'Сергей Попов', rating: 5, comment: 'Бизнес-план выполнен на высшем уровне. Рекомендую!', createdAt: now.subtract(const Duration(days: 30))),
      Review(id: 105, orderId: 97, expertId: 0, expertName: 'Алексей Петров', clientName: 'Дмитрий Козлов', rating: 3, comment: 'Работа сдана с опозданием на день. Качество нормальное.', appealReason: 'Опоздание было вызвано техническими проблемами на платформе, о чём клиент был предупреждён заранее.', appealStatus: 'pending', createdAt: now.subtract(const Duration(days: 45))),
      Review(id: 106, orderId: 96, expertId: 0, expertName: 'Алексей Петров', clientName: 'Ольга Петрова', rating: 5, comment: 'Лучший эксперт на платформе! Всегда на связи, качество отличное.', expertReply: 'Благодарю за высокую оценку!', createdAt: now.subtract(const Duration(days: 60))),
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

  void _initExpertTransactions() {
    final now = DateTime.now();
    _expertTransactions = [
      Transaction(id: 201, type: 'earning', amount: 2250, description: 'Оплата за заказ #103 (Контрольная по статистике)', createdAt: now.subtract(const Duration(days: 3)), orderId: 103),
      Transaction(id: 202, type: 'commission', amount: -250, description: 'Комиссия платформы 10%', createdAt: now.subtract(const Duration(days: 3)), orderId: 103),
      Transaction(id: 203, type: 'earning', amount: 4050, description: 'Оплата за заказ #100 (Курсовая по макроэкономике)', createdAt: now.subtract(const Duration(days: 10))),
      Transaction(id: 204, type: 'commission', amount: -450, description: 'Комиссия платформы 10%', createdAt: now.subtract(const Duration(days: 10))),
      Transaction(id: 205, type: 'withdrawal', amount: -5000, description: 'Вывод на карту *4521', createdAt: now.subtract(const Duration(days: 14))),
      Transaction(id: 206, type: 'earning', amount: 13500, description: 'Оплата за заказ #98 (Бизнес-план)', createdAt: now.subtract(const Duration(days: 20))),
      Transaction(id: 207, type: 'commission', amount: -1500, description: 'Комиссия платформы 10%', createdAt: now.subtract(const Duration(days: 20))),
      Transaction(id: 208, type: 'earning', amount: 900, description: 'Оплата за заказ #97 (Реферат)', createdAt: now.subtract(const Duration(days: 30))),
      Transaction(id: 209, type: 'withdrawal', amount: -10000, description: 'Вывод на карту *4521', createdAt: now.subtract(const Duration(days: 35))),
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
      ExpertProfile(id: 101, name: 'Мария Сидорова', rating: 4.9, completedOrders: 234, specializations: ['Экономика', 'Менеджмент', 'Бухгалтерский учёт'], description: 'Кандидат экономических наук, преподаватель вуза с 10-летним стажем.', joinedAt: DateTime(2022, 3, 15)),
      ExpertProfile(id: 102, name: 'Алексей Козлов', rating: 4.7, completedOrders: 178, specializations: ['Физика', 'Математика', 'Инженерия'], description: 'Инженер-физик, аспирант технического университета.', joinedAt: DateTime(2022, 8, 1)),
      ExpertProfile(id: 103, name: 'Елена Новикова', rating: 4.8, completedOrders: 312, specializations: ['Менеджмент', 'Маркетинг', 'Экономика'], description: 'MBA, управляющий партнёр консалтинговой компании.', joinedAt: DateTime(2021, 11, 20)),
      ExpertProfile(id: 104, name: 'Дмитрий Волков', rating: 4.6, completedOrders: 145, specializations: ['Математика', 'Программирование', 'Статистика'], description: 'Разработчик, преподаватель математики в колледже.', joinedAt: DateTime(2023, 1, 10)),
      ExpertProfile(id: 105, name: 'Ольга Белова', rating: 4.9, completedOrders: 267, specializations: ['Философия', 'Психология', 'Социология'], description: 'Кандидат философских наук, доцент кафедры гуманитарных наук.', joinedAt: DateTime(2022, 5, 8)),
      ExpertProfile(id: 106, name: 'Наталья Морозова', rating: 4.5, completedOrders: 89, specializations: ['Маркетинг', 'Реклама', 'PR'], description: 'Директор по маркетингу в IT-компании.', joinedAt: DateTime(2023, 6, 1)),
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

  void _initExpertBids() {
    final now = DateTime.now();
    _expertBids = [
      Bid(id: 101, orderId: 201, expertId: 0, expertName: 'Алексей Петров', expertRating: 4.9, expertCompletedOrders: 156, price: 2800, days: 10, prepayPercent: 30, comment: 'Специализируюсь на микроэкономике, выполню качественно.', status: 'pending', createdAt: now.subtract(const Duration(hours: 1))),
      Bid(id: 102, orderId: 203, expertId: 0, expertName: 'Алексей Петров', expertRating: 4.9, expertCompletedOrders: 156, price: 18000, days: 25, prepayPercent: 50, comment: 'Имею большой опыт написания дипломных по менеджменту. Гарантирую качество.', status: 'pending', createdAt: now.subtract(const Duration(days: 1))),
      Bid(id: 103, orderId: 200, expertId: 0, expertName: 'Алексей Петров', expertRating: 4.9, expertCompletedOrders: 156, price: 3500, days: 7, prepayPercent: 0, comment: 'Готов взяться за работу.', status: 'accepted', createdAt: now.subtract(const Duration(days: 5))),
      Bid(id: 104, orderId: 199, expertId: 0, expertName: 'Алексей Петров', expertRating: 4.9, expertCompletedOrders: 156, price: 5000, days: 14, prepayPercent: 20, comment: 'Выполню в срок.', status: 'rejected', createdAt: now.subtract(const Duration(days: 10))),
    ];
  }

  void _initFiles() {
    _files = [
      OrderFile(id: 1, orderId: 1, name: 'Задание_курсовая.docx', type: 'task', size: 245760, uploadedAt: DateTime.now().subtract(const Duration(days: 3))),
      OrderFile(id: 2, orderId: 1, name: 'Методичка.pdf', type: 'task', size: 1572864, uploadedAt: DateTime.now().subtract(const Duration(days: 3))),
      OrderFile(id: 3, orderId: 3, name: 'Лаба_5_отчёт.pdf', type: 'solution', size: 524288, uploadedAt: DateTime.now().subtract(const Duration(days: 2))),
      OrderFile(id: 4, orderId: 4, name: 'Диплом_глава1.docx', type: 'solution', size: 368640, uploadedAt: DateTime.now().subtract(const Duration(hours: 4))),
      OrderFile(id: 5, orderId: 6, name: 'Эссе_v2.docx', type: 'revision', size: 163840, uploadedAt: DateTime.now().subtract(const Duration(hours: 6))),
      OrderFile(id: 6, orderId: 101, name: 'ТЗ_анализ.pdf', type: 'task', size: 310000, uploadedAt: DateTime.now().subtract(const Duration(days: 5))),
      OrderFile(id: 7, orderId: 101, name: 'Данные_отчёт.xlsx', type: 'task', size: 205000, uploadedAt: DateTime.now().subtract(const Duration(days: 5))),
      OrderFile(id: 8, orderId: 102, name: 'Бизнес_план_v1.docx', type: 'solution', size: 890000, uploadedAt: DateTime.now().subtract(const Duration(days: 2))),
      OrderFile(id: 9, orderId: 103, name: 'Статистика_решение.pdf', type: 'solution', size: 420000, uploadedAt: DateTime.now().subtract(const Duration(days: 4))),
    ];
  }

  void _initComplaints() {
    _complaints = [
      Complaint(id: 1, orderId: 6, orderTitle: 'Эссе по философии', reason: 'Некачественная работа', description: 'Работа не соответствует требованиям, много ошибок.', status: 'in_review', createdAt: DateTime.now().subtract(const Duration(days: 1))),
    ];
  }

  void _initSpecializations() {
    _specializations = [
      Specialization(id: 1, name: 'Экономический анализ', subject: 'Экономика', experienceYears: 10, hourlyRate: 1500, description: 'Комплексный анализ финансово-хозяйственной деятельности предприятий.', skills: ['Финансовый анализ', 'Excel', 'SPSS', '1C'], verificationStatus: 'verified'),
      Specialization(id: 2, name: 'Менеджмент организаций', subject: 'Менеджмент', experienceYears: 8, hourlyRate: 1200, description: 'Стратегический менеджмент, управление персоналом, бизнес-планирование.', skills: ['Бизнес-планирование', 'HR', 'Стратегия'], verificationStatus: 'verified'),
      Specialization(id: 3, name: 'Бухгалтерский учёт', subject: 'Бухгалтерский учёт', experienceYears: 7, hourlyRate: 1300, description: 'Бухгалтерская отчётность, налогообложение, аудит.', skills: ['1С:Бухгалтерия', 'Налоги', 'МСФО'], verificationStatus: 'verified'),
      Specialization(id: 4, name: 'Статистический анализ', subject: 'Статистика', experienceYears: 5, hourlyRate: 1400, description: 'Математическая статистика, эконометрика, анализ данных.', skills: ['SPSS', 'R', 'Python', 'Eviews'], verificationStatus: 'pending'),
    ];
  }

  void _initExpertApplication() {
    _expertApplication = ExpertApplication(
      id: 1,
      fullName: 'Петров Алексей Сергеевич',
      experienceYears: 10,
      subjects: ['Экономика', 'Менеджмент', 'Бухгалтерский учёт', 'Статистика', 'Финансовый менеджмент'],
      university: 'МГУ им. Ломоносова',
      graduationYears: '2010-2014',
      degree: 'Кандидат экономических наук',
      status: 'approved',
      createdAt: DateTime(2023, 1, 15),
    );
  }

  void _initDocuments() {
    _documents = [
      ExpertDocument(id: 1, name: 'Диплом МГУ', type: 'diploma', fileName: 'diploma_mgu.pdf', fileSize: 2048000, verificationStatus: 'verified', uploadedAt: DateTime(2023, 1, 15)),
      ExpertDocument(id: 2, name: 'Диплом кандидата наук', type: 'diploma', fileName: 'phd_diploma.pdf', fileSize: 1536000, verificationStatus: 'verified', uploadedAt: DateTime(2023, 1, 15)),
      ExpertDocument(id: 3, name: 'Сертификат 1С:Профессионал', type: 'certificate', fileName: '1c_cert.pdf', fileSize: 512000, verificationStatus: 'verified', uploadedAt: DateTime(2023, 3, 20)),
      ExpertDocument(id: 4, name: 'Сертификат ACCA', type: 'certificate', fileName: 'acca_cert.pdf', fileSize: 768000, verificationStatus: 'pending', uploadedAt: DateTime(2024, 6, 10)),
    ];
  }

  void _initShopWorks() {
    final now = DateTime.now();
    _shopWorks = [
      ShopWork(id: 1, title: 'Шаблон бизнес-плана IT-стартапа', description: 'Полный шаблон бизнес-плана с финансовой моделью. 45 страниц.', subject: 'Менеджмент', workType: 'Дипломная работа', price: 5000, salesCount: 12, createdAt: now.subtract(const Duration(days: 60))),
      ShopWork(id: 2, title: 'Сборник задач по эконометрике с решениями', description: '50 решённых задач по эконометрике с подробными пояснениями.', subject: 'Статистика', workType: 'Контрольная работа', price: 2000, salesCount: 28, createdAt: now.subtract(const Duration(days: 90))),
      ShopWork(id: 3, title: 'Анализ финансовой отчётности (пример)', description: 'Пример полного анализа финансовой отчётности ООО. 35 страниц + таблицы.', subject: 'Бухгалтерский учёт', workType: 'Курсовая работа', price: 3500, salesCount: 8, createdAt: now.subtract(const Duration(days: 45))),
    ];
  }

  // Orders
  List<Order> getOrdersByStatus(String? status) {
    if (status == null || status == 'all') return _orders;
    return _orders.where((o) => o.status == status).toList();
  }

  List<Order> getExpertOrdersByStatus(String? status) {
    if (status == null || status == 'all') return _expertOrders;
    return _expertOrders.where((o) => o.status == status).toList();
  }

  Order? getOrderById(int id) {
    for (final o in _orders) {
      if (o.id == id) return o;
    }
    for (final o in _expertOrders) {
      if (o.id == id) return o;
    }
    for (final o in _availableOrders) {
      if (o.id == id) return o;
    }
    return null;
  }

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void updateOrderStatus(int id, String status) {
    final lists = [_orders, _expertOrders];
    for (final list in lists) {
      final index = list.indexWhere((o) => o.id == id);
      if (index != -1) {
        final old = list[index];
        list[index] = Order(id: old.id, title: old.title, description: old.description, workType: old.workType, subject: old.subject, status: status, price: old.price, budget: old.budget, deadline: old.deadline, createdAt: old.createdAt, clientId: old.clientId, clientName: old.clientName, expertId: old.expertId, expertName: old.expertName, filesCount: old.filesCount, commentsCount: old.commentsCount, bidsCount: old.bidsCount);
        notifyListeners();
        return;
      }
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
    final index = _orders.indexWhere((o) => o.id == bid.orderId);
    if (index != -1) {
      final old = _orders[index];
      _orders[index] = Order(id: old.id, title: old.title, description: old.description, workType: old.workType, subject: old.subject, status: 'in_progress', price: bid.price, budget: old.budget, deadline: old.deadline, createdAt: old.createdAt, clientId: old.clientId, clientName: old.clientName, expertId: bid.expertId, expertName: bid.expertName, filesCount: old.filesCount, commentsCount: old.commentsCount, bidsCount: old.bidsCount);
    }
    _bids.removeWhere((b) => b.orderId == bid.orderId && b.id != bid.id);
    notifyListeners();
  }

  void addBid(Bid bid) {
    _expertBids.insert(0, bid);
    notifyListeners();
  }

  void cancelBid(int bidId) {
    _expertBids.removeWhere((b) => b.id == bidId);
    notifyListeners();
  }

  // Files
  List<OrderFile> getFilesForOrder(int orderId) {
    return _files.where((f) => f.orderId == orderId).toList();
  }

  void addFile(OrderFile file) {
    _files.add(file);
    notifyListeners();
  }

  void deleteFile(int fileId) {
    _files.removeWhere((f) => f.id == fileId);
    notifyListeners();
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
      _chatRooms[roomIndex] = ChatRoom(id: old.id, title: old.title, orderId: old.orderId, lastMessage: message.content, lastMessageAt: message.createdAt, unreadCount: old.unreadCount, participants: old.participants);
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
      _reviews[index] = Review(id: old.id, orderId: old.orderId, expertId: old.expertId, expertName: old.expertName, rating: rating, comment: comment, createdAt: old.createdAt);
      notifyListeners();
    }
  }

  void deleteReview(int id) {
    _reviews.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  void replyToReview(int id, String reply) {
    final index = _expertReviews.indexWhere((r) => r.id == id);
    if (index != -1) {
      final old = _expertReviews[index];
      _expertReviews[index] = Review(id: old.id, orderId: old.orderId, expertId: old.expertId, expertName: old.expertName, clientName: old.clientName, rating: old.rating, comment: old.comment, expertReply: reply, appealReason: old.appealReason, appealStatus: old.appealStatus, createdAt: old.createdAt);
      notifyListeners();
    }
  }

  void appealReview(int id, String reason) {
    final index = _expertReviews.indexWhere((r) => r.id == id);
    if (index != -1) {
      final old = _expertReviews[index];
      _expertReviews[index] = Review(id: old.id, orderId: old.orderId, expertId: old.expertId, expertName: old.expertName, clientName: old.clientName, rating: old.rating, comment: old.comment, expertReply: old.expertReply, appealReason: reason, appealStatus: 'pending', createdAt: old.createdAt);
      notifyListeners();
    }
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

  void addExpertTransaction(Transaction transaction) {
    _expertTransactions.insert(0, transaction);
    notifyListeners();
  }

  // Complaints
  void addComplaint(Complaint complaint) {
    _complaints.insert(0, complaint);
    notifyListeners();
  }

  void respondToComplaint(int id, String response) {
    final index = _complaints.indexWhere((c) => c.id == id);
    if (index != -1) {
      final old = _complaints[index];
      _complaints[index] = Complaint(id: old.id, orderId: old.orderId, orderTitle: old.orderTitle, reason: old.reason, description: old.description, status: old.status, resolution: old.resolution, expertResponse: response, createdAt: old.createdAt);
      notifyListeners();
    }
  }

  // Notifications
  void markNotificationRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final old = _notifications[index];
      _notifications[index] = AppNotification(id: old.id, title: old.title, message: old.message, type: old.type, isRead: true, createdAt: old.createdAt);
      notifyListeners();
    }
  }

  // Specializations
  void addSpecialization(Specialization spec) {
    _specializations.add(spec);
    notifyListeners();
  }

  void updateSpecialization(int id, Specialization spec) {
    final index = _specializations.indexWhere((s) => s.id == id);
    if (index != -1) {
      _specializations[index] = spec;
      notifyListeners();
    }
  }

  void deleteSpecialization(int id) {
    _specializations.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // Documents
  void addDocument(ExpertDocument doc) {
    _documents.add(doc);
    notifyListeners();
  }

  void deleteDocument(int id) {
    _documents.removeWhere((d) => d.id == id);
    notifyListeners();
  }

  // Shop works
  void addShopWork(ShopWork work) {
    _shopWorks.insert(0, work);
    notifyListeners();
  }

  void updateShopWork(int id, ShopWork work) {
    final index = _shopWorks.indexWhere((w) => w.id == id);
    if (index != -1) {
      _shopWorks[index] = work;
      notifyListeners();
    }
  }

  void deleteShopWork(int id) {
    _shopWorks.removeWhere((w) => w.id == id);
    notifyListeners();
  }
}
