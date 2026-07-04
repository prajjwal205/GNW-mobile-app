// class DoctorModel {
//   final int id;
//   final String name;
//   final String qualification;
//   final String aboutDoctor;
//   final String email;
//   final String location;
//   final String address;
//   final int experience;
//   final String phoneNumber;
//   final String whatsappNumber;
//   final String? doctorImage;
//   final String? clinicImage;
//   final bool isActive;
//   final List<int> categoryIds;
//
//   //ye do value bad me update ki gyi hai
//   final DateTime? createdOn;
//   final DateTime? endDate;
//
//   DoctorModel({
//     required this.id,
//     required this.name,
//     required this.categoryIds,
//     required this.qualification,
//     required this.aboutDoctor,
//     required this.email,
//     required this.location,
//     required this.address,
//     required this.experience,
//     required this.phoneNumber,
//     required this.whatsappNumber,
//     required this.isActive,
//     this.doctorImage,
//     this.clinicImage,
//
//     required this.createdOn,
//     required this.endDate,
//   });
//
//   factory DoctorModel.fromJson(Map<String, dynamic> json) {
//     return DoctorModel(
//       id: json["Id"] ?? 0,
//       name: json["DoctorName"] ?? "Unknown Doctor",
//       qualification: json["Qualification"] ?? "",
//       aboutDoctor: json["AboutDoctor"] ?? "",
//       email: json["Email"] ?? "",
//       location: json["Location"] ?? "Unknown",
//       address: json["Address"] ?? "",
//       experience: json["Experience"] ?? 0,
//       phoneNumber: json["Phonenumber"] ?? "",
//       whatsappNumber: json["WhatsAppNumber"] ?? "",
//
//       categoryIds: (json["HealthCareCategoryIds"] as List?)
//           ?.map((e) => e as int)
//           .toList() ??
//           [],
//       doctorImage: (json["DoctorImagePath"] != null &&
//           json["DoctorImagePath"].toString().isNotEmpty)
//           ? _convertToImageUrl(json["DoctorImagePath"])
//           : null,
//       clinicImage: (json["ClinicImagePath"] != null &&
//           json["ClinicImagePath"].toString().isNotEmpty)
//           ? _convertToImageUrl(json["ClinicImagePath"])
//           : null,
//       isActive: json["IsActive"] ?? false,
//
//       createdOn: json["CreatedOn"] != null ? DateTime.tryParse(json["CreatedOn"]) : null,
//       endDate: json["EndDate"] != null ? DateTime.tryParse(json["EndDate"].toString()) : null,
//
//     );
//   }
//
//   static String? _convertToImageUrl(String path) {
//     if (path.isEmpty) return null;
//
//     // 1. Change all Windows backslashes to Web forward slashes
//     String normalizedPath = path.replaceAll(r"\", "/");
//     String baseUrl = "http://gnwbazaar-002-site2.qtempurl.com";
//     String finalUrl = "";
//
//     int docIndex = normalizedPath.indexOf("/DoctorImage/");
//     int clinicIndex = normalizedPath.indexOf("/ClinicImage/");
//
//     if (docIndex != -1) {
//       finalUrl = baseUrl + normalizedPath.substring(docIndex);
//     } else if (clinicIndex != -1) {
//       finalUrl = baseUrl + normalizedPath.substring(clinicIndex);
//     } else {
//       // Fallback just in case
//       finalUrl = normalizedPath;
//     }
//
//     return finalUrl.replaceAll(" ", "%20");
//   }
// }


class DoctorModel {
  final int id;
  final String name;
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
  final List<int> categoryIds;

  //ye do value bad me update ki gyi hai
  final DateTime? createdOn;
  final DateTime? endDate;

  DoctorModel({
    required this.id,
    required this.name,
    required this.categoryIds,
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

    required this.createdOn,
    required this.endDate,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json["Id"] ?? 0,
      name: json["DoctorName"] ?? "Unknown Doctor",
      qualification: json["Qualification"] ?? "",
      aboutDoctor: json["AboutDoctor"] ?? "",
      email: json["Email"] ?? "",
      location: json["Location"] ?? "Unknown",
      address: json["Address"] ?? "",
      experience: json["Experience"] ?? 0,
      phoneNumber: json["Phonenumber"] ?? "",
      whatsappNumber: json["WhatsAppNumber"] ?? "",

      categoryIds: (json["HealthCareCategoryIds"] as List?)
          ?.map((e) => e as int)
          .toList() ??
          [],
      doctorImage: (json["DoctorImagePath"] != null &&
          json["DoctorImagePath"].toString().isNotEmpty)
          ? _convertToImageUrl(json["DoctorImagePath"])
          : null,
      clinicImage: (json["ClinicImagePath"] != null &&
          json["ClinicImagePath"].toString().isNotEmpty)
          ? _convertToImageUrl(json["ClinicImagePath"])
          : null,
      isActive: json["IsActive"] ?? false,

      // 🚀 Yahan dono jagah .toString() laga diya taaki parsing safe rahe
      createdOn: json["CreatedOn"] != null ? DateTime.tryParse(json["CreatedOn"].toString()) : null,
      endDate: json["EndDate"] != null ? DateTime.tryParse(json["EndDate"].toString()) : null,
    );
  }

  // 🚀 BRAMHASTRA GETTER: Kisi bhi list ya search me filtering lagane ke liye
  bool get isValid {
    if (!isActive) return false;

    final DateTime now = DateTime.now();
    final String monthStr = now.month.toString().padLeft(2, '0');
    final String dayStr = now.day.toString().padLeft(2, '0');
    final int todayInt = int.parse("${now.year}$monthStr$dayStr");

    // 1. Start Date Check
    if (createdOn != null) {
      final String startMonth = createdOn!.month.toString().padLeft(2, '0');
      final String startDay = createdOn!.day.toString().padLeft(2, '0');
      final int startInt = int.parse("${createdOn!.year}$startMonth$startDay");
      if (todayInt < startInt) return false; // Future ka hai toh hide karo
    }

    // 2. End Date Check
    if (endDate != null && endDate!.year > 1) {
      final String endMonth = endDate!.month.toString().padLeft(2, '0');
      final String endDay = endDate!.day.toString().padLeft(2, '0');
      final int endInt = int.parse("${endDate!.year}$endMonth$endDay");
      if (todayInt > endInt) return false; // Expire ho gaya toh hide karo
    }

    return true; // Valid hai toh dikhao
  }

  static String? _convertToImageUrl(String path) {
    if (path.isEmpty) return null;

    // 1. Change all Windows backslashes to Web forward slashes
    String normalizedPath = path.replaceAll(r"\", "/");
    String baseUrl = "https://gnwbazaar.in/apigateway";
    String finalUrl = "";

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

    return finalUrl.replaceAll(" ", "%20");
  }
}