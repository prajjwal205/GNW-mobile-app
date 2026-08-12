import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';

class ShareLoadingDialog extends StatefulWidget {
  final dynamic doctor;

  const ShareLoadingDialog({super.key, required this.doctor});

  @override
  State<ShareLoadingDialog> createState() => _ShareLoadingDialogState();
}

class _ShareLoadingDialogState extends State<ShareLoadingDialog> {
  String statusText = "Preparing to share... ⏳";

  @override
  void initState() {
    super.initState();
    _startShareProcess();
  }

  Future<void> _startShareProcess() async {
    try {
      final doctor = widget.doctor;
      bool isClient = doctor.runtimeType.toString() == 'ClientModel';

      String displayName = isClient ? doctor.clientName : doctor.name;
      String phone = doctor.phoneNumber;
      String address = doctor.address;

      String mapUrl = '';
      if (isClient) {
        try {
          mapUrl = doctor.locationUrl ?? '';
        } catch (e) {
          mapUrl = '';
        }
      }

      String? imageUrl;
      try {
        imageUrl = isClient ? doctor.imagePath : doctor.doctorImage;
      } catch (e) {
        imageUrl = null;
      }

      String appLink = "https://play.google.com/store/apps/details?id=com.gnwbazaar.gnw";

      String shareText = "🌟 *Check out $displayName on GNW Bazaar!* 🌟\n\n"
          "👇 *Download GNW Bazaar App for more trusted services:*\n"
          "🔗 $appLink";

      if (imageUrl != null && imageUrl.isNotEmpty) {
        if (mounted) {
          setState(() {
            statusText = "Preparing to share... ";
          });
        }

        try {
          File cachedFile = await DefaultCacheManager()
              .getSingleFile(imageUrl)
              .timeout(const Duration(seconds: 2));

          if (mounted) Navigator.pop(context);
          await Share.shareXFiles([XFile(cachedFile.path)], text: shareText);

        } on TimeoutException {
          debugPrint("Image taking too long. Skipping image and sharing text only.");
          if (mounted) Navigator.pop(context);
          await Share.share(shareText);

        } catch (e) {
          // Koi aur error aaya tab bhi sirf text
          debugPrint("Cache error: $e");
          if (mounted) Navigator.pop(context);
          await Share.share(shareText);
        }

      } else {
        if (mounted) Navigator.pop(context);
        await Share.share(shareText);
      }
    } catch (e) {
      debugPrint("Process error: $e");
      if (mounted) Navigator.pop(context);

      // Fallback
      await Share.share("🌟 *Check out ${widget.doctor.name ?? 'GNW Bazaar'}!* 🌟\n\nDownload the app: https://play.google.com/store/apps/details?id=com.gnwbazaar.gnw");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFFFFA726)),
            const SizedBox(height: 25),
            Text(
              statusText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}