// import 'package:flutter/material.dart';
//
// class FullScreenImageViewer extends StatelessWidget {
//   final ImageProvider imageProvider;
//   final String heroTag;
//
//   const FullScreenImageViewer({
//     super.key,
//     required this.imageProvider,
//     required this.heroTag, required String imageUrl,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black, // Classic dark background for image viewing
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: Center(
//         // InteractiveViewer handles all the pinch-to-zoom and panning automatically!
//         child: InteractiveViewer(
//           panEnabled: true, // Allow user to drag the image around when zoomed in
//           minScale: 0.5,    // Allow slight zooming out
//           maxScale: 4.0,    // Allow zooming in up to 4x
//           child: Hero(
//             tag: heroTag,
//             child: Image(
//               image: imageProvider,
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }











import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl; // <-- Changed from ImageProvider to String
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Classic dark background for image viewing
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        // InteractiveViewer handles all the pinch-to-zoom and panning automatically!
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: Hero(
            tag: heroTag,
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.contain,
              // Show a spinner if it somehow hasn't cached yet
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFA726)),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey, size: 50),
            )
                : Image.asset(
              'lib/images/sample.jpeg', // Fallback if no URL
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}