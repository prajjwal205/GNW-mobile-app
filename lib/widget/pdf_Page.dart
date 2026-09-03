// // import 'dart:io';
// // import 'dart:ui';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart'; // 🚀 HapticFeedback (Vibration) ke liye zaroori
// // import 'package:http/http.dart' as http;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:open_filex/open_filex.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// //
// // import '../utils/responsive_helper.dart';
// // import '../widget/customAppBar.dart';
// //
// // class PdfViewerPage extends StatefulWidget {
// //   final String pdfUrl;
// //   final String title;
// //   const PdfViewerPage({super.key, required this.pdfUrl, required this.title});
// //
// //   @override
// //   State<PdfViewerPage> createState() => _PdfViewerPageState();
// // }
// //
// // class _PdfViewerPageState extends State<PdfViewerPage> {
// //   final PdfViewerController _pdfViewerController = PdfViewerController();
// //   final TextEditingController _searchController = TextEditingController();
// //   PdfTextSearchResult _searchResult = PdfTextSearchResult();
// //
// //   bool _isSearching = false;
// //
// //   void _performSearch(String query) async {
// //     if (query.isNotEmpty) {
// //       _searchResult = await _pdfViewerController.searchText(query);
// //       setState(() {});
// //     }
// //   }
// //
// //   // ==============================
// //   // 🚀 SERVER SE DOWNLOAD & OPEN LOGIC
// //   // ==============================
// //   Future<void> _downloadAndOpenPdf() async {
// //     try {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text('Downloading file... Please wait ⏳'),
// //           duration: Duration(seconds: 3),
// //         ),
// //       );
// //
// //       // 1. URL se data fetch kiya
// //       final response = await http.get(Uri.parse(widget.pdfUrl));
// //
// //       // 2. Status code check kiya
// //       if (response.statusCode == 200) {
// //         final Directory tempDir = await getTemporaryDirectory();
// //         final File file = File('${tempDir.path}/${widget.title.replaceAll(" ", "_")}.pdf');
// //
// //         // 3. Network ke bytes ko file mein likha (Purana rootBundle hata diya)
// //         await file.writeAsBytes(response.bodyBytes);
// //
// //         // 4. File open ki
// //         final result = await OpenFilex.open(file.path);
// //
// //         if (result.type != ResultType.done && mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('No PDF viewer app found on your phone!')),
// //           );
// //         }
// //       } else {
// //         if (mounted) {
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text('Failed to download PDF from server!')),
// //           );
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint("Error downloading file: $e");
// //     }
// //   }
// //
// //   // ==============================
// //   // 🍏 PREMIUM iOS STYLE BUTTON WIDGET
// //   // ==============================
// //   Widget _buildPremiumIconButton({
// //     required IconData icon,
// //     required VoidCallback onTap,
// //     double size = 46,
// //     Color iconColor = Colors.white,
// //     Color? bgColor,
// //   }) {
// //     return ClipOval(
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// //         child: InkWell(
// //           onTap: onTap,
// //           splashColor: Colors.white24,
// //           child: Container(
// //             width: size,
// //             height: size,
// //             decoration: BoxDecoration(
// //               shape: BoxShape.circle,
// //               color: bgColor ?? Colors.black.withOpacity(0.5),
// //               border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
// //             ),
// //             child: Icon(icon, color: iconColor, size: size * 0.45),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF5F7FA),
// //       appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
// //       body: Stack(
// //         children: [
// //           // 1. Asli PDF Viewer (NETWORK PAR SET KIYA HAI)
// //           SfPdfViewer.network(
// //             widget.pdfUrl, // 🚀 Yahan hum server link bhej rahe hain
// //             controller: _pdfViewerController,
// //             canShowScrollHead: false,
// //           ),
// //
// //           // 2. Search Bar Overlay (Sleek & Minimalist)
// //           if (_isSearching)
// //             Positioned(
// //               top: 10,
// //               left: 16,
// //               right: 16,
// //               child: ClipRRect(
// //                 borderRadius: BorderRadius.circular(20),
// //                 child: BackdropFilter(
// //                   filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
// //                   child: Container(
// //                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
// //                     decoration: BoxDecoration(
// //                       color: Colors.white.withOpacity(0.85),
// //                       borderRadius: BorderRadius.circular(20),
// //                       border: Border.all(color: Colors.grey.withOpacity(0.2)),
// //                       boxShadow: [
// //                         BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
// //                       ],
// //                     ),
// //                     child: Row(
// //                       children: [
// //                         Expanded(
// //                           child: TextField(
// //                             controller: _searchController,
// //                             autofocus: true,
// //                             style: const TextStyle(fontSize: 15),
// //                             decoration: const InputDecoration(
// //                               hintText: 'Search',
// //                               border: InputBorder.none,
// //                               isDense: true,
// //                             ),
// //                             onSubmitted: _performSearch,
// //                             onChanged: (value) {
// //                               if (value.isEmpty) {
// //                                 setState(() {
// //                                   _searchResult.clear();
// //                                 });
// //                               }
// //                             },
// //                           ),
// //                         ),
// //                         if (_searchResult.hasResult)
// //                           Text(
// //                             '${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
// //                             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 13),
// //                           ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //         ],
// //       ),
// //
// //       // ==============================
// //       // 🚀 IPHONE STYLE FLOATING BUTTONS
// //       // ==============================
// //       floatingActionButton: Padding(
// //         padding: const EdgeInsets.only(bottom: 10),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: [
// //
// //             // UP/DOWN Navigation buttons for search
// //             if (_isSearching && _searchResult.hasResult) ...[
// //               _buildPremiumIconButton(
// //                 size: 38,
// //                 icon: Icons.keyboard_arrow_up,
// //                 onTap: () async {
// //                   await HapticFeedback.heavyImpact();
// //                   _searchResult.previousInstance();
// //                   setState(() {});
// //                 },
// //               ),
// //               const SizedBox(height: 8),
// //
// //               _buildPremiumIconButton(
// //                 size: 38,
// //                 icon: Icons.keyboard_arrow_down,
// //                 onTap: () async {
// //                   await HapticFeedback.vibrate();
// //                   _searchResult.nextInstance();
// //                   setState(() {});
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //             ],
// //
// //             // 🔍 SEARCH BUTTON
// //             _buildPremiumIconButton(
// //               icon: _isSearching ? Icons.close : Icons.search_rounded,
// //               bgColor: _isSearching ? Colors.redAccent.withOpacity(0.8) : null,
// //               onTap: () {
// //                 setState(() {
// //                   _isSearching = !_isSearching;
// //                   if (!_isSearching) {
// //                     _searchController.clear();
// //                     _searchResult.clear();
// //                   }
// //                 });
// //               },
// //             ),
// //
// //             const SizedBox(height: 10),
// //
// //             // ⬇️ DOWNLOAD BUTTON
// //             // _buildPremiumIconButton(
// //             //   icon: Icons.file_download_outlined,
// //             //   bgColor: Colors.blueAccent.withOpacity(0.8),
// //             //   onTap: _downloadAndOpenPdf,
// //             // ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:screen_protector/screen_protector.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
//
// import '../utils/responsive_helper.dart';
// import '../widget/customAppBar.dart';
//
// class PdfViewerPage extends StatefulWidget {
//   final String pdfUrl;
//   final String title;
//   const PdfViewerPage({super.key, required this.pdfUrl, required this.title});
//
//   @override
//   State<PdfViewerPage> createState() => _PdfViewerPageState();
// }
//
// class _PdfViewerPageState extends State<PdfViewerPage> {
//   final PdfViewerController _pdfViewerController = PdfViewerController();
//   final TextEditingController _searchController = TextEditingController();
//   PdfTextSearchResult _searchResult = PdfTextSearchResult();
//
//   bool _isSearching = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _secureScreenOn(); // 🚀 Page khulte hi screenshot block
//   }
//
//   @override
//   void dispose() {
//     _secureScreenOnClear(); // 🚀 Page band hote hi normal kar do
//     _pdfViewerController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // 🔒 ANDROID SCREENSHOT BLOCKING FUNCTION
//   Future<void> _secureScreenOn() async {
//     await ScreenProtector.protectDataLeakageOn();
//   }
//
//   // 🔓 RESTORE NORMAL SCREEN BEHAVIOR ON EXIT
//   Future<void> _secureScreenOnClear() async {
//     await ScreenProtector.protectDataLeakageOff();
//   }
//
//   void _performSearch(String query) async {
//     if (query.isNotEmpty) {
//       _searchResult = await _pdfViewerController.searchText(query);
//       setState(() {});
//     }
//   }
//
//   // ==============================
//   // 🚀 SERVER SE DOWNLOAD & OPEN LOGIC
//   // ==============================
//   Future<void> _downloadAndOpenPdf() async {
//     try {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Downloading file... Please wait ⏳'),
//           duration: Duration(seconds: 3),
//         ),
//       );
//
//       final response = await http.get(Uri.parse(widget.pdfUrl));
//
//       if (response.statusCode == 200) {
//         final Directory tempDir = await getTemporaryDirectory();
//         final File file = File('${tempDir.path}/${widget.title.replaceAll(" ", "_")}.pdf');
//
//         await file.writeAsBytes(response.bodyBytes);
//         final result = await OpenFilex.open(file.path);
//
//         if (result.type != ResultType.done && mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('No PDF viewer app found on your phone!')),
//           );
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Failed to download PDF from server!')),
//           );
//         }
//       }
//     } catch (e) {
//       debugPrint("Error downloading file: $e");
//     }
//   }
//
//   // ==============================
//   // 🍏 PREMIUM iOS STYLE BUTTON WIDGET
//   // ==============================
//   Widget _buildPremiumIconButton({
//     required IconData icon,
//     required VoidCallback onTap,
//     double size = 46,
//     Color iconColor = Colors.white,
//     Color? bgColor,
//   }) {
//     return ClipOval(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: InkWell(
//           onTap: onTap,
//           splashColor: Colors.white24,
//           child: Container(
//             width: size,
//             height: size,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: bgColor ?? Colors.black.withOpacity(0.5),
//               border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
//             ),
//             child: Icon(icon, color: iconColor, size: size * 0.45),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
//       body: Stack(
//         children: [
//           // 1. Asli PDF Viewer
//           SfPdfViewer.network(
//             widget.pdfUrl,
//             controller: _pdfViewerController,
//             canShowScrollHead: false,
//           ),
//
//           // 2. Search Bar Overlay
//           if (_isSearching)
//             Positioned(
//               top: 10,
//               left: 16,
//               right: 16,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.85),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.grey.withOpacity(0.2)),
//                       boxShadow: [
//                         BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _searchController,
//                             autofocus: true,
//                             style: const TextStyle(fontSize: 15),
//                             decoration: const InputDecoration(
//                               hintText: 'Search',
//                               border: InputBorder.none,
//                               isDense: true,
//                             ),
//                             onSubmitted: _performSearch,
//                             onChanged: (value) {
//                               if (value.isEmpty) {
//                                 setState(() {
//                                   _searchResult.clear();
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                         if (_searchResult.hasResult)
//                           Text(
//                             '${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
//                             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 13),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//
//       // ==============================
//       // 🚀 IPHONE STYLE FLOATING BUTTONS
//       // ==============================
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(bottom: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//
//             if (_isSearching && _searchResult.hasResult) ...[
//               _buildPremiumIconButton(
//                 size: 38,
//                 icon: Icons.keyboard_arrow_up,
//                 onTap: () async {
//                   await HapticFeedback.heavyImpact();
//                   _searchResult.previousInstance();
//                   setState(() {});
//                 },
//               ),
//               const SizedBox(height: 8),
//
//               _buildPremiumIconButton(
//                 size: 38,
//                 icon: Icons.keyboard_arrow_down,
//                 onTap: () async {
//                   await HapticFeedback.vibrate();
//                   _searchResult.nextInstance();
//                   setState(() {});
//                 },
//               ),
//               const SizedBox(height: 12),
//             ],
//
//             // 🔍 SEARCH BUTTON
//             _buildPremiumIconButton(
//               icon: _isSearching ? Icons.close : Icons.search_rounded,
//               bgColor: _isSearching ? Colors.redAccent.withOpacity(0.8) : null,
//               onTap: () {
//                 setState(() {
//                   _isSearching = !_isSearching;
//                   if (!_isSearching) {
//                     _searchController.clear();
//                     _searchResult.clear();
//                   }
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../utils/responsive_helper.dart';
import '../widget/customAppBar.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;
  const PdfViewerPage({super.key, required this.pdfUrl, required this.title});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  final TextEditingController _searchController = TextEditingController();
  PdfTextSearchResult _searchResult = PdfTextSearchResult();

  bool _isSearching = false;

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.isNotEmpty) {
      _searchResult = await _pdfViewerController.searchText(query);
      setState(() {});
    }
  }

  // ==============================
  // 🚀 SERVER SE DOWNLOAD & OPEN LOGIC
  // ==============================
  Future<void> _downloadAndOpenPdf() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Downloading file... Please wait ⏳'),
          duration: Duration(seconds: 3),
        ),
      );

      final response = await http.get(Uri.parse(widget.pdfUrl));

      if (response.statusCode == 200) {
        final Directory tempDir = await getTemporaryDirectory();
        final File file = File('${tempDir.path}/${widget.title.replaceAll(" ", "_")}.pdf');

        await file.writeAsBytes(response.bodyBytes);
        final result = await OpenFilex.open(file.path);

        if (result.type != ResultType.done && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No PDF viewer app found on your phone!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to download PDF from server!')),
          );
        }
      }
    } catch (e) {
      debugPrint("Error downloading file: $e");
    }
  }

  // ==============================
  // 🍏 PREMIUM iOS STYLE BUTTON WIDGET
  // ==============================
  Widget _buildPremiumIconButton({
    required IconData icon,
    required VoidCallback onTap,
    double size = 46,
    Color iconColor = Colors.white,
    Color? bgColor,
  }) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.white24,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor ?? Colors.black.withOpacity(0.5),
              border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
            ),
            child: Icon(icon, color: iconColor, size: size * 0.45),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(appBarHeight: ResponsiveHelper.getAppBarHeight(context)),
      body: Stack(
        children: [
          // 1. Asli PDF Viewer
          SfPdfViewer.network(
            widget.pdfUrl,
            controller: _pdfViewerController,
            canShowScrollHead: false,
          ),

          // 2. Search Bar Overlay
          if (_isSearching)
            Positioned(
              top: 10,
              left: 16,
              right: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: _performSearch,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                setState(() {
                                  _searchResult.clear();
                                });
                              }
                            },
                          ),
                        ),
                        if (_searchResult.hasResult)
                          Text(
                            '${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 13),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      // ==============================
      // 🚀 IPHONE STYLE FLOATING BUTTONS
      // ==============================
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            if (_isSearching && _searchResult.hasResult) ...[
              _buildPremiumIconButton(
                size: 38,
                icon: Icons.keyboard_arrow_up,
                onTap: () async {
                  await HapticFeedback.heavyImpact();
                  _searchResult.previousInstance();
                  setState(() {});
                },
              ),
              const SizedBox(height: 8),

              _buildPremiumIconButton(
                size: 38,
                icon: Icons.keyboard_arrow_down,
                onTap: () async {
                  await HapticFeedback.vibrate();
                  _searchResult.nextInstance();
                  setState(() {});
                },
              ),
              const SizedBox(height: 12),
            ],

            // 🔍 SEARCH BUTTON
            _buildPremiumIconButton(
              icon: _isSearching ? Icons.close : Icons.search_rounded,
              bgColor: _isSearching ? Colors.redAccent.withOpacity(0.8) : null,
              onTap: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _searchResult.clear();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}