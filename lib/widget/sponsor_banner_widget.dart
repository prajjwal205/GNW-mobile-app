// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:gnw/Models/Sponsor_model.dart';
// import 'package:gnw/services/auth_provider.dart';
//
// final sponsorProvider = FutureProvider.autoDispose<List<SponsorModel>>((ref) async {
//   final timer = Timer(const Duration(seconds: 15), () => ref.invalidateSelf());
//   ref.onDispose(() => timer.cancel());
//
//   return await AuthService.fetchSponsor();
// });
//
// class SponsorBannerWidget extends ConsumerStatefulWidget {
//   final String bannerType;
//   final double aspectRatio;
//   final int scrollSeconds;
//   final int? categoryId; // 🚀 NAYA: Isko optional rakha hai taaki purani jagah error na aaye
//
//   const SponsorBannerWidget({
//     super.key,
//     required this.bannerType,
//     this.aspectRatio = 16 / 6,
//     this.scrollSeconds = 1,
//     this.categoryId, // 🚀 NAYA
//   });
//
//   @override
//   ConsumerState<SponsorBannerWidget> createState() => _SponsorBannerWidgetState();
// }
//
// class _SponsorBannerWidgetState extends ConsumerState<SponsorBannerWidget> {
//   final PageController _pageController = PageController(initialPage: 1000);
//   Timer? _autoScrollTimer;
//
//   @override
//   void dispose() {
//     _autoScrollTimer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _startAutoScroll(int itemCount) {
//     _autoScrollTimer?.cancel();
//     if (itemCount <= 1) return;
//
//     _autoScrollTimer = Timer.periodic(Duration(seconds: widget.scrollSeconds), (timer) {
//       if (mounted && _pageController.hasClients) {
//         _pageController.nextPage(
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // final sponsorAsync = ref.watch(sponsorProvider);
//     final AsyncValue<List<SponsorModel>> sponsorAsync = widget.categoryId != null
//         ? ref.watch(categorySponsorProvider(widget.categoryId!))
//         : ref.watch(sponsorProvider);
//
//     return AspectRatio(
//       aspectRatio: widget.aspectRatio,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: sponsorAsync.when(
//           loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
//           error: (err, stack) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
//           data: (allSponsors) {
//
//
//
//             final banners = allSponsors.where((s) =>
//             s.sponsorType == widget.bannerType &&
//                 s.isActive &&
//                 s.cleanImageUrl != null
//             ).toList();
//
//             if (banners.isEmpty) {
//               return Center(
//                   child: Text(
//                       "${widget.bannerType}\nSpace Available",
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
//                   )
//               );
//             }
//
//             if (_autoScrollTimer == null) _startAutoScroll(banners.length);
//
//             return Listener(
//               onPointerDown: (_) => _autoScrollTimer?.cancel(),
//               onPointerUp: (_) => _startAutoScroll(banners.length),
//               onPointerCancel: (_) => _startAutoScroll(banners.length),
//
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemBuilder: (context, index) {
//                   final realIndex = index % banners.length;
//
//                   return CachedNetworkImage(
//                     imageUrl: banners[realIndex].cleanImageUrl!,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
//                     errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:gnw/Models/Sponsor_model.dart';
// import 'package:gnw/services/auth_provider.dart';
//
// // 🌟 1. Purana Provider (Homepage ke liye)
// final sponsorProvider = FutureProvider.autoDispose<List<SponsorModel>>((ref) async {
//   final timer = Timer(const Duration(seconds: 15), () => ref.invalidateSelf());
//   ref.onDispose(() => timer.cancel());
//   return await AuthService.fetchSponsor();
// });
//
// // 🌟 2. NAYA Provider (Specific Category/Sub-Category ke liye) -> Yahi missing tha!
// final categorySponsorProvider = FutureProvider.family.autoDispose<List<SponsorModel>, int>((ref, categoryId) async {
//   final timer = Timer(const Duration(seconds: 15), () => ref.invalidateSelf());
//   ref.onDispose(() => timer.cancel());
//   return await AuthService.fetchSponsorsByCategory(categoryId);
// });
//
// class SponsorBannerWidget extends ConsumerStatefulWidget {
//   final String bannerType;
//   final double aspectRatio;
//   final int scrollSeconds;
//   final int? categoryId; // 🚀 Optional category ID
//
//   const SponsorBannerWidget({
//     super.key,
//     required this.bannerType,
//     this.aspectRatio = 16 / 6,
//     this.scrollSeconds = 6,
//     this.categoryId,
//   });
//
//   @override
//   ConsumerState<SponsorBannerWidget> createState() => _SponsorBannerWidgetState();
// }
//
// class _SponsorBannerWidgetState extends ConsumerState<SponsorBannerWidget> {
//   final PageController _pageController = PageController(initialPage: 1000);
//   Timer? _autoScrollTimer;
//
//   @override
//   void dispose() {
//     _autoScrollTimer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _startAutoScroll(int itemCount) {
//     _autoScrollTimer?.cancel();
//     if (itemCount <= 1) return;
//
//     _autoScrollTimer = Timer.periodic(Duration(seconds: widget.scrollSeconds), (timer) {
//       if (mounted && _pageController.hasClients) {
//         _pageController.nextPage(
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // 🚀 Agar categoryId pass kiya gaya hai, toh naya provider chalega, warna purana
//     final AsyncValue<List<SponsorModel>> sponsorAsync = widget.categoryId != null
//         ? ref.watch(categorySponsorProvider(widget.categoryId!))
//         : ref.watch(sponsorProvider);
//
//     return AspectRatio(
//       aspectRatio: widget.aspectRatio,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         clipBehavior: Clip.hardEdge,
//         child: sponsorAsync.when(
//           loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
//           error: (err, stack) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
//           data: (allSponsors) {
//
//             final banners = allSponsors.where((s) =>
//             s.sponsorType == widget.bannerType &&
//                 s.isActive &&
//                 s.cleanImageUrl != null
//             ).toList();
//
//             // Agar banners nahi hain toh jagah na ghere
//             if (banners.isEmpty) {
//               return const SizedBox.shrink();
//             }
//
//             if (banners.isEmpty) {
//               return Image.asset(
//                 "lib/images/premium.jpeg",
//                 fit: BoxFit.cover,
//               );
//             }
//
//             if (widget.bannerType == "PRIME SPOTLIGHT" || banners.length == 1) {
//               _autoScrollTimer?.cancel(); // Timer band rakho
//               return CachedNetworkImage(
//                 imageUrl: banners.first.cleanImageUrl!, // Sirf pehli image
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
//                 errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
//               );
//             }
//
//
//
//             if (_autoScrollTimer == null) _startAutoScroll(banners.length);
//
//             return Listener(
//               onPointerDown: (_) => _autoScrollTimer?.cancel(),
//               onPointerUp: (_) => _startAutoScroll(banners.length),
//               onPointerCancel: (_) => _startAutoScroll(banners.length),
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemBuilder: (context, index) {
//                   final realIndex = index % banners.length;
//
//                   return CachedNetworkImage(
//                     imageUrl: banners[realIndex].cleanImageUrl!,
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),
//                     errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }




import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gnw/Models/Sponsor_model.dart';
import 'package:gnw/services/auth_provider.dart';

final sponsorProvider = FutureProvider.autoDispose<List<SponsorModel>>((ref) async {
  final timer = Timer(const Duration(seconds: 300), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());
  return await AuthService.fetchSponsor();
});

final categorySponsorProvider = FutureProvider.family.autoDispose<List<SponsorModel>, int>((ref, categoryId) async {
  final timer = Timer(const Duration(seconds: 300), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());
  return await AuthService.fetchSponsorsByCategory(categoryId);
});

class SponsorBannerWidget extends ConsumerStatefulWidget {
  final String bannerType;
  final double aspectRatio;
  final int scrollSeconds;
  final int? categoryId;

  const SponsorBannerWidget({
    super.key,
    required this.bannerType,
    this.aspectRatio = 16 / 6,
    this.scrollSeconds = 6,
    this.categoryId,
  });

  @override
  ConsumerState<SponsorBannerWidget> createState() => _SponsorBannerWidgetState();
}

class _SponsorBannerWidgetState extends ConsumerState<SponsorBannerWidget> {
  final PageController _pageController = PageController(initialPage: 1000);
  Timer? _autoScrollTimer;

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll(int itemCount) {
    _autoScrollTimer?.cancel();
    if (itemCount <= 1 || widget.bannerType == "PRIME SPOTLIGHT") return;

    _autoScrollTimer = Timer.periodic(Duration(seconds: widget.scrollSeconds), (timer) {
      if (mounted && _pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<SponsorModel>> sponsorAsync = widget.categoryId != null
        ? ref.watch(categorySponsorProvider(widget.categoryId!))
        : ref.watch(sponsorProvider);

    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: sponsorAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),

          error: (err, stack) => Image.asset(
            "lib/images/premium.jpeg",
            fit: BoxFit.cover,
          ),

          data: (allSponsors) {
            final banners = allSponsors.where((s) =>
            s.sponsorType == widget.bannerType &&
                s.isActive &&
                s.cleanImageUrl != null
            ).toList();

            if (banners.isEmpty) {
              return Image.asset(
                "lib/images/premium.jpeg",
                fit: BoxFit.cover,
              );
            }

            if (widget.bannerType == "PRIME SPOTLIGHT" || banners.length == 1) {
              _autoScrollTimer?.cancel();
              return CachedNetworkImage(
                imageUrl: banners.first.cleanImageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),

                errorWidget: (context, url, error) => Image.asset(
                  "lib/images/premium.jpeg",
                  fit: BoxFit.cover,
                ),
              );
            }

            if (_autoScrollTimer == null) _startAutoScroll(banners.length);

            return Listener(
              onPointerDown: (_) => _autoScrollTimer?.cancel(),
              onPointerUp: (_) => _startAutoScroll(banners.length),
              onPointerCancel: (_) => _startAutoScroll(banners.length),
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final realIndex = index % banners.length;

                  return CachedNetworkImage(
                    imageUrl: banners[realIndex].cleanImageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFA726))),

                    errorWidget: (context, url, error) => Image.asset(
                      "lib/images/premium.jpeg",
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}