import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleFormBannerWidget extends StatelessWidget {
  final double horizontalPadding;

  const GoogleFormBannerWidget({
    super.key,
    required this.horizontalPadding,
  });

  // 🚀 Google Form Open karne ka function
  // Future<void> _launchGoogleForm() async {
  //   const url = 'https://forms.gle/gb94DkNwiR2LADwc8';
  //   final uri = Uri.parse(url);
  //
  //   try {
  //     if (await canLaunchUrl(uri)) {
  //       await launchUrl(uri, mode: LaunchMode.externalApplication); // Browser me khulega
  //     } else {
  //       debugPrint("Could not launch $url");
  //     }
  //   } catch (e) {
  //     debugPrint("Error launching url: $e");
  //   }
  // }

  // 🚀 Google Form Open karne ka function
  Future<void> _launchGoogleForm() async {
    const url = 'https://forms.gle/gb94DkNwiR2LADwc8';
    final uri = Uri.parse(url);

    try {
      // 🚀 canLaunchUrl ki condition hata di hai.
      // Ab yeh direct browser open karne ka try karega.
      bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        debugPrint("Browser nahi khul paya $url");
      }
    } catch (e) {
      debugPrint("Error launching url: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding sirf yahan rakhi hai, Homepage me zaroorat nahi padegi
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: horizontalPadding + 20,
        top: 10,
      ),
      child: GestureDetector(
        onTap: _launchGoogleForm,
        // 🚀 YE RAHA 16/3 ASPECT RATIO
        child: AspectRatio(
          aspectRatio: 16 / 3,
          child: Container(
            width: double.infinity, // 🚀 YE LINE BANNER KO POORI SCREEN PAR FAILAYEGI
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'lib/images/G_form.jpeg',
                // 🚀 BoxFit.fill se image box ke hisaab se stretch ho jati hai.
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}