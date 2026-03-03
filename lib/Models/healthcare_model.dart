class HealthcareCategoryModel {
  final int id;
  final String category;

  HealthcareCategoryModel({required this.id, required this.category});

  factory HealthcareCategoryModel.fromJson(Map<String, dynamic> json) {
    return HealthcareCategoryModel(
      id: json['Id'] ?? 0,
      category: json['Category'] ?? 'Unknown',
    );
  }
}