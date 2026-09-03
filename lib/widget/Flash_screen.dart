import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gnw/providers/sponsor_notifier.dart'; // Apna path check kar lena

class LoadingOverlay extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const LoadingOverlay({
    super.key,
    required this.onClose,
  });

  @override
  ConsumerState<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends ConsumerState<LoadingOverlay> {
  String fastBannerUrl = "";

  @override
  void initState() {
    super.initState();
    _loadBannerInstantly();
  }

  // 🚀 Memory se instantly fetch karne ka logic
  Future<void> _loadBannerInstantly() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fastBannerUrl = prefs.getString('flash_banner_url') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final sponsorAsync = ref.watch(sponsorNotifierProvider);

    // UI mein dikhane ke liye final URL
    String urlToRender = fastBannerUrl;

    if (sponsorAsync.hasValue && sponsorAsync.value != null) {
      final flashBanners = sponsorAsync.value!.where((s) => s.sponsorType == "FLASH SCREEN").toList();

      if (flashBanners.isNotEmpty && flashBanners.first.cleanImageUrl != null) {
        String latestApiUrl = flashBanners.first.cleanImageUrl!;

        // Naye banner ko next time ke liye cache me daal do
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('flash_banner_url', latestApiUrl);
        });

        // Agar purana URL khali tha, toh turant naya wala use kar lo
        if (urlToRender.isEmpty) {
          urlToRender = latestApiUrl;
        }
      }
    }

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // 🖼️ Center Banner Image ya Loader
            Center(
              child: FractionallySizedBox(
                widthFactor: .96,
                child: _buildBannerWidget(urlToRender),
              ),
            ),

            // ❌ Close Button
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: widget.onClose,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🖼️ SMART IMAGE BUILDER
  // ==========================================
  Widget _buildBannerWidget(String url) {
    // 1. Agar API load ho rahi hai aur URL abhi nahi mila
    if (url.isEmpty) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(strokeWidth: 3, color: Colors.blueAccent),
          SizedBox(height: 12),
          Text("Loading Banner...", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      );
    }

    // 2. Agar URL mil gaya toh image dikhao
    return Image.network(
      url,
      fit: BoxFit.contain,
      // 🚀 Jab tak network se image download ho rahi hai, tab bhi loader dikhao
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 3, color: Colors.blueAccent),
            SizedBox(height: 12),
            Text("Downloading...", style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        );
      },
      // ⚠️ Agar URL fail ho gaya (ya invalid path hua)
      errorBuilder: (context, error, stackTrace) {
        debugPrint("Banner Image Error: $error");
        return const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.broken_image, size: 50, color: Colors.grey),
            SizedBox(height: 10),
            Text("Banner Not Available", style: TextStyle(color: Colors.grey)),
          ],
        );
      },
    );
  }
}