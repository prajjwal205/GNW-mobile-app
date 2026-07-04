class ProfileResponseModel {
  final int responseCode;
  final String message;
  final UserModel? value; // Ise UserModel naam de diya for better clarity

  ProfileResponseModel({
    required this.responseCode,
    required this.message,
    this.value,
  });

  // JSON se Dart Object banane ke liye
  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      responseCode: json["ResponseCode"] ?? 0,
      message: json["Message"] ?? "",
      value: json["Value"] != null ? UserModel.fromJson(json["Value"]) : null,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String userRole;
  final bool isActive;
  final DateTime? lastLogin; // Nullable banaya safety ke liye
  final DateTime? createdOn;
  final DateTime? updatedOn;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.userRole,
    required this.isActive,
    this.lastLogin,
    this.createdOn,
    this.updatedOn,
  });

  // JSON keys ko exact match karwaya gaya hai
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["Id"] ?? 0,
      name: json["Name"] ?? "",
      email: json["Email"] ?? "",
      phoneNumber: json["PhoneNumber"] ?? "",
      password: json["Password"] ?? "",
      userRole: json["UserRole"] ?? "",
      isActive: json["IsActive"] ?? false,
      lastLogin: json["LastLogin"] != null ? DateTime.tryParse(json["LastLogin"]) : null,
      createdOn: json["CreatedOn"] != null ? DateTime.tryParse(json["CreatedOn"]) : null,
      updatedOn: json["UpdatedOn"] != null ? DateTime.tryParse(json["UpdatedOn"]) : null,
    );
  }
}