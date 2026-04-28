class CatalogSubject {
  final int id;
  final String name;
  final String? description;
  final int topicsCount;

  CatalogSubject({required this.id, required this.name, this.description, this.topicsCount = 0});

  factory CatalogSubject.fromJson(Map<String, dynamic> json) => CatalogSubject(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    description: json['description'] as String?,
    topicsCount: json['topics_count'] as int? ?? 0,
  );
}

class CatalogTopic {
  final int id;
  final String name;
  final int subjectId;

  CatalogTopic({required this.id, required this.name, required this.subjectId});

  factory CatalogTopic.fromJson(Map<String, dynamic> json) => CatalogTopic(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    subjectId: json['subject_id'] as int? ?? json['subject'] as int? ?? 0,
  );
}

class WorkType {
  final int id;
  final String name;
  final double? basePrice;

  WorkType({required this.id, required this.name, this.basePrice});

  factory WorkType.fromJson(Map<String, dynamic> json) => WorkType(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    basePrice: (json['base_price'] as num?)?.toDouble(),
  );
}

class ComplexityLevel {
  final int id;
  final String name;
  final double multiplier;

  ComplexityLevel({required this.id, required this.name, this.multiplier = 1.0});

  factory ComplexityLevel.fromJson(Map<String, dynamic> json) => ComplexityLevel(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
  );
}

class CatalogCategory {
  final int id;
  final String name;
  final String? icon;

  CatalogCategory({required this.id, required this.name, this.icon});

  factory CatalogCategory.fromJson(Map<String, dynamic> json) => CatalogCategory(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    icon: json['icon'] as String?,
  );
}

class CatalogSkill {
  final int id;
  final String name;

  CatalogSkill({required this.id, required this.name});

  factory CatalogSkill.fromJson(Map<String, dynamic> json) => CatalogSkill(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
  );
}
