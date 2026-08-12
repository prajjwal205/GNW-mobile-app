// // // File: lib/widget/search_dropdown_items.dart
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../Models/client_model.dart';
// // import '../Models/doctor_model.dart';
// // import '../Models/healthcare_model.dart';
// // import '../Models/SubCategoryModel.dart';
// // import '../providers/search_provider.dart'; // Apna naya provider import karo
// //
// // // 🚀 1. SUB-CATEGORY CLIENTS LIST
// // class SubCategoryClientsList extends ConsumerWidget {
// //   final SubCategoryModel subCategory;
// //   final double wScale;
// //   final Function(Object) onTap;
// //
// //   const SubCategoryClientsList({super.key, required this.subCategory, required this.wScale, required this.onTap});
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final data = ref.read(allSearchDataProvider).value;
// //     if (data == null) return const SizedBox();
// //
// //     final allClients = data["clients"] as List<ClientModel>;
// //     final subCatClients = allClients.where((c) => c.subCategoryIds.contains(subCategory.id) && c.isValid).toList();
// //
// //     if (subCatClients.isEmpty) {
// //       return Padding(
// //         padding: EdgeInsets.only(bottom: 12 * wScale, left: 38 * wScale),
// //         child: Align(
// //           alignment: Alignment.centerLeft,
// //           child: Text("No listings here", style: TextStyle(fontSize: 12 * wScale, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 8 * wScale),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50,
// //         borderRadius: BorderRadius.circular(12 * wScale),
// //         border: Border.all(color: Colors.grey.shade200, width: 1),
// //       ),
// //       child: Column(
// //         children: subCatClients.asMap().entries.map((entry) {
// //           final index = entry.key;
// //           final client = entry.value;
// //           return Column(
// //             children: [
// //               InkWell(
// //                 onTap: () => onTap(client), // Jab click ho toh main file me handle hoga
// //                 borderRadius: BorderRadius.circular(12 * wScale),
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: Text(
// //                           client.clientName,
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: TextStyle(fontSize: 13 * wScale, fontWeight: FontWeight.w600, color: Colors.black87),
// //                         ),
// //                       ),
// //                       Icon(Icons.arrow_forward_ios, size: 12 * wScale, color: Colors.grey.shade400),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               if (index != subCatClients.length - 1)
// //                 Divider(height: 1, indent: 16 * wScale, endIndent: 16 * wScale, color: Colors.grey.shade200),
// //             ],
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
// // }
// //
// // // 🚀 2. HEALTHCARE DOCTORS LIST
// // class HealthcareDoctorsList extends ConsumerWidget {
// //   final HealthcareCategoryModel healthCat;
// //   final double wScale;
// //   final Function(Object) onTap;
// //
// //   const HealthcareDoctorsList({super.key, required this.healthCat, required this.wScale, required this.onTap});
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final data = ref.read(allSearchDataProvider).value;
// //     if (data == null) return const SizedBox();
// //
// //     final allDoctors = data["doctors"] as List<DoctorModel>;
// // // ✅ CORRECT (Ise use karo)
// //     final categoryDoctors = allDoctors.where((d) => d.categoryIds.contains(healthCat.id) && d.isValid).toList();
// //
// //     if (categoryDoctors.isEmpty) {
// //       return Padding(
// //         padding: EdgeInsets.only(bottom: 12 * wScale, left: 38 * wScale),
// //         child: Align(
// //           alignment: Alignment.centerLeft,
// //           child: Text("No doctors available",
// //               style: TextStyle(fontSize: 12 * wScale, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 8 * wScale),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade50, // 🚀 Same grey background
// //         borderRadius: BorderRadius.circular(12 * wScale),
// //         border: Border.all(color: Colors.grey.shade300, width: 1),
// //       ),
// //       child: Column(
// //         children: categoryDoctors.asMap().entries.map((entry) {
// //           final index = entry.key;
// //           final doctor = entry.value;
// //           return Column(
// //             children: [
// //               InkWell(
// //                 onTap: () => onTap(doctor),
// //                 borderRadius: BorderRadius.circular(12 * wScale),
// //                 child: Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
// //                   child: Row(
// //                     children: [
// //                       Expanded(
// //                         child: Text(
// //                           "${doctor.name}",
// //                           maxLines: 1,
// //                           overflow: TextOverflow.ellipsis,
// //                           style: TextStyle(fontSize: 13 * wScale, fontWeight: FontWeight.w600, color: Colors.black87),
// //                         ),
// //                       ),
// //                       Icon(Icons.arrow_forward_ios, size: 12 * wScale, color: Colors.grey.shade500),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               if (index != categoryDoctors.length - 1)
// //                 Divider(height: 1, indent: 16 * wScale, endIndent: 16 * wScale, color: Colors.grey.shade300),
// //             ],
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }
// // }
//
//
//
// // File: lib/widget/search_dropdown_items.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../Models/client_model.dart';
// import '../Models/doctor_model.dart';
// import '../Models/healthcare_model.dart';
// import '../Models/SubCategoryModel.dart';
// import '../providers/search_provider.dart';
//
// // 🚀 1. SUB-CATEGORY CLIENTS LIST
// class SubCategoryClientsList extends ConsumerWidget {
//   final SubCategoryModel subCategory;
//   final double wScale;
//   final Function(Object) onTap;
//
//   const SubCategoryClientsList({super.key, required this.subCategory, required this.wScale, required this.onTap});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.read(allSearchDataProvider).value;
//     if (data == null) return const SizedBox();
//
//     final allClients = data["clients"] as List<ClientModel>;
//     final subCatClients = allClients.where((c) => c.subCategoryIds.contains(subCategory.id) && c.isValid).toList();
//
//     // 🚀 ALPHABETICAL SORTING LOGIC FOR CLIENTS
//     subCatClients.sort((a, b) => a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase()));
//
//     if (subCatClients.isEmpty) {
//       return Padding(
//         padding: EdgeInsets.only(bottom: 12 * wScale, left: 38 * wScale),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text("No listings here", style: TextStyle(fontSize: 12 * wScale, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
//         ),
//       );
//     }
//
//     return Container(
//       margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 8 * wScale),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12 * wScale),
//         border: Border.all(color: Colors.grey.shade200, width: 1),
//       ),
//       child: Column(
//         children: subCatClients.asMap().entries.map((entry) {
//           final index = entry.key;
//           final client = entry.value;
//           return Column(
//             children: [
//               InkWell(
//                 onTap: () => onTap(client),
//                 borderRadius: BorderRadius.circular(12 * wScale),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           client.clientName,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(fontSize: 13 * wScale, fontWeight: FontWeight.w600, color: Colors.black87),
//                         ),
//                       ),
//                       Icon(Icons.arrow_forward_ios, size: 12 * wScale, color: Colors.grey.shade400),
//                     ],
//                   ),
//                 ),
//               ),
//               if (index != subCatClients.length - 1)
//                 Divider(height: 1, indent: 16 * wScale, endIndent: 16 * wScale, color: Colors.grey.shade200),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// // 🚀 2. HEALTHCARE DOCTORS LIST
// class HealthcareDoctorsList extends ConsumerWidget {
//   final HealthcareCategoryModel healthCat;
//   final double wScale;
//   final Function(Object) onTap;
//
//   const HealthcareDoctorsList({super.key, required this.healthCat, required this.wScale, required this.onTap});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.read(allSearchDataProvider).value;
//     if (data == null) return const SizedBox();
//
//     final allDoctors = data["doctors"] as List<DoctorModel>;
//     final categoryDoctors = allDoctors.where((d) => d.categoryIds.contains(healthCat.id) && d.isValid).toList();
//
//     // 🚀 ALPHABETICAL SORTING LOGIC FOR DOCTORS
//     categoryDoctors.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
//
//     if (categoryDoctors.isEmpty) {
//       return Padding(
//         padding: EdgeInsets.only(bottom: 12 * wScale, left: 38 * wScale),
//         child: Align(
//           alignment: Alignment.centerLeft,
//           child: Text("No doctors available",
//               style: TextStyle(fontSize: 12 * wScale, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
//         ),
//       );
//     }
//
//     return Container(
//       margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 8 * wScale),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12 * wScale),
//         border: Border.all(color: Colors.grey.shade300, width: 1),
//       ),
//       child: Column(
//         children: categoryDoctors.asMap().entries.map((entry) {
//           final index = entry.key;
//           final doctor = entry.value;
//           return Column(
//             children: [
//               InkWell(
//                 onTap: () => onTap(doctor),
//                 borderRadius: BorderRadius.circular(12 * wScale),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           "${doctor.name}",
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(fontSize: 13 * wScale, fontWeight: FontWeight.w600, color: Colors.black87),
//                         ),
//                       ),
//                       Icon(Icons.arrow_forward_ios, size: 12 * wScale, color: Colors.grey.shade500),
//                     ],
//                   ),
//                 ),
//               ),
//               if (index != categoryDoctors.length - 1)
//                 Divider(height: 1, indent: 16 * wScale, endIndent: 16 * wScale, color: Colors.grey.shade300),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }




// File: lib/widget/search_dropdown_items.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Models/client_model.dart';
import '../Models/doctor_model.dart';
import '../Models/healthcare_model.dart';
import '../Models/SubCategoryModel.dart';
import '../providers/search_provider.dart';

// 🚀 1. SUB-CATEGORY CLIENTS LIST
class SubCategoryClientsList extends ConsumerWidget {
  final SubCategoryModel subCategory;
  final double wScale;
  final Function(Object) onTap;

  const SubCategoryClientsList({super.key, required this.subCategory, required this.wScale, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.read(allSearchDataProvider).value;
    if (data == null) return const SizedBox();

    final allClients = data["clients"] as List<ClientModel>;
    final subCatClients = allClients.where((c) => c.subCategoryIds.contains(subCategory.id) && c.isValid).toList();

    // ALPHABETICAL SORTING LOGIC FOR CLIENTS
    subCatClients.sort((a, b) => a.clientName.toLowerCase().compareTo(b.clientName.toLowerCase()));

    if (subCatClients.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12 * wScale, left: 38 * wScale),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("No listings here", style: TextStyle(fontSize: 12 * wScale, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 8 * wScale),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12 * wScale),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        children: subCatClients.asMap().entries.map((entry) {
          final index = entry.key;
          final client = entry.value;
          return Column(
            children: [
              InkWell(
                // 🚀 YAHAN CHANGE HAI: List aur Item dono bhej rahe hain
                onTap: () => onTap({
                  "isFromDropdown": true,
                  "item": client,
                  "list": subCatClients
                }),
                borderRadius: BorderRadius.circular(12 * wScale),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          client.clientName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13 * wScale, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 12 * wScale, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
              if (index != subCatClients.length - 1)
                Divider(height: 1, indent: 16 * wScale, endIndent: 16 * wScale, color: Colors.grey.shade200),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// 🚀 2. HEALTHCARE DOCTORS LIST
class HealthcareDoctorsList extends ConsumerWidget {
  final HealthcareCategoryModel healthCat;
  final double wScale;
  final Function(Object) onTap;

  const HealthcareDoctorsList({super.key, required this.healthCat, required this.wScale, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.read(allSearchDataProvider).value;
    if (data == null) return const SizedBox();

    final allDoctors = data["doctors"] as List<DoctorModel>;
    final categoryDoctors = allDoctors.where((d) => d.categoryIds.contains(healthCat.id) && d.isValid).toList();

    // ALPHABETICAL SORTING LOGIC FOR DOCTORS
    categoryDoctors.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    if (categoryDoctors.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12 * wScale, left: 38 * wScale),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("No doctors available",
              style: TextStyle(fontSize: 12 * wScale, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 8 * wScale),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12 * wScale),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        children: categoryDoctors.asMap().entries.map((entry) {
          final index = entry.key;
          final doctor = entry.value;
          return Column(
            children: [
              InkWell(
                // 🚀 YAHAN CHANGE HAI: List aur Item dono bhej rahe hain
                onTap: () => onTap({
                  "isFromDropdown": true,
                  "item": doctor,
                  "list": categoryDoctors
                }),
                borderRadius: BorderRadius.circular(12 * wScale),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16 * wScale, vertical: 10 * wScale),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${doctor.name}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13 * wScale, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 12 * wScale, color: Colors.grey.shade500),
                    ],
                  ),
                ),
              ),
              if (index != categoryDoctors.length - 1)
                Divider(height: 1, indent: 16 * wScale, endIndent: 16 * wScale, color: Colors.grey.shade300),
            ],
          );
        }).toList(),
      ),
    );
  }
}