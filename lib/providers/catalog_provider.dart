import 'package:flutter/foundation.dart';
import 'package:oko_znaniy_mobile/models/catalog.dart';

class CatalogProvider extends ChangeNotifier {
  List<CatalogSubject> _subjects = [];
  List<CatalogTopic> _topics = [];
  List<WorkType> _workTypes = [];
  List<ComplexityLevel> _complexityLevels = [];
  List<CatalogCategory> _categories = [];
  List<CatalogSkill> _skills = [];
  bool _isLoaded = false;

  List<CatalogSubject> get subjects => _subjects;
  List<CatalogTopic> get topics => _topics;
  List<WorkType> get workTypes => _workTypes;
  List<ComplexityLevel> get complexityLevels => _complexityLevels;
  List<CatalogCategory> get categories => _categories;
  List<CatalogSkill> get skills => _skills;
  bool get isLoaded => _isLoaded;

  List<CatalogTopic> topicsForSubject(int subjectId) =>
      _topics.where((t) => t.subjectId == subjectId).toList();

  void initTestData() {
    _subjects = [
      CatalogSubject(id: 1, name: 'Математика', topicsCount: 5),
      CatalogSubject(id: 2, name: 'Экономика', topicsCount: 4),
      CatalogSubject(id: 3, name: 'Программирование', topicsCount: 6),
      CatalogSubject(id: 4, name: 'Юриспруденция', topicsCount: 3),
      CatalogSubject(id: 5, name: 'Менеджмент', topicsCount: 4),
      CatalogSubject(id: 6, name: 'Психология', topicsCount: 3),
      CatalogSubject(id: 7, name: 'Философия', topicsCount: 2),
      CatalogSubject(id: 8, name: 'Маркетинг', topicsCount: 3),
      CatalogSubject(id: 9, name: 'Бухгалтерский учёт', topicsCount: 3),
      CatalogSubject(id: 10, name: 'Статистика', topicsCount: 2),
    ];

    _topics = [
      CatalogTopic(id: 1, name: 'Высшая математика', subjectId: 1),
      CatalogTopic(id: 2, name: 'Дискретная математика', subjectId: 1),
      CatalogTopic(id: 3, name: 'Теория вероятностей', subjectId: 1),
      CatalogTopic(id: 4, name: 'Линейная алгебра', subjectId: 1),
      CatalogTopic(id: 5, name: 'Математический анализ', subjectId: 1),
      CatalogTopic(id: 6, name: 'Микроэкономика', subjectId: 2),
      CatalogTopic(id: 7, name: 'Макроэкономика', subjectId: 2),
      CatalogTopic(id: 8, name: 'Эконометрика', subjectId: 2),
      CatalogTopic(id: 9, name: 'Мировая экономика', subjectId: 2),
      CatalogTopic(id: 10, name: 'Python', subjectId: 3),
      CatalogTopic(id: 11, name: 'Java', subjectId: 3),
      CatalogTopic(id: 12, name: 'C++', subjectId: 3),
      CatalogTopic(id: 13, name: 'Web-разработка', subjectId: 3),
      CatalogTopic(id: 14, name: 'Базы данных', subjectId: 3),
      CatalogTopic(id: 15, name: 'Алгоритмы', subjectId: 3),
      CatalogTopic(id: 16, name: 'Гражданское право', subjectId: 4),
      CatalogTopic(id: 17, name: 'Уголовное право', subjectId: 4),
      CatalogTopic(id: 18, name: 'Административное право', subjectId: 4),
    ];

    _workTypes = [
      WorkType(id: 1, name: 'Курсовая работа', basePrice: 3000),
      WorkType(id: 2, name: 'Дипломная работа', basePrice: 10000),
      WorkType(id: 3, name: 'Контрольная работа', basePrice: 1000),
      WorkType(id: 4, name: 'Реферат', basePrice: 800),
      WorkType(id: 5, name: 'Эссе', basePrice: 600),
      WorkType(id: 6, name: 'Отчёт по практике', basePrice: 2000),
      WorkType(id: 7, name: 'Решение задач', basePrice: 500),
      WorkType(id: 8, name: 'Презентация', basePrice: 700),
      WorkType(id: 9, name: 'Лабораторная работа', basePrice: 800),
      WorkType(id: 10, name: 'Диссертация', basePrice: 25000),
    ];

    _complexityLevels = [
      ComplexityLevel(id: 1, name: 'Простая', multiplier: 0.8),
      ComplexityLevel(id: 2, name: 'Средняя', multiplier: 1.0),
      ComplexityLevel(id: 3, name: 'Сложная', multiplier: 1.5),
      ComplexityLevel(id: 4, name: 'Очень сложная', multiplier: 2.0),
    ];

    _categories = [
      CatalogCategory(id: 1, name: 'Естественные науки', icon: 'science'),
      CatalogCategory(id: 2, name: 'Гуманитарные науки', icon: 'book'),
      CatalogCategory(id: 3, name: 'Технические науки', icon: 'engineering'),
      CatalogCategory(id: 4, name: 'Экономические науки', icon: 'money'),
      CatalogCategory(id: 5, name: 'Юридические науки', icon: 'gavel'),
    ];

    _skills = [
      CatalogSkill(id: 1, name: 'Аналитическое мышление'),
      CatalogSkill(id: 2, name: 'Работа с данными'),
      CatalogSkill(id: 3, name: 'Научное письмо'),
      CatalogSkill(id: 4, name: 'Программирование'),
      CatalogSkill(id: 5, name: 'Статистический анализ'),
      CatalogSkill(id: 6, name: 'Финансовый анализ'),
      CatalogSkill(id: 7, name: 'Юридическая экспертиза'),
      CatalogSkill(id: 8, name: 'Редактирование текстов'),
    ];

    _isLoaded = true;
    notifyListeners();
  }
}
