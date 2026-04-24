class SubCategoryModel {
  final int id;
  final String categoryName;
  final int categoryMasterId;
  final String? createdOn;
  final String? updatedOn;

  SubCategoryModel({
    required this.id,
    required this.categoryName,
    required this.categoryMasterId,
    this.createdOn,
    this.updatedOn,
  });

  // Backend JSON ko Flutter Dart Object me convert karne ke liye
  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['Id'] ?? 0,
      categoryName: json['CategoryName'] ?? '',
      categoryMasterId: json['CategoryMasterId'] ?? 0,
      createdOn: json['CreatedOn'],
      updatedOn: json['UpdatedOn'],
    );
  }
}