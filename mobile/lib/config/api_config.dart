import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  // Dynamic base URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      // Web
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      // Android emulator
      return 'http://10.0.2.2:8000/api';
    } else if (Platform.isIOS) {
      // iOS simulator
      return 'http://127.0.0.1:8000/api';
    } else {
      // Desktop (Windows, macOS, Linux)
      return 'http://localhost:8000/api';
    }
  }

  // Use this method to override the base URL for testing
  static String _customBaseUrl = '';
  static void setCustomBaseUrl(String url) {
    _customBaseUrl = url;
  }

  static String get effectiveBaseUrl {
    return _customBaseUrl.isNotEmpty ? _customBaseUrl : baseUrl;
  }

  // Request timeout duration
  static const Duration timeout = Duration(seconds: 30);

  // Common headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
