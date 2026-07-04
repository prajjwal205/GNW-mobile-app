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

  final DateTime? CreatedOn;
  final DateTime? EndDate;


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
    required this.CreatedOn,
    required this.EndDate,
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
      CreatedOn: json["CreatedOn"] != null ? DateTime.tryParse(json["CreatedOn"]) : null,
      EndDate: json["EndDate"] != null ? DateTime.tryParse(json["EndDate"]) : null,
    );
  }

  // 🚀 NAYA FUNCTION CLIENT KE LIYE
  static String? _convertToImageUrl(String path) {
    if (path.isEmpty) return null;

    // 1. Slash badlo
    String normalizedPath = path.replaceAll(r"\", "/");
    String baseUrl = "https://gnwbazaar.in/apigateway";
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
  bool get isValid {
    if (!isActive) return false;

    final DateTime now = DateTime.now();
    final String monthStr = now.month.toString().padLeft(2, '0');
    final String dayStr = now.day.toString().padLeft(2, '0');
    final int todayInt = int.parse("${now.year}$monthStr$dayStr");

    // 1. Start Date Check
    if (CreatedOn != null) {
      final String startMonth = CreatedOn!.month.toString().padLeft(2, '0');
      final String startDay = CreatedOn!.day.toString().padLeft(2, '0');
      final int startInt = int.parse("${CreatedOn!.year}$startMonth$startDay");
      if (todayInt < startInt) return false;
    }

    // 2. End Date Check
    if (EndDate != null && EndDate!.year > 1) {
      final String endMonth = EndDate!.month.toString().padLeft(2, '0');
      final String endDay = EndDate!.day.toString().padLeft(2, '0');
      final int endInt = int.parse("${EndDate!.year}$endMonth$endDay");
      if (todayInt > endInt) return false;
    }

    return true;
  }
}