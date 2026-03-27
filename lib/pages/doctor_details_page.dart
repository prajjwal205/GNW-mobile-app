// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:gnw/Models/doctor_model.dart';
// import 'package:gnw/services/auth_provider.dart';
// import '../widget/FullScreenImageViewer.dart';
// import '../widget/customAppBar.dart';
// import '../utils/responsive_helper.dart';
//
//
// final userNameProvider = FutureProvider.autoDispose<String>((ref) async {
//   return await AuthService.fetchUserName();
// });
//
// final doctorListProvider = FutureProvider.family.autoDispose<List<DoctorModel>, int>((ref, categoryId) async {
//   final allDoctors = await AuthService.fetchDoctor();
//   return allDoctors
//       .where((doc) => doc.categoryIds.contains(categoryId))
//       .toList();});
//
// // 2. DOCTOR LIST PAGE
//
// class DoctorListPage extends ConsumerWidget {
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
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userAsync = ref.watch(userNameProvider);
//     final doctorAsync = ref.watch(doctorListProvider(categoryId));
//     final String userName = userAsync.value ?? "User";
//
//     // 1. CRITICAL FIX: Lock the text scaling so the client's huge OS font doesn't break the app
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(
//         textScaler: const TextScaler.linear(1.0),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: buildCustomAppBar(
//           context,
//           userName,
//           ResponsiveHelper.getAppBarHeight(context),
//         ),
//         body: doctorAsync.when(
//           loading: () => const Center(child: CircularProgressIndicator()),
//           error: (error, stack) => Center(child: Text('Error: $error')),
//           data: (doctorList) {
//             if (doctorList.isEmpty) {
//               return Center(
//                 child: Text(
//                   "No Doctors Added in  $categoryName",
//                   style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.red),
//                 ),
//               );
//             }
//
//             return ListView.separated(
//               padding: const EdgeInsets.only(top: 0, bottom: 20),
//               itemCount: doctorList.length,
//               separatorBuilder: (context, index) => Container(
//                 height: 12, // The divider between doctors
//                 color: Colors.grey.shade200,
//               ),
//               itemBuilder: (context, index) {
//                 final doctor = doctorList[index];
//                 return DoctorDetailBlock(doctor: doctor);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // 3. DOCTOR DETAIL BLOCK (Fully Responsive)
//
// class DoctorDetailBlock extends StatelessWidget {
//   final DoctorModel doctor;
//
//   const DoctorDetailBlock({super.key, required this.doctor});
//
//   Future<void> _callNumber(BuildContext context, String number) async {
//     if (number.isEmpty) return;
//     final Uri uri = Uri(scheme: 'tel', path: number);
//     if (!await launchUrl(uri)) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not call $number")));
//     }
//   }
//
//   Future<void> _openWhatsapp(BuildContext context, String number, {String message=" "}) async {
//     if (number.isEmpty) return;
//     String formatted = number.replaceAll(" ", "").replaceAll("+91", "");
//     String encodedMessage = Uri.encodeComponent(message);
//     final Uri uri = Uri.parse("https://wa.me/91$formatted?text=$encodedMessage");
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open WhatsApp")));
//       }
//     }
//   }
//
//   Future<void> _openMap(BuildContext context, String address) async {
//     if (address.isEmpty) return;
//     final Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open Maps")));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 2. CRITICAL FIX: Calculate scale multiplier based on screen width
//     double width = MediaQuery.of(context).size.width;
//     // We assume 390 is a standard medium phone width. Everything scales from this.
//     double wScale = width / 390.0;
//
//     // Dynamic Fonts
//     double titleFont = 20 * wScale;
//     double subtitleFont = 13 * wScale;
//     double smallFont = 11 * wScale;
//     double tinyFont = 10 * wScale;
//
//     // Dynamic Spacing
//     double spaceSmall = 6 * wScale;
//     double spaceMed = 12 * wScale;
//     double spaceLarge = 16 * wScale;
//
//     final imageProvider = (doctor.clinicImage != null && doctor.clinicImage!.isNotEmpty)
//         ? NetworkImage(doctor.clinicImage!)
//         : (doctor.doctorImage != null && doctor.doctorImage!.isNotEmpty)
//         ? NetworkImage(doctor.doctorImage!)
//         : const AssetImage('lib/images/sample.jpeg') as ImageProvider;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 1. POSTER IMAGE SECTION
//         Container(
//           margin: EdgeInsets.only(left: spaceMed, right: spaceMed, top: spaceMed, bottom: spaceSmall),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(14 * wScale),
//             border: Border.all(color: Colors.grey.shade300),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(14 * wScale),
//             child: Column(
//               children: [
//                 Container(
//                   color: Colors.white,
//                   child: GestureDetector(
//                     onTap: () {
//                       // Opens the Full Screen Viewer when tapped
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FullScreenImageViewer(
//                             imageProvider: imageProvider,
//                             heroTag: doctor.name, imageUrl: '',
//                           ),
//                         ),
//                       );
//                     },
//                     // Hero creates the smooth flying animation between screens
//                     // Hero creates the smooth flying animation between screens
//                     child: Hero(
//                       tag: doctor.name,
//                       child: Image(
//                         image: imageProvider,
//                         width: double.infinity,
//                         fit: BoxFit.fitWidth,
//
//                         // ==========================================
//                         // NEW: SHOWS LOADING SPINNER WHILE FETCHING
//                         // ==========================================
//                         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                           if (loadingProgress == null) {
//                             // Image is fully loaded, show the image
//                             return child;
//                           }
//                           // Image is still loading, show a spinner
//                           return Container(
//                             height: 350 * wScale, // Keeps the layout from jumping
//                             color: Colors.grey.shade100,
//                             child: Center(
//                               child: CircularProgressIndicator(
//                                 color: const Color(0xFFFFA726), // App's orange theme color
//                                 value: loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                                     : null,
//                               ),
//                             ),
//                           );
//                         },
//
//                         // Shows a hospital icon if the URL is broken
//                         errorBuilder: (c, o, s) => Container(
//                             height: 350 * wScale,
//                             color: Colors.grey[200],
//                             child: Icon(Icons.local_hospital, size: 50 * wScale)
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Container(
//                 //   width: double.infinity,
//                 //   padding: EdgeInsets.symmetric(vertical: spaceSmall, horizontal: 10 * wScale),
//                 //   decoration: const BoxDecoration(
//                 //     gradient: LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFFD81B60)]),
//                 //   ),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       Text(
//                 //         "Book your\nAppointment today!",
//                 //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: smallFont),
//                 //       ),
//                 //       InkWell(
//                 //         onTap: () => _callNumber(context, doctor.phoneNumber),
//                 //         child: Container(
//                 //           padding: EdgeInsets.symmetric(horizontal: spaceSmall, vertical: 4 * wScale),
//                 //           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20 * wScale)),
//                 //           child: Row(
//                 //             children: [
//                 //               Icon(Icons.call, size: 12 * wScale, color: const Color(0xFFD81B60)),
//                 //               SizedBox(width: 4 * wScale),
//                 //               Text(
//                 //                 doctor.phoneNumber,
//                 //                 style: TextStyle(color: const Color(0xFFD81B60), fontWeight: FontWeight.bold, fontSize: tinyFont),
//                 //               ),
//                 //             ],
//                 //           ),
//                 //         ),
//                 //       )
//                 //     ],
//                 //   ),
//                 // ),
//                 // Container(
//                 //   width: double.infinity,
//                 //   padding: EdgeInsets.symmetric(vertical: 4 * wScale, horizontal: 10 * wScale),
//                 //   color: const Color(0xFFD81B60),
//                 //   child: Row(
//                 //     children: [
//                 //       Icon(Icons.email, color: Colors.white, size: 10 * wScale),
//                 //       SizedBox(width: 4 * wScale),
//                 //       Expanded(child: Text(doctor.email, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: tinyFont))),
//                 //       Icon(Icons.location_on, color: Colors.white, size: 10 * wScale),
//                 //       SizedBox(width: 4 * wScale),
//                 //       Expanded(child: Text(doctor.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: tinyFont))),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//
//         // ==============================
//         // 2. TITLE & WHATSAPP ICON
//         // ==============================
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: spaceLarge),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(
//                   doctor.name,
//                   style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.bold, height: 1.2),
//                 ),
//               ),
//               SizedBox(width: spaceMed),
//               GestureDetector(
//                 onTap: () => _openWhatsapp(
//                   context,
//                   doctor.whatsappNumber.isNotEmpty ? doctor.whatsappNumber : doctor.phoneNumber,
//                   message: "Hi *${doctor.name}*, I found your business on GNW Bazaar. I would like to know more details.",
//                 ),
//                 child: SvgPicture.asset(
//                   "lib/icons/whatsapp.svg",
//                   height: 38 * wScale,
//                   width: 38 * wScale,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         SizedBox(height: 10 * wScale),
//
//         // ==============================
//         // 3. ADDRESS SECTION
//         // ==============================
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: spaceLarge),
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () => _openMap(context, doctor.address),
//                 child: Container(
//                   height: 36 * wScale, width: 36 * wScale,
//                   decoration: BoxDecoration(color: const Color(0xFF263238), borderRadius: BorderRadius.circular(8 * wScale)),
//                   child: Icon(Icons.navigation, color: Colors.white, size: 20 * wScale),
//                 ),
//               ),
//               SizedBox(width: 10 * wScale),
//               Expanded(
//                 child: Text(
//                   doctor.address,
//                   style: TextStyle(fontSize: subtitleFont, color: Colors.grey[800], fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         SizedBox(height: spaceMed),
//
//         // ==============================
//         // 4. CALL BUTTON
//         // ==============================
//         GestureDetector(
//           onTap: () => _callNumber(context, doctor.phoneNumber),
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: spaceLarge),
//             width: double.infinity,
//             padding: EdgeInsets.zero,
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFA726),
//               borderRadius: BorderRadius.circular(30 * wScale),
//             ),
//             child: Row(
//               children: [
//
//                 // LEFT BLACK SECTION
//                 Container(
//                   alignment:Alignment.topLeft ,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 6 * wScale,
//                     vertical: 3* wScale,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.black,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30 * wScale),
//                       bottomLeft: Radius.circular(30 * wScale),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.call,
//                         color: Colors.white,
//                         size: 16 * wScale,
//                       ),
//                       SizedBox(width: 5 * wScale),
//                       Text(
//                         "CALL",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14 * wScale,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(width: 12 * wScale),
//
//                 // PHONE NUMBER
//                 Expanded(
//                   child: Text(
//                     doctor.phoneNumber,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15 * wScale,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         SizedBox(height: spaceMed),
//
//         // ==============================
//         // 5. HIGHLIGHTS TITLE & TEXT
//         // ==============================
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: spaceLarge),
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(vertical: 4 * wScale),
//           decoration: BoxDecoration(color: const Color(0xFFFFA726), borderRadius: BorderRadius.circular(30 * wScale)),
//           alignment: Alignment.center,
//           child: Text("HIGHLIGHTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: subtitleFont)),
//         ),
//
//         Padding(
//           padding: EdgeInsets.only(left: spaceLarge, right: spaceLarge, top: 10 * wScale, bottom: spaceLarge),
//           child: Text(
//             doctor.aboutDoctor.isNotEmpty ? doctor.aboutDoctor : "No details available.",
//             textAlign: TextAlign.justify,
//             style: TextStyle(fontSize: subtitleFont, height: 1.2, color: Colors.black87),
//           ),
//         ),
//       ],
//     );
//   }
// }




































































import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart'; // REQUIRED FOR FAST IMAGES
import 'package:gnw/Models/doctor_model.dart';
import 'package:gnw/services/auth_provider.dart';
import '../widget/FullScreenImageViewer.dart';
import '../widget/customAppBar.dart';
import '../utils/responsive_helper.dart';


final userNameProvider = FutureProvider.autoDispose<String>((ref) async {
  return await AuthService.fetchUserName();
});

final doctorListProvider = FutureProvider.family.autoDispose<List<DoctorModel>, int>((ref, categoryId) async {
  final allDoctors = await AuthService.fetchDoctor();
  return allDoctors
      .where((doc) => doc.categoryIds.contains(categoryId))
      .toList();
});

// ============================================================================
// 1. DOCTOR LIST PAGE (NOW WITH HORIZONTAL SWIPING)
// ============================================================================

class DoctorListPage extends ConsumerWidget {
  final String categoryName;
  final int categoryId;

  const DoctorListPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNameProvider);
    final doctorAsync = ref.watch(doctorListProvider(categoryId));
    final String userName = userAsync.value ?? "User";

    // CRITICAL FIX: Lock text scaling to prevent huge OS fonts from breaking layout
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildCustomAppBar(
          context,
          userName,
          ResponsiveHelper.getAppBarHeight(context),
        ),
        body: doctorAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (doctorList) {
            if (doctorList.isEmpty) {
              return Center(
                child: Text(
                  "No Doctors Added in $categoryName",
                  style: const TextStyle(fontSize: 15, color: Colors.red),
                ),
              );
            }

            // HORIZONTAL SWIPE VIEW
            return PageView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: doctorList.length,
              itemBuilder: (context, index) {
                final doctor = doctorList[index];

                // SingleChildScrollView allows reading long highlights on small phones
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 40),
                    child: DoctorDetailBlock(doctor: doctor),
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

// ============================================================================
// 2. DOCTOR DETAIL BLOCK (Fully Responsive)
// ============================================================================

class DoctorDetailBlock extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorDetailBlock({super.key, required this.doctor});

  Future<void> _callNumber(BuildContext context, String number) async {
    if (number.isEmpty) return;
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not call $number")));
      }
    }
  }

  Future<void> _openWhatsapp(BuildContext context, String number, {String message = " "}) async {
    if (number.isEmpty) return;
    String formatted = number.replaceAll(" ", "").replaceAll("+91", "");
    String encodedMessage = Uri.encodeComponent(message);
    final Uri uri = Uri.parse("https://wa.me/91$formatted?text=$encodedMessage");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open WhatsApp")));
      }
    }
  }

  Future<void> _openMap(BuildContext context, String address) async {
    if (address.isEmpty) return;
    final Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open Maps")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double wScale = width / 390.0;

    // Dynamic Fonts
    double titleFont = 20 * wScale;
    double subtitleFont = 13 * wScale;
    double smallFont = 11 * wScale;
    double tinyFont = 10 * wScale;

    // Dynamic Spacing
    double spaceSmall = 6 * wScale;
    double spaceMed = 12 * wScale;
    double spaceLarge = 16 * wScale;

    // DECIDE WHICH IMAGE STRING TO USE
    final String targetImageUrl = (doctor.clinicImage != null && doctor.clinicImage!.isNotEmpty)
        ? doctor.clinicImage!
        : (doctor.doctorImage != null && doctor.doctorImage!.isNotEmpty)
        ? doctor.doctorImage!
        : "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ... inside DoctorDetailBlock widget builder ...

        Container(
          margin: EdgeInsets.only(
              left: spaceMed,
              right: spaceMed,
              top: 0,
              bottom: spaceSmall),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14 * wScale),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: Container(
            color: Colors.white, // Background behind the image
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  // barrierDismissible: true,
                  // barrierLabel: "Close",
                  barrierColor: Colors.black.withOpacity(0.7),
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (ctx, anim1, anim2) {
                    return Material(
                      type: MaterialType.transparency,
                      child: Stack(
                        children: [
                          // 1. ZOOMABLE IMAGE VIEW
                          Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(ctx).size.width,
                                maxHeight: MediaQuery.of(ctx).size.height,
                              ),
                              child: InteractiveViewer(
                                panEnabled: true,
                                minScale: 1.0,
                                maxScale: 5.0,
                                child: Hero(
                                  tag: doctor.name,
                                  // 🚀 FIX: ClipRRect is now INSIDE the Hero in the popup
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14 * wScale),
                                    child: targetImageUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                      imageUrl: targetImageUrl,
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                      const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.local_hospital, color: Colors.white, size: 50),
                                    )
                                        : Image.asset(
                                      'lib/images/sample.jpeg',
                                      width: double.infinity,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 2. CLOSE BUTTON
                          SafeArea(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 24),
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },

              // 3. ORIGINAL INLINE IMAGE (Thumbnail)
              child: Hero(
                tag: doctor.name,
                // 🚀 FIX: ClipRRect is now INSIDE the Hero in the list thumbnail
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14 * wScale),
                  child: targetImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: targetImageUrl,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Container(
                      height: 350 * wScale,
                      color: Colors.grey.shade100,
                      child: const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 350 * wScale,
                      color: Colors.grey[200],
                      child: Icon(Icons.local_hospital, size: 50 * wScale),
                    ),
                  )
                      : Image.asset(
                    'lib/images/sample.jpeg',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
        ),

// ... rest of the code ...
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spaceLarge),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  doctor.name,
                  style: TextStyle(fontSize: titleFont, fontWeight: FontWeight.bold, height: 1.2),
                ),
              ),
              SizedBox(width: spaceMed),
              GestureDetector(
                onTap: () => _openWhatsapp(
                  context,
                  doctor.whatsappNumber.isNotEmpty ? doctor.whatsappNumber : doctor.phoneNumber,
                  message: "Hi ${doctor.name}, I found your business on *GNW Bazaar*. I would like to know more details.",
                ),
                child: SvgPicture.asset(
                  "lib/icons/whatsapp.svg",
                  height: 38 * wScale,
                  width: 38 * wScale,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height:  5* wScale),

        // ==============================
        // 3. ADDRESS SECTION
        // ==============================
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spaceLarge),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _openMap(context, doctor.address),
                child: Container(
                  height: 36 * wScale, width: 36 * wScale,
                  decoration: BoxDecoration(color: const Color(0xFF263238), borderRadius: BorderRadius.circular(8 * wScale)),
                  child: Icon(Icons.navigation, color: Colors.white, size: 20 * wScale),
                ),
              ),
              SizedBox(width: 10 * wScale),
              Expanded(
                child: Text(
                  doctor.address,
                  style: TextStyle(fontSize: subtitleFont, color: Colors.grey[800], fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: spaceMed*.6),

        // ==============================
        // 4. CALL BUTTON
        // ==============================
        GestureDetector(
          onTap: () => _callNumber(context, doctor.phoneNumber),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: spaceLarge),
            width: double.infinity,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: const Color(0xFFFFA726),
              borderRadius: BorderRadius.circular(30 * wScale),
            ),
            child: Row(
              children: [
                // LEFT BLACK SECTION
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 6 * wScale, vertical: 3 * wScale),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30 * wScale),
                      bottomLeft: Radius.circular(30 * wScale),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.call, color: Colors.white, size: 16 * wScale),
                      SizedBox(width: 5 * wScale),
                      Text("CALL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14 * wScale)),
                    ],
                  ),
                ),
                SizedBox(width: 12 * wScale),
                // PHONE NUMBER
                Expanded(
                  child: Text(
                    "+91 ${doctor.phoneNumber}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * wScale, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: spaceMed*.6),

        // ==============================
        // 5. HIGHLIGHTS TITLE & TEXT
        // ==============================
        Container(
          margin: EdgeInsets.symmetric(horizontal: spaceLarge),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 4 * wScale),
          decoration: BoxDecoration(color: const Color(0xFFFFA726), borderRadius: BorderRadius.circular(30 * wScale)),
          alignment: Alignment.center,
          child: Text("HIGHLIGHTS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: subtitleFont)),
        ),

        Padding(
          padding: EdgeInsets.only(left: spaceLarge, right: spaceLarge, top: 10 * wScale, bottom: spaceLarge),
          child: Text(
            doctor.aboutDoctor.isNotEmpty ? doctor.aboutDoctor : "No details available.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: subtitleFont, height: 1.2, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}