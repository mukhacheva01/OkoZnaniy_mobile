import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/partner_models.dart';

class PartnerTestDataProvider extends ChangeNotifier {
  PartnerStats? _stats;
  List<PartnerReferral> _referrals = [];
  List<PartnerEarning> _earnings = [];
  List<PromoMaterial> _promos = [];
  List<PartnerChatRoom> _chatRooms = [];
  List<PartnerFaqItem> _faq = [];
  List<PartnerMapEntry> _mapEntries = [];

  PartnerStats? get stats => _stats;
  List<PartnerReferral> get referrals => _referrals;
  List<PartnerEarning> get earnings => _earnings;
  List<PromoMaterial> get promos => _promos;
  List<PartnerChatRoom> get chatRooms => _chatRooms;
  List<PartnerFaqItem> get faq => _faq;
  List<PartnerMapEntry> get mapEntries => _mapEntries;

  void initPartnerTestData() {
    _initStats();
    _initReferrals();
    _initEarnings();
    _initPromos();
    _initChatRooms();
    _initFaq();
    _initMap();
    notifyListeners();
  }

  void _initStats() {
    _stats = PartnerStats(
      totalReferrals: 23,
      activeReferrals: 18,
      totalEarned: 45600,
      pendingPayout: 12500,
      commissionRate: 10,
      referralLink: 'https://okoznaniy.ru/ref/PARTNER2026',
      referralCode: 'PARTNER2026',
    );
  }

  void _initReferrals() {
    _referrals = [
      PartnerReferral(id: 1, username: 'Иванов Иван', email: 'ivanov@mail.ru', role: 'client', ordersCount: 12, registeredAt: DateTime(2025, 8, 15)),
      PartnerReferral(id: 2, username: 'Петрова Мария', email: 'petrova@mail.ru', role: 'expert', ordersCount: 45, registeredAt: DateTime(2025, 9, 20)),
      PartnerReferral(id: 3, username: 'Козлов Алексей', email: 'kozlov@mail.ru', role: 'client', ordersCount: 5, registeredAt: DateTime(2025, 11, 1)),
      PartnerReferral(id: 4, username: 'Смирнова Ольга', email: 'smirnova@mail.ru', role: 'client', ordersCount: 8, registeredAt: DateTime(2025, 12, 10)),
      PartnerReferral(id: 5, username: 'Волков Дмитрий', email: 'volkov@mail.ru', role: 'expert', ordersCount: 23, registeredAt: DateTime(2026, 1, 5)),
      PartnerReferral(id: 6, username: 'Новикова Елена', email: 'novikova@mail.ru', role: 'client', ordersCount: 3, registeredAt: DateTime(2026, 2, 14)),
      PartnerReferral(id: 7, username: 'Белов Андрей', email: 'belov@mail.ru', role: 'client', ordersCount: 0, registeredAt: DateTime(2026, 3, 20)),
      PartnerReferral(id: 8, username: 'Морозова Наталья', email: 'morozova@mail.ru', role: 'expert', ordersCount: 15, registeredAt: DateTime(2026, 4, 1)),
    ];
  }

  void _initEarnings() {
    _earnings = [
      PartnerEarning(id: 1, orderId: 1045, referralName: 'Иванов И.', type: 'order_commission', amount: 450, isPaid: true, createdAt: DateTime(2026, 4, 24)),
      PartnerEarning(id: 2, orderId: 1052, referralName: 'Петрова М.', type: 'order_commission', amount: 2200, isPaid: false, createdAt: DateTime(2026, 4, 22)),
      PartnerEarning(id: 3, referralName: 'Козлов А.', type: 'registration_bonus', amount: 500, isPaid: true, createdAt: DateTime(2026, 4, 20)),
      PartnerEarning(id: 4, orderId: 1061, referralName: 'Волков Д.', type: 'order_commission', amount: 1800, isPaid: false, createdAt: DateTime(2026, 4, 18)),
      PartnerEarning(id: 5, orderId: 1033, referralName: 'Смирнова О.', type: 'order_commission', amount: 350, isPaid: true, createdAt: DateTime(2026, 4, 15)),
      PartnerEarning(id: 6, orderId: 1070, referralName: 'Морозова Н.', type: 'order_commission', amount: 3100, isPaid: false, createdAt: DateTime(2026, 4, 12)),
      PartnerEarning(id: 7, referralName: 'Белов А.', type: 'registration_bonus', amount: 500, isPaid: true, createdAt: DateTime(2026, 4, 10)),
      PartnerEarning(id: 8, orderId: 998, referralName: 'Иванов И.', type: 'order_commission', amount: 600, isPaid: true, isCancelled: true, createdAt: DateTime(2026, 4, 5)),
      PartnerEarning(id: 9, orderId: 1078, referralName: 'Новикова Е.', type: 'order_commission', amount: 800, isPaid: false, createdAt: DateTime(2026, 4, 3)),
      PartnerEarning(id: 10, orderId: 1020, referralName: 'Петрова М.', type: 'order_commission', amount: 1500, isPaid: true, createdAt: DateTime(2026, 3, 28)),
    ];
  }

  void _initPromos() {
    _promos = [
      PromoMaterial(id: 1, title: 'Баннер 728x90', description: 'Горизонтальный баннер для сайтов и блогов', type: 'banner'),
      PromoMaterial(id: 2, title: 'Баннер 300x250', description: 'Квадратный баннер для боковой панели', type: 'banner'),
      PromoMaterial(id: 3, title: 'Пост для ВКонтакте', description: 'Готовый текст для публикации в VK с картинкой', type: 'social_post'),
      PromoMaterial(id: 4, title: 'Пост для Telegram', description: 'Текст для Telegram-канала с форматированием', type: 'social_post'),
      PromoMaterial(id: 5, title: 'Email-рассылка', description: 'Шаблон письма для рассылки по email', type: 'email'),
      PromoMaterial(id: 6, title: 'Логотип Око Знаний', description: 'Логотип в различных форматах (PNG, SVG)', type: 'asset'),
    ];
  }

  void _initChatRooms() {
    _chatRooms = [
      PartnerChatRoom(id: 1, name: 'Чат с менеджером', membersCount: 2, lastMessage: 'Добрый день! Ваши выплаты будут обработаны завтра.', lastMessageAt: DateTime(2026, 4, 25, 14, 30)),
      PartnerChatRoom(id: 2, name: 'Партнёры — Общий', membersCount: 12, lastMessage: 'Коллеги, новые промо-материалы доступны!', lastMessageAt: DateTime(2026, 4, 24, 11, 0)),
    ];
  }

  void _initFaq() {
    _faq = [
      PartnerFaqItem(question: 'Как начать зарабатывать?', answer: 'Скопируйте реферальную ссылку из раздела "Партнёрская программа" и делитесь ей с друзьями. За каждого привлечённого пользователя вы получите бонус, а за каждый заказ — комиссию.'),
      PartnerFaqItem(question: 'Какой размер комиссии?', answer: 'Стандартная ставка — 10% от суммы заказа вашего реферала. Ставка может быть увеличена при достижении определённого количества рефералов.'),
      PartnerFaqItem(question: 'Когда происходят выплаты?', answer: 'Выплаты производятся раз в месяц, 25 числа. Минимальная сумма для вывода — 1000₽.'),
      PartnerFaqItem(question: 'Как отслеживать рефералов?', answer: 'В разделе "Мои рефералы" вы можете видеть всех привлечённых пользователей, их роли и количество заказов.'),
      PartnerFaqItem(question: 'Можно ли изменить реферальную ссылку?', answer: 'Да, вы можете пересоздать реферальную ссылку в разделе "Партнёрская программа". Старая ссылка перестанет работать.'),
      PartnerFaqItem(question: 'Как связаться с менеджером?', answer: 'Используйте раздел "Коммуникация" для связи с вашим персональным менеджером через чат.'),
    ];
  }

  void _initMap() {
    _mapEntries = [
      PartnerMapEntry(id: 1, name: 'Анна Партнёрова', city: 'Москва', lat: 55.7558, lng: 37.6173, referrals: 23, isActive: true),
      PartnerMapEntry(id: 2, name: 'Мария Иванова', city: 'Санкт-Петербург', lat: 59.9343, lng: 30.3351, referrals: 78, isActive: true),
      PartnerMapEntry(id: 3, name: 'Иван Козлов', city: 'Новосибирск', lat: 55.0084, lng: 82.9357, referrals: 45, isActive: true),
      PartnerMapEntry(id: 4, name: 'Дмитрий Волков', city: 'Екатеринбург', lat: 56.8389, lng: 60.6057, referrals: 33, isActive: true),
      PartnerMapEntry(id: 5, name: 'Сергей Новиков', city: 'Казань', lat: 55.7963, lng: 49.1089, referrals: 12, isActive: false),
      PartnerMapEntry(id: 6, name: 'Елена Белова', city: 'Нижний Новгород', lat: 56.2965, lng: 43.9361, referrals: 56, isActive: true),
      PartnerMapEntry(id: 7, name: 'Андрей Морозов', city: 'Самара', lat: 53.1959, lng: 50.1002, referrals: 19, isActive: true),
    ];
  }

  void regenerateReferralLink() {
    if (_stats != null) {
      final newCode = 'PARTNER${DateTime.now().millisecondsSinceEpoch % 100000}';
      _stats = PartnerStats(
        totalReferrals: _stats!.totalReferrals,
        activeReferrals: _stats!.activeReferrals,
        totalEarned: _stats!.totalEarned,
        pendingPayout: _stats!.pendingPayout,
        commissionRate: _stats!.commissionRate,
        referralLink: 'https://okoznaniy.ru/ref/$newCode',
        referralCode: newCode,
      );
      notifyListeners();
    }
  }
}
