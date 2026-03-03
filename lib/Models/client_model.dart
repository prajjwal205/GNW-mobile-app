class ClientModel {
  final int id;
  final String clientName;
  final int categoryMasterId; // Important for filtering (Food vs Shopping)
  final String contactPerson;
  final String phoneNumber;
  final String email;
  final String address;
  final String location;
  final String? clientImage;
  final bool isActive;

  ClientModel({
    required this.id,
    required this.clientName,
    required this.categoryMasterId,
    required this.contactPerson,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.location,
    this.clientImage,
    required this.isActive,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['Id'] ?? 0,
      clientName: json['ClientName'] ?? 'Unknown',
      categoryMasterId: json['CategoryMasterId'] ?? 0,
      contactPerson: json['ContactPerson'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      email: json['Email'] ?? '',
      address: json['Address'] ?? '',
      location: json['Location'] ?? '',
      clientImage: json['ClientImage'],
      isActive: json['IsActive'] ?? false,
    );
  }
}