import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';


class InfoRowSvg extends StatelessWidget {
  final String svgPath;
  final String label;
  final String? value;
  final bool isEmail;

  const InfoRowSvg({
    super.key,
    required this.svgPath,
    required this.label,
    required this.value,
    this.isEmail=false,
  });



  Future<void> openGmail(String email) async {
    final Uri gmailUri = Uri.parse("googlegmail:///co?to=$email");

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
    } else {
      // fallback to normal mailto
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("No email app found");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        GestureDetector(
          onTap: () => openGmail(value!),
          child: SvgPicture.asset(
            svgPath,
            height: 22,
            width: 22,
          ),
        ),

        //
        // SvgPicture.asset(
        //   svgPath,
        //   height: 22,
        //   width: 22,
        // ),
        const SizedBox(width: 10),

        Text(
          "$label : ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),

        Expanded(
          child: Text(
            value!,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
