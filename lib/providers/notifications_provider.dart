import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/notification.dart';

class NotificationsProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _wsConnected = false;

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get wsConnected => _wsConnected;

  void initTestNotifications(String role) {
    final now = DateTime.now();
    final List<AppNotification> items = [];

    if (role == 'client') {
      items.addAll([
        AppNotification(id: 1, title: 'Новая ставка', message: 'Эксперт Алексей П. предложил ставку 2500₽ на ваш заказ', type: 'bid', createdAt: now.subtract(const Duration(minutes: 15))),
        AppNotification(id: 2, title: 'Заказ выполнен', message: 'Эксперт завершил работу по заказу #1024', type: 'order', createdAt: now.subtract(const Duration(hours: 2))),
        AppNotification(id: 3, title: 'Новое сообщение', message: 'Вам пришло сообщение в чат по заказу', type: 'chat', createdAt: now.subtract(const Duration(hours: 5)), isRead: true),
        AppNotification(id: 4, title: 'Пополнение баланса', message: 'Баланс пополнен на 5000₽', type: 'payment', createdAt: now.subtract(const Duration(days: 1)), isRead: true),
        AppNotification(id: 5, title: 'Новый отзыв', message: 'Эксперт оставил отзыв о сотрудничестве', type: 'review', createdAt: now.subtract(const Duration(days: 2)), isRead: true),
      ]);
    } else if (role == 'expert') {
      items.addAll([
        AppNotification(id: 1, title: 'Новый заказ', message: 'Появился новый заказ по теме "Экономика"', type: 'order', createdAt: now.subtract(const Duration(minutes: 10))),
        AppNotification(id: 2, title: 'Ставка принята', message: 'Клиент принял вашу ставку на заказ #1025', type: 'bid', createdAt: now.subtract(const Duration(hours: 1))),
        AppNotification(id: 3, title: 'Доработка', message: 'Клиент отправил заказ #1020 на доработку', type: 'revision', createdAt: now.subtract(const Duration(hours: 3))),
        AppNotification(id: 4, title: 'Работа принята', message: 'Клиент принял работу по заказу #1018', type: 'order', createdAt: now.subtract(const Duration(days: 1)), isRead: true),
        AppNotification(id: 5, title: 'Новый отзыв', message: 'Клиент оценил вашу работу на 5 звёзд', type: 'review', createdAt: now.subtract(const Duration(days: 1)), isRead: true),
        AppNotification(id: 6, title: 'Выплата', message: 'Начислено 3500₽ за заказ #1018', type: 'payment', createdAt: now.subtract(const Duration(days: 2)), isRead: true),
      ]);
    } else if (role == 'admin') {
      items.addAll([
        AppNotification(id: 1, title: 'Новое обращение', message: 'Поступила жалоба от пользователя на обмен контактами', type: 'ticket', createdAt: now.subtract(const Duration(minutes: 5))),
        AppNotification(id: 2, title: 'Нарушение в чате', message: 'Обнаружен обмен контактами: пользователь client_42', type: 'violation', createdAt: now.subtract(const Duration(minutes: 30))),
        AppNotification(id: 3, title: 'Арбитраж', message: 'Новое дело передано в арбитраж', type: 'arbitration', createdAt: now.subtract(const Duration(hours: 2))),
        AppNotification(id: 4, title: 'Регистрация', message: 'Зарегистрировался новый партнёр', type: 'info', createdAt: now.subtract(const Duration(hours: 6)), isRead: true),
      ]);
    } else if (role == 'director') {
      items.addAll([
        AppNotification(id: 1, title: 'Заявка эксперта', message: 'Новая заявка на модерацию от Сидорова И.А.', type: 'application', createdAt: now.subtract(const Duration(minutes: 20))),
        AppNotification(id: 2, title: 'Запрос встречи', message: 'Администратор Сергей А. запросил встречу', type: 'meeting', createdAt: now.subtract(const Duration(hours: 1))),
        AppNotification(id: 3, title: 'Финансы', message: 'Месячный оборот превысил 700 000₽', type: 'payment', createdAt: now.subtract(const Duration(days: 1)), isRead: true),
      ]);
    } else if (role == 'partner') {
      items.addAll([
        AppNotification(id: 1, title: 'Новый реферал', message: 'По вашей ссылке зарегистрировался новый пользователь', type: 'referral', createdAt: now.subtract(const Duration(hours: 2))),
        AppNotification(id: 2, title: 'Начисление', message: 'Начислено 350₽ за заказ реферала #1030', type: 'payment', createdAt: now.subtract(const Duration(hours: 8))),
        AppNotification(id: 3, title: 'Выплата', message: 'Выплата 12500₽ обработана', type: 'payment', createdAt: now.subtract(const Duration(days: 2)), isRead: true),
      ]);
    }

    _notifications = items;
    notifyListeners();
  }

  void markRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final n = _notifications[index];
      _notifications[index] = AppNotification(
        id: n.id, title: n.title, message: n.message, type: n.type,
        isRead: true, createdAt: n.createdAt, actionUrl: n.actionUrl, relatedObjectId: n.relatedObjectId,
      );
      notifyListeners();
    }
  }

  void markAllRead() {
    _notifications = _notifications.map((n) => AppNotification(
      id: n.id, title: n.title, message: n.message, type: n.type,
      isRead: true, createdAt: n.createdAt, actionUrl: n.actionUrl, relatedObjectId: n.relatedObjectId,
    )).toList();
    notifyListeners();
  }

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void setWsConnected(bool connected) {
    _wsConnected = connected;
    notifyListeners();
  }
}
