class SponsorModel {
  final int id;
  final int categoryMasterId; // 🚀 Nayi field JSON se
  final String clientName;
  final String description;
  final String phoneNumber;
  final String? sponsorFile;
  final String sponsorProduct;
  final String? sponsorFilePath;
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
    required this.categoryMasterId,
    required this.clientName,
    required this.description,
    required this.phoneNumber,
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
      categoryMasterId: json["CategoryMasterId"] ?? 0, // 🚀 Nayi field mapped
      clientName: json["ClientName"] ?? "Unknown Client",
      description: json["Description"] ?? "",
      phoneNumber: json["PhoneNumber"] ?? "",
      sponsorFile: json["SponsorFile"], // null allowed
      sponsorProduct: json["SponsorProduct"] ?? "",
      sponsorFilePath: json["SponsorFilePath"], // null allowed
      sponsorType: json["SponsorType"] ?? "UNKNOWN",

      // 🚀 Date parsing with solid null safety
      startDate: json["StartDate"] != null ? DateTime.tryParse(json["StartDate"].toString()) : null,
      endDate: json["EndDate"] != null ? DateTime.tryParse(json["EndDate"].toString()) : null,
      createdOn: json["CreatedOn"] != null ? DateTime.tryParse(json["CreatedOn"].toString()) : null,
      updatedOn: json["UpdatedOn"] != null ? DateTime.tryParse(json["UpdatedOn"].toString()) : null,

      isActive: json["IsActive"] ?? false,
      createdBy: json["CreatedBy"] ?? "System",

      // 🚀 IMAGE LOGIC: Postman ke "h:\\root\\..." path ko clean web URL me convert karega
      cleanImageUrl: (json["SponsorFilePath"] != null && json["SponsorFilePath"].toString().isNotEmpty)
          ? _convertToImageUrl(json["SponsorFilePath"].toString())
          : null,
    );
  }

  // Backslashes (\) ko Forward slashes (/) me convert karne ka magic logic
  static String? _convertToImageUrl(String path) {
    if (path.isEmpty) return null;

    String normalizedPath = path.replaceAll(r"\", "/");

    // Aapki website ka actual domain
    String baseUrl = "https://gnwbazaar.in/apigateway";
    String finalUrl = "";

    // Exact folder dhundhne ka logic taaki server ka aage ka kachra (h:/root/..) hat jaye
    int sponsorIndex = normalizedPath.indexOf("/SponsorImage/");

    if (sponsorIndex != -1) {
      finalUrl = baseUrl + normalizedPath.substring(sponsorIndex);
    } else {
      // Fallback incase path format alag ho
      finalUrl = baseUrl + "/" + normalizedPath;
    }

    // Spaces ko %20 me convert karega warna Flutter image load nahi karega
    return finalUrl.replaceAll(" ", "%20");
  }
}