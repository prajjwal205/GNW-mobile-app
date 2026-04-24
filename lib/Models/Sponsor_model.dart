class SponsorResponseModel {
  final int responseCode;
  final String message;
  final List<SponsorModel> data;

  SponsorResponseModel({
    required this.responseCode,
    required this.message,
    required this.data,
  });

  factory SponsorResponseModel.fromJson(Map<String, dynamic> json) {
    return SponsorResponseModel(
      responseCode: json["ResponseCode"] ?? 500,
      message: json["Message"] ?? "Unknown Error",
      // Yahan hum JSON array ko Flutter List me convert kar rahe hain
      data: json["Value"] != null
          ? (json["Value"] as List).map((x) => SponsorModel.fromJson(x)).toList()
          : [],
    );
  }
}

// ==========================================
// 2. DATA MODEL (The Actual Data / Phone)
// ==========================================
class SponsorModel {
  final int id;
  final String clientName;
  final String description;
  final String phoneNumber;
  final String email;
  final String? sponsorFile;
  final String sponsorProduct;
  final String? sponsorFilePath; // Raw server path
  final String sponsorType;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final String createdBy;
  final DateTime? createdOn;
  final DateTime? updatedOn;

  // Custom field for UI: The final clean image URL
  final String? cleanImageUrl;

  SponsorModel({
    required this.id,
    required this.clientName,
    required this.description,
    required this.phoneNumber,
    required this.email,
    this.sponsorFile,
    required this.sponsorProduct,
    this.sponsorFilePath,
    required this.sponsorType,
    this.startDate,
    this.endDate,
    required this.isActive,
    required this.createdBy,
    this.createdOn,
    this.updatedOn,
    this.cleanImageUrl,
  });

  factory SponsorModel.fromJson(Map<String, dynamic> json) {
    return SponsorModel(
      id: json["Id"] ?? 0,
      clientName: json["ClientName"] ?? "Unknown Client",
      description: json["Description"] ?? "",
      phoneNumber: json["PhoneNumber"] ?? "",
      email: json["Email"] ?? "",
      sponsorFile: json["SponsorFile"], // Can be null
      sponsorProduct: json["SponsorProduct"] ?? "",
      sponsorFilePath: json["SponsorFilePath"],
      sponsorType: json["SponsorType"] ?? "UNKNOWN",

      // DateTime parsing with null safety
      startDate: json["StartDate"] != null ? DateTime.tryParse(json["StartDate"]) : null,
      endDate: json["EndDate"] != null ? DateTime.tryParse(json["EndDate"]) : null,
      createdOn: json["CreatedOn"] != null ? DateTime.tryParse(json["CreatedOn"]) : null,
      updatedOn: json["UpdatedOn"] != null ? DateTime.tryParse(json["UpdatedOn"]) : null,

      isActive: json["IsActive"] ?? false,
      createdBy: json["CreatedBy"] ?? "system",

      // 🚀 APKA IMAGE LOGIC: Same as DoctorModel, customized for Sponsors
      cleanImageUrl: (json["SponsorFilePath"] != null && json["SponsorFilePath"].toString().isNotEmpty)
          ? _convertToImageUrl(json["SponsorFilePath"])
          : null,
    );
  }

  // 🚀 IMAGE FETCH LOGIC EXPLANATION
  // Tumhara approach bilkul sahi tha! Backend "C:\\wwwroot\\SponsorImage\\..." jaisa path bhejta hai.
  // Flutter mobile me C drive access nahi kar sakta. Isliye hum us path ko kaat kar
  // uske aage apni website ka URL lagate hain.
  static String? _convertToImageUrl(String path) {
    if (path.isEmpty) return null;

    String normalizedPath = path.replaceAll(r"\", "/");
    String baseUrl = "http://gnwbazaar-002-site2.qtempurl.com"; // Tumhari website ka domain
    String finalUrl = "";

    // Sponsor images ke folder ka naam dhoondh rahe hain
    int sponsorIndex = normalizedPath.indexOf("/SponsorImage/");

    if (sponsorIndex != -1) {
      finalUrl = baseUrl + normalizedPath.substring(sponsorIndex);
    } else {
      finalUrl = baseUrl + "/" + normalizedPath;
    }

    return finalUrl.replaceAll(" ", "%20");
  }
}