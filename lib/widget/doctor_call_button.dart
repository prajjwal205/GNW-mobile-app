//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'share_page.dart';
//
// class DoctorCallButton extends StatefulWidget {
//   final dynamic doctor;
//   final double wScale;
//
//    DoctorCallButton({super.key, required this.doctor, required this.wScale});
//
//   @override
//   State<DoctorCallButton> createState() => _DoctorCallButtonState();
// }
//
// class _DoctorCallButtonState extends State<DoctorCallButton> {
//   //  CALL LOGIC
//   Future<void> _callNumber(BuildContext context, String number) async {
//     if (number.isEmpty) return;
//     final Uri uri = Uri(scheme: 'tel', path: number);
//     if (!await launchUrl(uri) && context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not call $number")));
//     }
//   }
//
//
//   void _shareListing(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // User ko screen tap karke band karne se rokega
//       builder: (context) {
//         return ShareLoadingDialog(doctor: widget.doctor);
//       },
//     );
//   }
//
//   //  SHARE LOGIC
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: 16 * widget.wScale),
//       padding: EdgeInsets.symmetric(vertical: 2 * widget.wScale, horizontal: 10 * widget.wScale),
//       decoration: BoxDecoration(
//           color: const Color(0xFFFFA726),
//           borderRadius: BorderRadius.circular(30 * widget.wScale)
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//
//           // 1. LEFT SIDE: CALL SECTION
//           GestureDetector(
//             onTap: () => _callNumber(context, widget.doctor.phoneNumber),
//             child: Row(
//               children: [
//                 Container(
//                   height: 28 * widget.wScale,
//                   width: 28 * widget.wScale,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Image.asset(
//                       "lib/images/PHONE.png",
//                       height: 14 * widget.wScale,
//                       width: 14 * widget.wScale,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8 * widget.wScale),
//                 Text(
//                   "+91 ${widget.doctor.phoneNumber}",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * widget.wScale, color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//
//           GestureDetector(
//             onTap: () => _shareListing(context), // ✅ CORRECTED
//             child: Row(
//               children: [
//                 Container(
//                   height: 28 * widget.wScale,
//                   width: 28 * widget.wScale,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Image.asset(
//                       "lib/images/share_icon.png",
//                       height: 14 * widget.wScale,
//                       width: 14 * widget.wScale,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8 * widget.wScale),
//                 Text(
//                   "Share Listing",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * widget.wScale, color: Colors.black),
//                 ),
//                 SizedBox(width: 4 * widget.wScale),
//               ],
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'share_page.dart';
// 🚀 1. APNA LOGIN CHECK IMPORT KAREIN (Path check kar lena)
import 'package:gnw/utils/login_check.dart';

class DoctorCallButton extends StatefulWidget {
  final dynamic doctor;
  final double wScale;

  DoctorCallButton({super.key, required this.doctor, required this.wScale});

  @override
  State<DoctorCallButton> createState() => _DoctorCallButtonState();
}

class _DoctorCallButtonState extends State<DoctorCallButton> {
  //  CALL LOGIC
  Future<void> _callNumber(BuildContext context, String number) async {
    if (number.isEmpty) return;
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not call $number")));
    }
  }


  void _shareListing(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User ko screen tap karke band karne se rokega
      builder: (context) {
        return ShareLoadingDialog(doctor: widget.doctor);
      },
    );
  }

  //  SHARE LOGIC
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * widget.wScale),
      padding: EdgeInsets.symmetric(vertical: 2 * widget.wScale, horizontal: 10 * widget.wScale),
      decoration: BoxDecoration(
          color: const Color(0xFFFFA726),
          borderRadius: BorderRadius.circular(30 * widget.wScale)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // 1. LEFT SIDE: CALL SECTION
          GestureDetector(
            // 🚀 2. YAHAN GUARD LAGA DIYA HAI
            onTap: () {
              LoginCheck.executeIfLoggedIn(context, () {
                _callNumber(context, widget.doctor.phoneNumber);
              });
            },
            child: Row(
              children: [
                Container(
                  height: 28 * widget.wScale,
                  width: 28 * widget.wScale,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      "lib/images/PHONE.png",
                      height: 14 * widget.wScale,
                      width: 14 * widget.wScale,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 8 * widget.wScale),
                Text(
                  "+91 ${widget.doctor.phoneNumber}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * widget.wScale, color: Colors.black),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () => _shareListing(context),
            child: Row(
              children: [
                Container(
                  height: 28 * widget.wScale,
                  width: 28 * widget.wScale,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      "lib/images/share_icon.png",
                      height: 14 * widget.wScale,
                      width: 14 * widget.wScale,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 8 * widget.wScale),
                Text(
                  "Share Listing",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * widget.wScale, color: Colors.black),
                ),
                SizedBox(width: 4 * widget.wScale),
              ],
            ),
          ),

        ],
      ),
    );
  }
}