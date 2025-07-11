import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Utility class for logging throughout the application
class Logger {
  /// Private constructor to prevent instantiation
  Logger._();

  /// Log debug messages (only in debug mode)
  static void debug(String message) {
    if (AppConfig.enableLogging && kDebugMode) {
      debugPrint('🐛 [DEBUG] $message');
    }
  }

  /// Log info messages
  static void info(String message) {
    if (AppConfig.enableLogging) {
      debugPrint('ℹ️ [INFO] $message');
    }
  }

  /// Log warning messages
  static void warning(String message) {
    if (AppConfig.enableLogging) {
      debugPrint('⚠️ [WARNING] $message');
    }
  }

  /// Log error messages
  static void error(String message) {
    if (AppConfig.enableLogging) {
      debugPrint('❌ [ERROR] $message');
    }
  }

  /// Log success messages
  static void success(String message) {
    if (AppConfig.enableLogging) {
      debugPrint('✅ [SUCCESS] $message');
    }
  }

  /// Log API request
  static void apiRequest(String method, String url) {
    if (AppConfig.enableLogging && kDebugMode) {
      debugPrint('🌐 [API REQUEST] $method $url');
    }
  }

  /// Log API response
  static void apiResponse(int statusCode, String message) {
    if (AppConfig.enableLogging && kDebugMode) {
      final icon = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
      debugPrint('$icon [API RESPONSE] $statusCode: $message');
    }
  }

  /// Log navigation
  static void navigation(String route) {
    if (AppConfig.enableLogging && kDebugMode) {
      debugPrint('🧭 [NAVIGATION] $route');
    }
  }

  /// Log user action
  static void userAction(String action) {
    if (AppConfig.enableLogging && kDebugMode) {
      debugPrint('👤 [USER ACTION] $action');
    }
  }
}
