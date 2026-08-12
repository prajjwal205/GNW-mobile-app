import 'dart:io';
import 'package:flutter/services.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class SecurityConfig {
  static Future<void> setupSecureContext() async{
    try{
      ByteData data = await rootBundle.load('assets/security_certificate.crt');

      SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
      debugPrint("SSL Certificate successfully loaded!");
    } catch (error, s) {
      debugPrint("❌ CRITICAL SECURITY ERROR: Certificate load failed!");
      debugPrint("Error: $error");
      throw Exception('Security Context Initialization Failed: $error');
      await FirebaseCrashlytics.instance.recordError(error, s);
    }
  }
}