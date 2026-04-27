// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:gnw/Models/doctor_model.dart';
//
// class DoctorContactInfo extends StatelessWidget {
//   final dynamic doctor;
//   final double wScale;
//
//   const DoctorContactInfo({super.key, required this.doctor, required this.wScale});
//
//   Future<void> _openMap(BuildContext context, String address) async {
//     if (address.isEmpty) return;
//     final Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open Maps")));
//   }
//
//   Future<void> _openWhatsapp(BuildContext context, String number, {String message = " "}) async {
//     if (number.isEmpty) return;
//     String formatted = number.replaceAll(" ", "").replaceAll("+91", "");
//     final Uri uri = Uri.parse("https://wa.me/91$formatted?text=${Uri.encodeComponent(message)}");
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open WhatsApp")));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String displayName = doctor.runtimeType.toString() == 'ClientModel' ? doctor.clientName : doctor.name;
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () => _openWhatsapp(
//               context, doctor.whatsappNumber.isNotEmpty ? doctor.whatsappNumber : doctor.phoneNumber,
//               message: "Hi ${doctor.name}, I found your business on *GNW Bazaar*. I would like to know more details."),
//               child: Container(
//              margin: EdgeInsets.symmetric(horizontal: 16 * wScale),
//              padding: EdgeInsets.symmetric(horizontal: 4 * wScale, vertical: 4 * wScale),
//              decoration: BoxDecoration(
//               color: const Color(0xFFF9A826),
//               borderRadius: BorderRadius.circular(30 * wScale),
//             ),
//             child: Row(
//               children: [
//                 Container(
//                   height: 40 * wScale,
//                   width: 40 * wScale,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Image.asset("lib/images/WA.png", height: 28 * wScale, width: 28 * wScale),
//                   ),
//                 ),
//                 SizedBox(width: 12 * wScale),
//                 Expanded(
//                   child: Text(
//                     displayName,
//                     style: TextStyle(
//                       fontSize: 20 * wScale,
//                       color: Colors.black87,
//                       height: 1.2,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         SizedBox(height: 5 * wScale), // Space between pills
//
//
//         //  2. MAP ICON & ADDRESS
//
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16 * wScale),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center, // Aligns icon with top of address if text wraps
//             children: [
//               GestureDetector(
//                 onTap: () => _openMap(context, doctor.address),
//                 child: Container(
//                   height: 32 * wScale,
//                   width: 32 * wScale,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF263238),
//                     borderRadius: BorderRadius.circular(50 * wScale),
//                     border: Border.all(color: Colors.orange, width: 2.0 * wScale, )
//                     // shape: BoxShape.circle,
//                   ),
//                   child: Container(
//                     child: Image.asset("lib/images/LOCATION_ICON.png",
//                       height: 20*wScale,
//                       width: 20*wScale,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//
//                 ),
//               ),
//               SizedBox(width: 10 * wScale),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.only(top: 2 * wScale), // Slight nudge to align text with icon
//                   child: Center(
//                     child: Text(
//                       doctor.address,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         fontSize: 14 * wScale,
//                         color: Colors.grey[800],
//                         fontWeight: FontWeight.w600,
//                         height: 1.3,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gnw/Models/doctor_model.dart';
import 'package:gnw/Models/client_model.dart'; // Required for ClientModel type check

class DoctorContactInfo extends StatelessWidget {
  final dynamic doctor;
  final double wScale;

  const DoctorContactInfo({super.key, required this.doctor, required this.wScale});

  Future<void> _openMap(BuildContext context, String address) async {
    if (address.isEmpty) return;
    final Uri uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open Maps")));
    }
  }

  Future<void> _openWhatsapp(BuildContext context, String number, {String message = " "}) async {
    if (number.isEmpty) return;
    String formatted = number.replaceAll(" ", "").replaceAll("+91", "");
    final Uri uri = Uri.parse("https://wa.me/91$formatted?text=${Uri.encodeComponent(message)}");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open WhatsApp")));
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName = "";
    String finalNumber = "";
    String mapAddress = "";

    // 1. Extract values safely based on the exact model type
    if (doctor is ClientModel) {
      displayName = doctor.clientName;
      finalNumber = doctor.whatsappNumber.isNotEmpty ? doctor.whatsappNumber : doctor.phoneNumber;
      mapAddress = doctor.address;
    } else if (doctor is DoctorModel) {
      displayName = doctor.name;
      finalNumber = doctor.whatsappNumber.isNotEmpty ? doctor.whatsappNumber : doctor.phoneNumber;
      mapAddress = doctor.address;
    } else {
      displayName = doctor.name ?? "User";
      finalNumber = doctor.phoneNumber ?? "";
      mapAddress = doctor.address ?? "";
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (finalNumber.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No WhatsApp number available"), backgroundColor: Colors.red),
              );
              return;
            }

            // 2. Use the safely extracted displayName here instead of doctor.name
            _openWhatsapp(
                context,
                finalNumber,
                message: "Hi $displayName, I found your business on *GNW Bazaar*. I would like to know more details."
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16 * wScale),
            padding: EdgeInsets.symmetric(horizontal: 4 * wScale, vertical: 4 * wScale),
            decoration: BoxDecoration(
              color: const Color(0xFFF9A826),
              borderRadius: BorderRadius.circular(30 * wScale),
            ),
            child: Row(
              children: [
                Container(
                  height: 40 * wScale,
                  width: 40 * wScale,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset("lib/images/WA.png", height: 28 * wScale, width: 28 * wScale),
                  ),
                ),
                SizedBox(width: 12 * wScale),
                Expanded(
                  child: Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 20 * wScale,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 5 * wScale),

        // MAP ICON & ADDRESS
        // Location item in a list with colorful pin like the image
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16 * wScale),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🚀 EXACT IMAGE WALA LOGO DESIGN
              GestureDetector(
                onTap: () => _openMap(context, mapAddress),
                child: Container(
                  height: 42 * wScale, // Image jaisa thoda prominent size
                  width: 42 * wScale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                      width: 3 * wScale,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "lib/images/LOCATION_ICON.png",
                      height: 29 * wScale,
                      width: 29 * wScale,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12 * wScale), // Logo aur Text ke beech ka gap

              // 🚀 ADDRESS TEXT (Left Aligned jaisa photo mein hai)
              Expanded(
                child: Text(
                  mapAddress, // "207, Chauganpur, Knowledge Park V..."
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start, // 🚀 Left align (Center hata diya hai)
                  style: TextStyle(
                    fontSize: 14 * wScale,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700, // Photo mein text thoda bold hai
                    height: 1.3, // Lines ke beech ka gap
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}