class ClientModel {
  final int id;
  final String clientName;
  final List<int> subCategoryIds;
  final String highlights;
  final String phoneNumber ;
  final String whatsappNumber;
  final String address;
  final String? locationUrl;
  final String? imagePath;
  final bool isActive;

  ClientModel({
    required this.id,
    required this.clientName,
    required this.subCategoryIds,
    required this.highlights,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.address,
    this.locationUrl,
    this.imagePath,
    required this.isActive,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['Id'] ?? 0,
      clientName: json['ClientName'] ?? '',
      subCategoryIds: List<int>.from(json['SubCategoryMasterIds'] ?? []),
      highlights: json['Highlights'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      whatsappNumber: json['WhatsAppNumber'] ?? 7800033272,
      address: json['Address'] ?? '',
      locationUrl: json['Location'],

      // 🚀 YAHAN PAR CONVERSION LAGA DIYA
      imagePath: (json['ClientImagePath'] != null && json['ClientImagePath'].toString().isNotEmpty)
          ? _convertToImageUrl(json['ClientImagePath'])
          : null,

      isActive: json['IsActive'] ?? false,
    );
  }

  // 🚀 NAYA FUNCTION CLIENT KE LIYE
  static String? _convertToImageUrl(String path) {
    if (path.isEmpty) return null;

    // 1. Slash badlo
    String normalizedPath = path.replaceAll(r"\", "/");
    String baseUrl = "http://gnwbazaar-002-site2.qtempurl.com";
    String finalUrl = "";

    // 2. Client Image ka folder dhoondo (Dhyan do: Yahan /ClientImage/ dhoondha hai)
    int clientIndex = normalizedPath.indexOf("/ClientImage/");

    if (clientIndex != -1) {
      finalUrl = baseUrl + normalizedPath.substring(clientIndex);
    } else {
      finalUrl = normalizedPath;
    }

    // 3. Space hatakar URL safe banao
    return finalUrl.replaceAll(" ", "%20");
  }
}