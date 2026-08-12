// import 'package:flutter/material.dart';
//
// class CustomErrorWidget extends StatelessWidget {
//   final Object error;
//   final VoidCallback onRetry;
//
//   const CustomErrorWidget({
//     super.key,
//     required this.error,
//     required this.onRetry,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SliverToBoxAdapter(
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red, size: 40),
//               // const SizedBox(height: 10),
//
//               // 🛑 DISPLAY THE ACTUAL ERROR HERE
//               Text(
//                 "\n$error",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const CustomErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final double wScale = MediaQuery.of(context).size.width / 390.0;

    // 1. Raw Error
    String rawError = error.toString();

    // 2. Technical tag 'Exception:' ko hata kar clean code banana
    String cleanErrorCode = rawError.replaceAll('Exception:', '')
        .replaceAll('Exception', '')
        .replaceAll('Timeout:', '')
        .replaceAll('Socket:', '')
        .trim();

    if (cleanErrorCode.startsWith(':') || cleanErrorCode.startsWith(',')) {
      cleanErrorCode = cleanErrorCode.substring(1).trim();
    }

    // 3. User ke liye friendly Main Title nikalna
    String userFriendlyTitle = "Connection Failed";
    if (rawError.toLowerCase().contains("timeout") || rawError.toLowerCase().contains("taking too long")) {
      userFriendlyTitle = "Request Timeout";
    } else if (rawError.toLowerCase().contains("internet") || rawError.toLowerCase().contains("socket")) {
      userFriendlyTitle = "Network Offline";
    } else if (rawError.contains("Code:")) {
      userFriendlyTitle = "System Error";
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0 * wScale, vertical: 40.0 * wScale),
        child: Container(
          padding: EdgeInsets.all(24.0 * wScale),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(16 * wScale),
            border: Border.all(color: Colors.red.shade100, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, size: 48 * wScale, color: Colors.red.shade400),
              SizedBox(height: 16 * wScale),

              // 🚀 User-Friendly Heading
              Text(
                userFriendlyTitle,
                style: TextStyle(
                    fontSize: 18 * wScale,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800
                ),
              ),
              SizedBox(height: 16 * wScale),

              // 🚀 DIAGNOSTIC BOX (Taki aap bug solve kar sako)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10 * wScale, horizontal: 12 * wScale),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8 * wScale),
                  border: Border.all(color: Colors.red.shade200, width: 1.0),
                ),
                child: Column(
                  children: [
                    // Text(
                    //   "SUPPORT REFERENCE",
                    //   style: TextStyle(
                    //     fontSize: 10 * wScale,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.grey.shade500,
                    //     letterSpacing: 1.2,
                    //   ),
                    // ),
                    SizedBox(height: 4 * wScale),
                    Text(
                      cleanErrorCode.isEmpty ? "ERR_UNKNOWN" : cleanErrorCode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13 * wScale,
                        fontFamily: 'Courier', // 🚀 Monospace font code jaisa feel dega
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 24 * wScale),
              //
              // // 🚀 Retry Button
              // ElevatedButton.icon(
              //   onPressed: onRetry,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: Colors.red.shade700,
              //     elevation: 0,
              //     side: BorderSide(color: Colors.red.shade200),
              //     padding: EdgeInsets.symmetric(horizontal: 20 * wScale, vertical: 12 * wScale),
              //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8 * wScale)),
              //   ),
              //   icon: Icon(Icons.refresh_rounded, size: 20 * wScale),
              //   label: Text(
              //     "Retry Connection",
              //     style: TextStyle(fontSize: 14 * wScale, fontWeight: FontWeight.bold),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}