import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart'; // 🚀 SHARE KE LIYE YE ZAROORI HAI

class DoctorCallButton extends StatelessWidget {
  final dynamic doctor;
  final double wScale;

  const DoctorCallButton({super.key, required this.doctor, required this.wScale});

  //  CALL LOGIC
  Future<void> _callNumber(BuildContext context, String number) async {
    if (number.isEmpty) return;
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not call $number")));
    }
  }

  //  SHARE LOGIC
  void _shareListing() {
    String displayName = doctor.runtimeType.toString() == 'ClientModel' ? doctor.clientName : doctor.name;
    final String shareText = "Check out $displayName on GNW Bazaar!\nContact: +91 ${doctor.phoneNumber}\nAddress: ${doctor.address}";
    SharePlus.instance.share(
      ShareParams(
        text: shareText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16 * wScale),
      padding: EdgeInsets.symmetric(vertical: 2 * wScale, horizontal: 10 * wScale), // Thodi padding di taaki icons chipke nahi
      decoration: BoxDecoration(
          color: const Color(0xFFFFA726),
          borderRadius: BorderRadius.circular(30 * wScale)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Dono hisso ko left aur right me faila dega
        children: [

          // 1. LEFT SIDE: CALL SECTION
          GestureDetector(
            onTap: () => _callNumber(context, doctor.phoneNumber),
            child: Row(
              children: [
                //  CALL ICON WALA WHITE CIRCLE
                Container(
                  height: 28 * wScale, // Height aur width BARABAR rakhi hai
                  width: 28 * wScale,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      "lib/images/PHONE.png",
                      height: 14 * wScale,
                      width: 14 * wScale,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 8 * wScale),
                Text(
                  "+91 ${doctor.phoneNumber}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * wScale, color: Colors.black),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: _shareListing, //  YAHAN SHARE FUNCTION CALL HOGA
            child: Row(
              children: [
                //  SHARE ICON WALA WHITE CIRCLE
                Container(
                  height: 28 * wScale,
                  width: 28 * wScale,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      "lib/images/share_icon.png",
                      height: 14 * wScale,
                      width: 14 * wScale,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 8 * wScale),
                Text(
                  "Share Listing",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 * wScale, color: Colors.black),
                ),
                SizedBox(width: 4 * wScale),
              ],
            ),
          ),

        ],
      ),
    );
  }
}