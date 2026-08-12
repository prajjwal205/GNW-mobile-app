// // import 'package:flutter/material.dart';
// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:gnw/Models/doctor_model.dart';
// // import 'static_arrow.dart';
// //
// // class DoctorImageHeader extends StatelessWidget {
// //   final dynamic doctor;
// //   final int index;
// //   final int totalCount;
// //   final PageController pageController;
// //   final double wScale;
// //
// //   const DoctorImageHeader({
// //     super.key,
// //     required this.doctor,
// //     required this.index,
// //     required this.totalCount,
// //     required this.pageController,
// //     required this.wScale,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final String targetImageUrl = (
// //         doctor.clinicImage != null && doctor.clinicImage!.isNotEmpty)
// //         ? doctor.clinicImage!
// //         : (doctor.doctorImage != null && doctor.doctorImage!.isNotEmpty)
// //         ? doctor.doctorImage!
// //         : "";
// //
// //     return Container(
// //       margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 6 * wScale),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(14 * wScale),
// //         border: Border.all(color: Colors.grey.shade300),
// //         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))],
// //       ),
// //       child: Stack(
// //         clipBehavior: Clip.none,
// //         alignment: Alignment.center,
// //         children: [
// //           Container(
// //             color: Colors.white,
// //             child: GestureDetector(
// //               onTap: () {
// //                 showGeneralDialog(
// //                   context: context,
// //                   barrierColor: Colors.black.withOpacity(0.7),
// //                   transitionDuration: const Duration(milliseconds: 300),
// //                   pageBuilder: (ctx, anim1, anim2) => Material(
// //                     type: MaterialType.transparency,
// //                     child: Stack(
// //                       children: [
// //                         Center(
// //                           child: ConstrainedBox(
// //                             constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width, maxHeight: MediaQuery.of(ctx).size.height),
// //                             child: InteractiveViewer(
// //                               panEnabled: true, minScale: 1.0, maxScale: 5.0,
// //                               child: Hero(
// //                                 tag: doctor.name,
// //                                 child: ClipRRect(
// //                                   borderRadius: BorderRadius.circular(14 * wScale),
// //                                   child: targetImageUrl.isNotEmpty
// //                                       ? CachedNetworkImage(imageUrl: targetImageUrl, width: double.infinity, fit: BoxFit.contain, placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))), errorWidget: (context, url, error) => const Icon(Icons.local_hospital, color: Colors.white, size: 50))
// //                                       : Image.asset('lib/images/sample.jpeg', width: double.infinity, fit: BoxFit.contain),
// //                                 ),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         SafeArea(child: Align(alignment: Alignment.topRight, child: Padding(padding: const EdgeInsets.all(16.0), child: CircleAvatar(backgroundColor: Colors.black54, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 24), onPressed: () => Navigator.of(ctx).pop()))))),
// //                       ],
// //                     ),
// //                   ),
// //                 );
// //               },
// //               child: Hero(
// //                 tag: doctor.name,
// //                 child: ClipRRect(
// //                   borderRadius: BorderRadius.circular(8 * wScale),
// //                   child: targetImageUrl.isNotEmpty
// //                       ? CachedNetworkImage(
// //                       imageUrl: targetImageUrl,
// //                       width: double.infinity,
// //                       fit: BoxFit.fitWidth,
// //                       placeholder: (context, url) => Container(
// //                           height: 350 * wScale,
// //                           color: Colors.grey.shade100,
// //                           child: const Center(
// //                               child: CircularProgressIndicator(color: Color(0xFFFFA726)))),
// //                       errorWidget: (context, url, error) => Container(
// //                           height: 350 * wScale, color: Colors.grey[200],
// //                           child: Icon(Icons.local_hospital, size: 50 * wScale)))
// //                       : Image.asset('lib/images/sample.jpeg', width: double.infinity, fit: BoxFit.fitWidth),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           if (index > 0)
// //             Positioned(
// //               left: -12 * wScale,
// //               child: StaticArrow(icon: Icons.arrow_back_ios_new_rounded, iconSize: 20 * wScale, paddingSize: 1 * wScale, onTap: () => pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
// //             ),
// //           if (index < totalCount - 1)
// //             Positioned(
// //               right: -12 * wScale,
// //               child: StaticArrow(icon: Icons.arrow_forward_ios_rounded, iconSize: 20 * wScale, paddingSize: 1 * wScale, onTap: () => pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
// //             ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// // Note: Tumhara doctor_model import same rahega
// import 'static_arrow.dart';
//
// class DoctorImageHeader extends StatelessWidget {
//   final dynamic doctor; // ✅ Dynamic hi rahega
//   final int index;
//   final int totalCount;
//   final PageController pageController;
//   final double wScale;
//
//   const DoctorImageHeader({
//     super.key,
//     required this.doctor,
//     required this.index,
//     required this.totalCount,
//     required this.pageController,
//     required this.wScale,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // 🚀 1. Pehle check karo ki data kiska hai (Client ka ya Doctor ka)
//     final bool isClient = doctor.runtimeType.toString() == 'ClientModel';
//
//     // 🚀 2. Image ka URL safely nikalo
//     String targetImageUrl = "";
//     if (isClient) {
//       targetImageUrl = (doctor.imagePath != null && doctor.imagePath!.isNotEmpty)
//           ? doctor.imagePath!
//           : "";
//     } else {
//       targetImageUrl = (doctor.clinicImage != null && doctor.clinicImage!.isNotEmpty)
//           ? doctor.clinicImage!
//           : (doctor.doctorImage != null && doctor.doctorImage!.isNotEmpty)
//           ? doctor.doctorImage!
//           : "";
//     }
//
//     // 🚀 3. Hero Tag ke liye sahi naam nikalo
//     final String displayName = isClient ? doctor.clientName : doctor.name;
//
//     return Container(
//       margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 6 * wScale),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(14 * wScale),
//         border: Border.all(color: Colors.grey.shade300),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0, 3))],
//       ),
//       child: Stack(
//         clipBehavior: Clip.none,
//         alignment: Alignment.center,
//         children: [
//           Container(
//             color: Colors.white,
//             child: GestureDetector(
//               onTap: () {
//                 showGeneralDialog(
//                   context: context,
//                   barrierColor: Colors.black.withOpacity(0.7),
//                   transitionDuration: const Duration(milliseconds: 300),
//                   pageBuilder: (ctx, anim1, anim2) => Material(
//                     type: MaterialType.transparency,
//                     child: Stack(
//                       children: [
//                         Center(
//                           child: ConstrainedBox(
//                             constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width, maxHeight: MediaQuery.of(ctx).size.height),
//                             child: InteractiveViewer(
//                               panEnabled: true, minScale: 1.0, maxScale: 5.0,
//                               child: Hero(
//                                 tag: displayName, // ✅ Sahi naam use kiya
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(14 * wScale),
//                                   child: targetImageUrl.isNotEmpty
//                                       ? CachedNetworkImage(imageUrl: targetImageUrl, width: double.infinity, fit: BoxFit.contain, placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))), errorWidget: (context, url, error) => const Icon(Icons.local_hospital, color: Colors.white, size: 50))
//                                       : Image.asset('lib/images/img.png', width: double.infinity, fit: BoxFit.contain),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SafeArea(child: Align(alignment: Alignment.topRight, child: Padding(padding: const EdgeInsets.all(16.0), child: CircleAvatar(backgroundColor: Colors.black54, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 24), onPressed: () => Navigator.of(ctx).pop()))))),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//               child: Hero(
//                 tag: displayName, // ✅ Sahi naam use kiya
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8 * wScale),
//                   child: targetImageUrl.isNotEmpty
//                       ? CachedNetworkImage(
//                       imageUrl: targetImageUrl,
//                       width: double.infinity,
//                       fit: BoxFit.fitWidth,
//                       placeholder: (context, url) => Container(
//                           height: 350 * wScale,
//                           color: Colors.grey.shade100,
//                           child: const Center(
//                               child: CircularProgressIndicator(color: Color(0xFFFFA726)))),
//                       errorWidget: (context, url, error) => Container(
//                           height: 350 * wScale, color: Colors.grey[200],
//                           // child: Icon(Icons.local_hospital, size: 50 * wScale),
//                       ))
//                       : Image.asset('lib/images/img.png', width: double.infinity, fit: BoxFit.fitWidth),
//                 ),
//               ),
//             ),
//           ),
//           if (index > 0)
//             Positioned(
//               left: -12 * wScale,
//               child: StaticArrow(icon: Icons.arrow_back_ios_new_rounded, iconSize: 20 * wScale, paddingSize: 1 * wScale, onTap: () => pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
//             ),
//           if (index < totalCount - 1)
//             Positioned(
//               right: -12 * wScale,
//               child: StaticArrow(icon: Icons.arrow_forward_ios_rounded, iconSize: 20 * wScale, paddingSize: 1 * wScale, onTap: () => pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Note: Tumhara doctor_model import same rahega
import 'static_arrow.dart';

class DoctorImageHeader extends StatelessWidget {
  final dynamic doctor; // ✅ Dynamic hi rahega
  final int index;
  final int totalCount;
  final PageController pageController;
  final double wScale;

  const DoctorImageHeader({
    super.key,
    required this.doctor,
    required this.index,
    required this.totalCount,
    required this.pageController,
    required this.wScale,
  });

  @override
  Widget build(BuildContext context) {
    // 🚀 1. Pehle check karo ki data kiska hai (Client ka ya Doctor ka)
    final bool isClient = doctor.runtimeType.toString() == 'ClientModel';

    // 🚀 2. Image ka URL safely nikalo
    String targetImageUrl = "";
    if (isClient) {
      targetImageUrl = (doctor.imagePath != null && doctor.imagePath!.isNotEmpty)
          ? doctor.imagePath!
          : "";
    } else {
      targetImageUrl = (doctor.clinicImage != null && doctor.clinicImage!.isNotEmpty)
          ? doctor.clinicImage!
          : (doctor.doctorImage != null && doctor.doctorImage!.isNotEmpty)
          ? doctor.doctorImage!
          : "";
    }

    // 🚀 3. Hero Tag ke liye sahi naam nikalo
    final String displayName = isClient ? doctor.clientName : doctor.name;

    return Container(
      margin: EdgeInsets.only(left: 12 * wScale, right: 12 * wScale, bottom: 6 * wScale),
      decoration: BoxDecoration(
        color: Colors.white, // 🚀 Background hamesha white rahega
        borderRadius: BorderRadius.circular(14 * wScale),
        // 🚀 MAGIC YAHAN HAI: Grey ki jagah thick Theme color ka border lagaya
        border: Border.all(color: const Color(0xFFFFA726), width: 2.5 * wScale),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3)
          )
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // 🚀 Image Container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11 * wScale), // Border ke andar perfect fit
            ),
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.7),
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (ctx, anim1, anim2) => Material(
                    type: MaterialType.transparency,
                    child: Stack(
                      children: [
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width, maxHeight: MediaQuery.of(ctx).size.height),
                            child: InteractiveViewer(
                              panEnabled: true, minScale: 1.0, maxScale: 5.0,
                              child: Hero(
                                tag: displayName,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14 * wScale),
                                  child: targetImageUrl.isNotEmpty
                                      ? CachedNetworkImage(imageUrl: targetImageUrl, width: double.infinity, fit: BoxFit.contain, placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))), errorWidget: (context, url, error) => const Icon(Icons.local_hospital, color: Colors.white, size: 50))
                                      : Image.asset('lib/images/img.png', width: double.infinity, fit: BoxFit.contain),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SafeArea(child: Align(alignment: Alignment.topRight, child: Padding(padding: const EdgeInsets.all(16.0), child: CircleAvatar(backgroundColor: Colors.black54, child: IconButton(icon: const Icon(Icons.close, color: Colors.white, size: 24), onPressed: () => Navigator.of(ctx).pop()))))),
                      ],
                    ),
                  ),
                );
              },
              child: Hero(
                tag: displayName,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11 * wScale), // 🚀 Inner radius outer border se thoda kam hona chahiye
                  child: targetImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                      imageUrl: targetImageUrl,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      memCacheWidth: 800,
                      placeholder: (context, url) => Container(
                          height: 350 * wScale,
                          color: Colors.grey.shade100,
                          child: const Center(
                              child: CircularProgressIndicator(color: Color(0xFFFFA726)))),
                      errorWidget: (context, url, error) => Container(
                        height: 350 * wScale, color: Colors.grey[200],
                      ))
                      : Image.asset('lib/images/img.png', width: double.infinity, fit: BoxFit.fitWidth),
                ),
              ),
            ),
          ),

          // 🚀 Arrows (Same code)
          if (index > 0)
            Positioned(
              left: -14 * wScale, // Thoda aur baahar shift kiya taaki border par overlap na ho
              child: StaticArrow(icon: Icons.arrow_back_ios_new_rounded, iconSize: 20 * wScale, paddingSize: 1 * wScale, onTap: () => pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
            ),
          if (index < totalCount - 1)
            Positioned(
              right: -14 * wScale, // Thoda aur baahar shift kiya
              child: StaticArrow(icon: Icons.arrow_forward_ios_rounded, iconSize: 20 * wScale, paddingSize: 1 * wScale, onTap: () => pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut)),
            ),
        ],
      ),
    );
  }
}