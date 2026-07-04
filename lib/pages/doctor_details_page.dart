// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gnw/Models/doctor_model.dart';
// import 'package:gnw/services/auth_provider.dart';
// import '../widget/customAppBar.dart';
// import '../utils/responsive_helper.dart';
// import '../widget/doctor_image_header.dart';
// import '../widget/doctor_contact_info.dart';
// import '../widget/doctor_call_button.dart';
//
// final doctorListProvider = FutureProvider.family.autoDispose<List<DoctorModel>, int>((ref, categoryId) async {
//   final allDoctors = await AuthService.fetchDoctor();
//
//   // 🚀 Aaj ki date ko pure NUMBER me convert kar rahe hain (e.g., 20260519)
//   final DateTime now = DateTime.now();
//   final String monthStr = now.month.toString().padLeft(2, '0');
//   final String dayStr = now.day.toString().padLeft(2, '0');
//   final int todayInt = int.parse("${now.year}$monthStr$dayStr");
//
//   final filteredDoctors = allDoctors.where((doc) {
//     if (!doc.categoryIds.contains(categoryId)) return false;
//     if (!doc.isActive) return false;
//
//     // Start Date Check
//     if (doc.createdOn != null) {
//       final String startMonth = doc.createdOn!.month.toString().padLeft(2, '0');
//       final String startDay = doc.createdOn!.day.toString().padLeft(2, '0');
//       final int startInt = int.parse("${doc.createdOn!.year}$startMonth$startDay");
//
//       if (todayInt < startInt) return false; // Agar future ki date hai toh hide karo
//     }
//
//     // End Date Check
//     if (doc.endDate != null && doc.endDate!.year > 1) {
//       final String endMonth = doc.endDate!.month.toString().padLeft(2, '0');
//       final String endDay = doc.endDate!.day.toString().padLeft(2, '0');
//       final int endInt = int.parse("${doc.endDate!.year}$endMonth$endDay");
//
//       // 🚀 DEBUG KELIYE PRINT (Terminal me zaroor check karna)
//       print("DOCTOR: ${doc.name} | Today($todayInt) > EndDate($endInt) = ${todayInt > endInt}");
//
//       // Agar aaj ka number End date ke number se bada hai (e.g., 20260519 > 20260503)
//       if (todayInt > endInt) {
//         return false; // HIDE KAR DO!
//       }
//     }
//
//     return true;
//   }).toList();
//
//   filteredDoctors.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
//   return filteredDoctors;
// });
//
// class DoctorListPage extends ConsumerStatefulWidget {
//   final String categoryName;
//   final int categoryId;
//
//   const DoctorListPage({
//     super.key,
//     required this.categoryName,
//     required this.categoryId,
//   });
//
//   @override
//   ConsumerState<DoctorListPage> createState() => _DoctorListPageState();
// }
//
// class _DoctorListPageState extends ConsumerState<DoctorListPage> {
//   final PageController _pageController = PageController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final doctorAsync = ref.watch(doctorListProvider(widget.categoryId));
//
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
//         body: doctorAsync.when(
//           loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
//           error: (error, stack) => Center(child: Text('Error: $error')),
//           data: (doctorList) {
//             if (doctorList.isEmpty) {
//               return Center(child: Text("No listings available yet", style: const TextStyle(fontSize: 15, color: Colors.red)));
//             }
//
//             return PageView.builder(
//               controller: _pageController,
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               itemCount: doctorList.length,
//               itemBuilder: (context, index) {
//                 final doctor = doctorList[index];
//                 return SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 10, bottom: 40),
//                     child: DoctorDetailBlock(
//                       doctor: doctor,
//                       index: index,
//                       totalCount: doctorList.length,
//                       pageController: _pageController,
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// class DoctorDetailBlock extends StatelessWidget {
//   final DoctorModel doctor;
//   final int index;
//   final int totalCount;
//   final PageController pageController;
//
//   const DoctorDetailBlock({
//     super.key,
//     required this.doctor,
//     required this.index,
//     required this.totalCount,
//     required this.pageController,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     double wScale = MediaQuery.of(context).size.width / 390.0;
//     double spaceMed = 12 * wScale;
//     double spaceLarge = 16 * wScale;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         DoctorImageHeader(doctor: doctor, index: index, totalCount: totalCount, pageController: pageController, wScale: wScale),
//
//         DoctorContactInfo(doctor: doctor, wScale: wScale),
//         SizedBox(height: spaceMed * 0.4),
//
//         DoctorCallButton(doctor: doctor, wScale: wScale),
//         SizedBox(height: spaceMed * 0.6),
//
//         // 🚀🚀 YEH 3 LINE ADD KARO (Test karne ke liye) 🚀🚀
//         Center(
//           child: Text(
//             "DEBUG END DATE: ${doctor.endDate}",
//             style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//
//         Center(
//           child: Text(
//             "DEBUG TODAY: ${DateTime.now()}",
//             style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//         SizedBox(height: spaceMed * 0.6),
//         SizedBox(height: spaceMed * 0.6),
//
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: spaceLarge),
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(vertical: 4 * wScale),
//           decoration: BoxDecoration(color: const Color(0xFFFFA726), borderRadius: BorderRadius.circular(30 * wScale)),
//           alignment: Alignment.center,
//           child: Text("HIGHLIGHTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13 * wScale)),
//         ),
//         Padding(
//           padding: EdgeInsets.only(left: spaceLarge, right: spaceLarge, top: 10 * wScale, bottom: spaceLarge),
//           child: Text(
//             doctor.aboutDoctor.isNotEmpty ? doctor.aboutDoctor : "No details available.",
//             textAlign: TextAlign.justify,
//             style: TextStyle(fontSize: 13 * wScale, height: 1.2, color: Colors.black87),
//           ),
//         ),
//       ],
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/doctor_model.dart';
import 'package:gnw/services/auth_provider.dart';
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';
import '../widget/doctor_image_header.dart';
import '../widget/doctor_contact_info.dart';
import '../widget/doctor_call_button.dart';

// Base provider simple rakha hai, filter hum ab UI par handle karenge
final doctorListProvider = FutureProvider.family.autoDispose<List<DoctorModel>, int>((ref, categoryId) async {
  final allDoctors = await AuthService.fetchDoctor();
  return allDoctors;
});

class DoctorListPage extends ConsumerStatefulWidget {
  final String categoryName;
  final int categoryId;

  const DoctorListPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  ConsumerState<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends ConsumerState<DoctorListPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doctorAsync = ref.watch(doctorListProvider(widget.categoryId));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
        body: doctorAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (doctorList) {
            // 🚀 BRAHMASTRA FILTER: UI render hone se theek pehle live filter
            final DateTime now = DateTime.now();
            final String monthStr = now.month.toString().padLeft(2, '0');
            final String dayStr = now.day.toString().padLeft(2, '0');
            final int todayInt = int.parse("${now.year}$monthStr$dayStr");

            final List<DoctorModel> validDoctors = doctorList.where((doc) {
              // 1. Category and active state filtering
              if (!doc.categoryIds.contains(widget.categoryId)) return false;
              // if (!doc.isActive) return false;

              // 2. Start Date (CreatedOn) Check
              if (doc.createdOn != null) {
                final String startMonth = doc.createdOn!.month.toString().padLeft(2, '0');
                final String startDay = doc.createdOn!.day.toString().padLeft(2, '0');
                final int startInt = int.parse("${doc.createdOn!.year}$startMonth$startDay");
                if (todayInt < startInt) return false;
              }

              // 3. End Date Check
              if (doc.endDate != null && doc.endDate!.year > 1) {
                final String endMonth = doc.endDate!.month.toString().padLeft(2, '0');
                final String endDay = doc.endDate!.day.toString().padLeft(2, '0');
                final int endInt = int.parse("${doc.endDate!.year}$endMonth$endDay");

                // Agar aaj ki date End Date se badi hai (Expired), toh nikal do
                if (todayInt > endInt) return false;
              }

              return true;
            }).toList();

            // Alphabetical Order mein sort kar rahe hain
            validDoctors.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

            // Agar saare filter hone ke baad list khali bachti hai
            if (validDoctors.isEmpty) {
              return Center(
                child: Text(
                  "No listings available yet for ${widget.categoryName}",
                  style: const TextStyle(fontSize: 15, color: Colors.red),
                ),
              );
            }

            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: validDoctors.length,
              itemBuilder: (context, index) {
                final doctor = validDoctors[index];
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: DoctorDetailBlock(
                      doctor: doctor,
                      index: index,
                      totalCount: validDoctors.length,
                      pageController: _pageController,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class DoctorDetailBlock extends StatelessWidget {
  final DoctorModel doctor;
  final int index;
  final int totalCount;
  final PageController pageController;

  const DoctorDetailBlock({
    super.key,
    required this.doctor,
    required this.index,
    required this.totalCount,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    double wScale = MediaQuery.of(context).size.width / 390.0;
    double spaceMed = 12 * wScale;
    double spaceLarge = 16 * wScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DoctorImageHeader(doctor: doctor, index: index, totalCount: totalCount, pageController: pageController, wScale: wScale),
        DoctorContactInfo(doctor: doctor, wScale: wScale),
        SizedBox(height: spaceMed * 0.4),
        DoctorCallButton(doctor: doctor, wScale: wScale),
        SizedBox(height: spaceMed * 0.6),

        // 🚀 Debug lines ko clean rakha hai, ab iski zaroorat nahi padegi kyuki logic 100% chalega
        Container(
          margin: EdgeInsets.symmetric(horizontal: spaceLarge),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4 * wScale),
          decoration: BoxDecoration(color: const Color(0xFFFFA726), borderRadius: BorderRadius.circular(30 * wScale)),
          alignment: Alignment.center,
          child: Text("HIGHLIGHTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13 * wScale)),
        ),
        Padding(
          padding: EdgeInsets.only(left: spaceLarge, right: spaceLarge, top: 10 * wScale, bottom: spaceLarge),
          child: Text(
            doctor.aboutDoctor.isNotEmpty ? doctor.aboutDoctor : "No details available.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 13 * wScale, height: 1.2, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}