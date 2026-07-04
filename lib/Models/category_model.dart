class CategoryModel {
  final int id;
  final String categoryName;

  CategoryModel({
    required this.id,
    required this.categoryName,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['Id'] ?? 0,
      categoryName: json['CategoryName'] ?? 'Unknown',
    );
  }
}