class CategoryModel {
  final int id;
  final String categoryName;

  CategoryModel({
    required this.id,
    required this.categoryName,
  });

  // Factory constructor to convert JSON Data -> Dart Object
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      // We use '?? 0' or '?? ""' to prevent crashes if data is missing
      id: json['Id'] ?? 0,
      categoryName: json['CategoryName'] ?? 'Unknown',
    );
  }
}