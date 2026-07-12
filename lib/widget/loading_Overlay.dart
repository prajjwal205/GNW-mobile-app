import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final VoidCallback onClose;

  const LoadingOverlay({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Center Image
            Center(
              child: FractionallySizedBox(
            widthFactor: .96,
              // heightFactor:1,
              child: Image.asset(
                "lib/images/APP_DESIGN.png",
                fit: BoxFit.contain,
              ),
            ),
            ),
            // iPhone Style Close Button
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: onClose,
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
}