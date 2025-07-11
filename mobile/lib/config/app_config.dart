import 'dart:io';
import 'package:flutter/foundation.dart';

/// Application configuration constants and settings
class AppConfig {
  // App Information
  static const String appName = 'Task Management System';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // API Configuration
  static const String apiVersion = 'v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int itemsPerPage = 10;

  // Platform-specific API URLs
  static const String _localhostUrl = 'http://localhost:8000/api';
  static const String _androidEmulatorUrl = 'http://10.0.2.2:8000/api';
  static const String _iosSimulatorUrl = 'http://127.0.0.1:8000/api';

  /// Get the appropriate API base URL based on the current platform
  static String get apiBaseUrl {
    if (kIsWeb) {
      return _localhostUrl;
    } else if (Platform.isAndroid) {
      return _androidEmulatorUrl;
    } else if (Platform.isIOS) {
      return _iosSimulatorUrl;
    } else {
      return _localhostUrl; // Desktop platforms
    }
  }

  // Custom URL override for testing
  static String _customApiUrl = '';

  /// Set a custom API URL for testing purposes
  static void setCustomApiUrl(String url) {
    _customApiUrl = url;
  }

  /// Get the effective API URL (custom if set, otherwise platform-specific)
  static String get effectiveApiUrl {
    return _customApiUrl.isNotEmpty ? _customApiUrl : apiBaseUrl;
  }

  /// Clear custom API URL
  static void clearCustomApiUrl() {
    _customApiUrl = '';
  }

  // Development settings
  static const bool enableDebugMode = kDebugMode;
  static const bool enableLogging = kDebugMode;

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Common HTTP headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Error messages
  static const String networkErrorMessage =
      'Network error. Please check your internet connection.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String unknownErrorMessage =
      'An unknown error occurred. Please try again.';
}
