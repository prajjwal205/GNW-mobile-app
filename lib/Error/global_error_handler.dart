import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GlobalErrorHandler {
  static void initialize() {
    // 1. FLUTTER UI ERRORS
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
      Fluttertoast.showToast(
        msg: "UI Crash: ${details.exceptionAsString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    };

    // 2. BACKGROUND DART ERRORS
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      Fluttertoast.showToast(
        msg: "Background Error: $error",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
      return true;
    };

    // 3. CUSTOM ERROR SCREEN (Red Screen Override)
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: SafeArea(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 50),
                  const SizedBox(height: 10),
                  const Text(
                    "🚨 APP CRASHED!",
                    style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Error: \n${details.exceptionAsString()}",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text("Stack Trace:", style: TextStyle(color: Colors.yellow, fontSize: 14)),
                  const SizedBox(height: 10),
                  Text(
                    details.stack.toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    };
  }
}