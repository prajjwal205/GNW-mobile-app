class DoctorModel {
  final int id;
  final String name;
  final int categoryId; // renamed properly
  final String qualification;
  final String aboutDoctor;
  final String email;
  final String location;
  final String address;
  final int experience;
  final String phoneNumber;
  final String whatsappNumber;
  final String? doctorImage;
  final String? clinicImage;
  final bool isActive;

  DoctorModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.qualification,
    required this.aboutDoctor,
    required this.email,
    required this.location,
    required this.address,
    required this.experience,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.isActive,
    this.doctorImage,
    this.clinicImage,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json["Id"] ?? 0,
      name: json["DoctorName"] ?? "Unknown Doctor",
      categoryId: json["HealthCareCategoryId"] ?? 0,
      qualification: json["Qualification"] ?? "",
      aboutDoctor: json["AboutDoctor"] ?? "",
      email: json["Email"] ?? "",
      location: json["Location"] ?? "Unknown",
      address: json["Address"] ?? "",
      experience: json["Experience"] ?? 0,
      phoneNumber: json["Phonenumber"] ?? "",
      whatsappNumber: json["WhatsAppNumber"] ?? "",
      doctorImage: (json["DoctorImagePath"] != null &&
          json["DoctorImagePath"].toString().isNotEmpty)
          ? _convertToImageUrl(json["DoctorImagePath"])
          : null,
      clinicImage: (json["ClinicImagePath"] != null &&
          json["ClinicImagePath"].toString().isNotEmpty)
          ? _convertToImageUrl(json["ClinicImagePath"])
          : null,
      isActive: json["IsActive"] ?? false,
    );
  }

  // convert server path to proper URL
  // convert server paths to proper URLs
  // convert server paths to proper URLs securely
  static String? _convertToImageUrl(String path) {
    if (path.isEmpty) return null;

    // 1. Change all Windows backslashes to Web forward slashes
    String normalizedPath = path.replaceAll(r"\", "/");
    String baseUrl = "http://gnwbazaar-002-site2.qtempurl.com";
    String finalUrl = "";

    // 2. Smart Extraction: Find where the public folder actually starts
    int docIndex = normalizedPath.indexOf("/DoctorImage/");
    int clinicIndex = normalizedPath.indexOf("/ClinicImage/");

    if (docIndex != -1) {
      finalUrl = baseUrl + normalizedPath.substring(docIndex);
    } else if (clinicIndex != -1) {
      finalUrl = baseUrl + normalizedPath.substring(clinicIndex);
    } else {
      // Fallback just in case
      finalUrl = normalizedPath;
    }

    // 3. CRITICAL FIX: Encode spaces in the file name!
    // "Screenshot 2026-01-07.png" becomes "Screenshot%202026-01-07.png"
    return finalUrl.replaceAll(" ", "%20");
  }
}