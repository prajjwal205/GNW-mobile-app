import 'package:flutter/material.dart';

class Sucessbutton {
  static OverlayEntry? _currentToast;

  static void show(BuildContext context, {required String message, bool isError = false}) {
    if (_currentToast != null) {
      _currentToast!.remove();
      _currentToast = null;
    }

    final overlay = Overlay.of(context);

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        bottom: 0,
        left: 20,
        right: 20,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value, // Scale ko bounce karne do
                child: Opacity(
                  // 🚀 FIX: Opacity ko strictly 0.0 aur 1.0 ke beech limit kar diya
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isError ? Colors.black87 : Colors.red,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isError ? Icons.error_outline : Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentToast!);

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentToast != null) {
        _currentToast!.remove();
        _currentToast = null;
      }
    });
  }
}