import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/director_models.dart';

class DirectorTestDataProvider extends ChangeNotifier {
  List<StaffMember> _staff = [];
  List<StaffMember> _archivedStaff = [];
  List<ExpertApplication> _expertApplications = [];
  List<FinanceRecord> _incomes = [];
  List<FinanceRecord> _expenses = [];
  List<DirectorPartner> _partners = [];
  PlatformKPI? _kpi;
  List<MeetingRequest> _meetingRequests = [];
  List<ImprovementSuggestion> _suggestions = [];
  List<FaqItem> _faq = [];

  List<StaffMember> get staff => _staff;
  List<StaffMember> get archivedStaff => _archivedStaff;
  List<ExpertApplication> get expertApplications => _expertApplications;
  List<FinanceRecord> get incomes => _incomes;
  List<FinanceRecord> get expenses => _expenses;
  List<DirectorPartner> get partners => _partners;
  PlatformKPI? get kpi => _kpi;
  List<MeetingRequest> get meetingRequests => _meetingRequests;
  List<ImprovementSuggestion> get suggestions => _suggestions;
  List<FaqItem> get faq => _faq;

  double get monthlyTurnover => _incomes.fold<double>(0, (s, r) => s + r.amount);
  double get monthlyExpenses => _expenses.fold<double>(0, (s, r) => s + r.amount);
  double get netProfit => monthlyTurnover - monthlyExpenses;
  double get partnersTotalTurnover => _partners.fold<double>(0, (s, p) => s + p.earned);

  void initDirectorTestData() {
    _initStaff();
    _initExpertApplications();
    _initFinance();
    _initPartners();
    _initKPI();
    _initMeetingRequests();
    _initSuggestions();
    _initFaq();
    notifyListeners();
  }

  void _initStaff() {
    _staff = [
      StaffMember(id: 1, fullName: 'Сергей Администратов', email: 'admin@okoznaniy.ru', role: 'admin', isActive: true, createdAt: DateTime(2024, 1, 10)),
      StaffMember(id: 2, fullName: 'Мария Модератор', email: 'maria.mod@okoznaniy.ru', role: 'admin', isActive: true, createdAt: DateTime(2024, 5, 15)),
      StaffMember(id: 3, fullName: 'Алексей Петров', email: 'expert@okoznaniy.ru', role: 'expert', isActive: true, createdAt: DateTime(2024, 3, 20)),
      StaffMember(id: 4, fullName: 'Анна Арбитрова', email: 'arbiter@okoznaniy.ru', role: 'arbiter', isActive: true, createdAt: DateTime(2024, 7, 1)),
      StaffMember(id: 5, fullName: 'Иван Партнёров', email: 'partner@okoznaniy.ru', role: 'partner', isActive: true, createdAt: DateTime(2025, 1, 5)),
      StaffMember(id: 6, fullName: 'Елена Новикова', email: 'elena@okoznaniy.ru', role: 'admin', isActive: false, createdAt: DateTime(2025, 3, 10)),
    ];
    _archivedStaff = [
      StaffMember(id: 7, fullName: 'Дмитрий Бывший', email: 'dmitry@okoznaniy.ru', role: 'admin', isActive: false, isArchived: true, createdAt: DateTime(2023, 6, 1)),
    ];
  }

  void _initExpertApplications() {
    _expertApplications = [
      ExpertApplication(id: 1, fullName: 'Козлова Наталья', email: 'kozlova@mail.ru', experienceYears: 5, university: 'МГУ', subjects: ['Экономика', 'Статистика'], status: 'pending', createdAt: DateTime(2026, 4, 20)),
      ExpertApplication(id: 2, fullName: 'Волков Андрей', email: 'volkov@mail.ru', experienceYears: 8, university: 'МГТУ им. Баумана', subjects: ['Физика', 'Математика'], status: 'pending', createdAt: DateTime(2026, 4, 22)),
      ExpertApplication(id: 3, fullName: 'Смирнова Ольга', email: 'smirnova@mail.ru', experienceYears: 3, university: 'СПбГУ', subjects: ['Философия'], status: 'rework', createdAt: DateTime(2026, 4, 15)),
    ];
  }

  void _initFinance() {
    _incomes = [
      FinanceRecord(id: 1, category: 'Комиссия с заказов', amount: 450000, description: 'Комиссия за апрель 2026', date: DateTime(2026, 4, 25), isIncome: true),
      FinanceRecord(id: 2, category: 'Подписки', amount: 85000, description: 'Премиум-подписки', date: DateTime(2026, 4, 20), isIncome: true),
      FinanceRecord(id: 3, category: 'Реклама', amount: 120000, description: 'Рекламные размещения', date: DateTime(2026, 4, 15), isIncome: true),
      FinanceRecord(id: 4, category: 'Комиссия с заказов', amount: 380000, description: 'Комиссия за март 2026', date: DateTime(2026, 3, 25), isIncome: true),
    ];
    _expenses = [
      FinanceRecord(id: 5, category: 'Зарплаты', amount: 320000, description: 'Зарплаты сотрудников', date: DateTime(2026, 4, 25), isIncome: false),
      FinanceRecord(id: 6, category: 'Серверы', amount: 45000, description: 'Хостинг и серверы', date: DateTime(2026, 4, 20), isIncome: false),
      FinanceRecord(id: 7, category: 'Маркетинг', amount: 80000, description: 'Рекламные кампании', date: DateTime(2026, 4, 15), isIncome: false),
      FinanceRecord(id: 8, category: 'Выплаты партнёрам', amount: 55000, description: 'Партнёрские выплаты', date: DateTime(2026, 4, 10), isIncome: false),
    ];
  }

  void _initPartners() {
    _partners = [
      DirectorPartner(id: 1, username: 'partner_anna', email: 'anna@partner.ru', referrals: 156, earned: 234000, paid: 180000, commissionRate: 15, isActive: true),
      DirectorPartner(id: 2, username: 'partner_maria', email: 'maria@partner.ru', referrals: 78, earned: 112000, paid: 95000, commissionRate: 12, isActive: true),
      DirectorPartner(id: 3, username: 'partner_ivan', email: 'ivan@partner.ru', referrals: 45, earned: 67500, paid: 67500, commissionRate: 10, isActive: true),
      DirectorPartner(id: 4, username: 'partner_dmitry', email: 'dmitry@partner.ru', referrals: 33, earned: 49500, paid: 30000, commissionRate: 10, isActive: true),
      DirectorPartner(id: 5, username: 'partner_sergey', email: 'sergey@partner.ru', referrals: 12, earned: 18500, paid: 18500, commissionRate: 8, isActive: false),
    ];
  }

  void _initKPI() {
    _kpi = PlatformKPI(
      totalOrders: 5680,
      avgCheck: 4250,
      conversionRate: 68.5,
      activeUsers: 892,
      newUsersThisMonth: 145,
      completedOrdersThisMonth: 423,
      revenueThisMonth: 655000,
      profitThisMonth: 155000,
    );
  }

  void _initMeetingRequests() {
    _meetingRequests = [
      MeetingRequest(id: 1, fromName: 'Сергей Администратов', topic: 'Обсуждение новых тарифов', status: 'pending', requestedAt: DateTime(2026, 4, 25), meetingDate: DateTime(2026, 4, 28, 14)),
      MeetingRequest(id: 2, fromName: 'Анна Арбитрова', topic: 'Сложное арбитражное дело #3', status: 'approved', requestedAt: DateTime(2026, 4, 23), meetingDate: DateTime(2026, 4, 26, 10)),
      MeetingRequest(id: 3, fromName: 'Мария Модератор', topic: 'Проблемы с модерацией', status: 'pending', requestedAt: DateTime(2026, 4, 24)),
    ];
  }

  void _initSuggestions() {
    _suggestions = [
      ImprovementSuggestion(id: 1, authorName: 'Иванов И.', authorRole: 'client', text: 'Добавить возможность оплаты через СБП', createdAt: DateTime(2026, 4, 24)),
      ImprovementSuggestion(id: 2, authorName: 'Петрова М.', authorRole: 'expert', text: 'Сделать мобильное уведомление о новых заказах по специализации', createdAt: DateTime(2026, 4, 23)),
      ImprovementSuggestion(id: 3, authorName: 'Козлова Н.', authorRole: 'client', text: 'Добавить рейтинг экспертов по предметам, а не только общий', createdAt: DateTime(2026, 4, 22)),
      ImprovementSuggestion(id: 4, authorName: 'Волков А.', authorRole: 'expert', text: 'Возможность выставлять счёт клиенту за дополнительные доработки', createdAt: DateTime(2026, 4, 20)),
      ImprovementSuggestion(id: 5, authorName: 'Сергей Администратов', authorRole: 'admin', text: 'Автоматическое назначение арбитра при открытии спора', createdAt: DateTime(2026, 4, 19)),
    ];
  }

  void _initFaq() {
    _faq = [
      FaqItem(question: 'Как зарегистрировать нового сотрудника?', answer: 'Перейдите в раздел "Управление персоналом" и нажмите "Зарегистрировать". Заполните email, ФИО и выберите роль.'),
      FaqItem(question: 'Как изменить комиссию партнёра?', answer: 'В разделе "Партнёры" откройте карточку партнёра и измените процент комиссии.'),
      FaqItem(question: 'Как одобрить заявку эксперта?', answer: 'В разделе "Управление персоналом" → "Заявки экспертов" нажмите на заявку и выберите "Одобрить".'),
      FaqItem(question: 'Где посмотреть финансовую отчётность?', answer: 'В разделе "Финансовая статистика" — месячный оборот, чистая прибыль, детализация доходов/расходов.'),
      FaqItem(question: 'Как снять бан за контакты?', answer: 'В разделе "Баны за контакты" найдите пользователя и нажмите "Снять бан".'),
      FaqItem(question: 'Как запросить встречу?', answer: 'В разделе "Коммуникация" → "Запросы встреч" нажмите "Запросить встречу" и заполните форму.'),
    ];
  }

  // Personnel
  void activateStaff(int id) {
    final i = _staff.indexWhere((s) => s.id == id);
    if (i != -1) { _staff[i] = _staff[i].copyWith(isActive: true); notifyListeners(); }
  }

  void deactivateStaff(int id) {
    final i = _staff.indexWhere((s) => s.id == id);
    if (i != -1) { _staff[i] = _staff[i].copyWith(isActive: false); notifyListeners(); }
  }

  void archiveStaff(int id) {
    final i = _staff.indexWhere((s) => s.id == id);
    if (i != -1) {
      final member = _staff.removeAt(i).copyWith(isArchived: true, isActive: false);
      _archivedStaff.add(member);
      notifyListeners();
    }
  }

  void restoreStaff(int id) {
    final i = _archivedStaff.indexWhere((s) => s.id == id);
    if (i != -1) {
      final member = _archivedStaff.removeAt(i).copyWith(isArchived: false);
      _staff.add(member);
      notifyListeners();
    }
  }

  void addStaff(StaffMember member) {
    _staff.add(member);
    notifyListeners();
  }

  // Expert applications
  void approveExpertApplication(int id) {
    final i = _expertApplications.indexWhere((a) => a.id == id);
    if (i != -1) { _expertApplications[i] = _expertApplications[i].copyWith(status: 'approved'); notifyListeners(); }
  }

  void rejectExpertApplication(int id) {
    final i = _expertApplications.indexWhere((a) => a.id == id);
    if (i != -1) { _expertApplications[i] = _expertApplications[i].copyWith(status: 'rejected'); notifyListeners(); }
  }

  void reworkExpertApplication(int id) {
    final i = _expertApplications.indexWhere((a) => a.id == id);
    if (i != -1) { _expertApplications[i] = _expertApplications[i].copyWith(status: 'rework'); notifyListeners(); }
  }

  // Finance
  void addIncome(FinanceRecord record) { _incomes.insert(0, record); notifyListeners(); }
  void addExpense(FinanceRecord record) { _expenses.insert(0, record); notifyListeners(); }
  void deleteIncome(int id) { _incomes.removeWhere((r) => r.id == id); notifyListeners(); }
  void deleteExpense(int id) { _expenses.removeWhere((r) => r.id == id); notifyListeners(); }

  // Partners
  void updatePartnerCommission(int id, double rate) {
    final i = _partners.indexWhere((p) => p.id == id);
    if (i != -1) { _partners[i] = _partners[i].copyWith(commissionRate: rate); notifyListeners(); }
  }

  void togglePartnerStatus(int id) {
    final i = _partners.indexWhere((p) => p.id == id);
    if (i != -1) { _partners[i] = _partners[i].copyWith(isActive: !_partners[i].isActive); notifyListeners(); }
  }

  // Meeting requests
  void approveMeeting(int id) {
    final i = _meetingRequests.indexWhere((m) => m.id == id);
    if (i != -1) { _meetingRequests[i] = _meetingRequests[i].copyWith(status: 'approved'); notifyListeners(); }
  }

  void rejectMeeting(int id) {
    final i = _meetingRequests.indexWhere((m) => m.id == id);
    if (i != -1) { _meetingRequests[i] = _meetingRequests[i].copyWith(status: 'rejected'); notifyListeners(); }
  }
}
