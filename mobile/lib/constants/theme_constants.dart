import 'package:flutter/material.dart';
import 'app_constants.dart';

/// Theme-related constants and configurations
class ThemeConstants {
  /// Private constructor to prevent instantiation
  ThemeConstants._();

  // Color Constants
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color primaryColorDark = Color(0xFF1976D2);
  static const Color primaryColorLight = Color(0xFF64B5F6);

  static const Color secondaryColor = Color(0xFFFFC107);
  static const Color secondaryColorDark = Color(0xFFF57C00);
  static const Color secondaryColorLight = Color(0xFFFFE082);

  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color infoColor = Color(0xFF2196F3);

  // Priority Colors
  static const Color priorityLowColor = Color(0xFF4CAF50);
  static const Color priorityMediumColor = Color(0xFFFF9800);
  static const Color priorityHighColor = Color(0xFFE53935);

  // Status Colors
  static const Color statusPendingColor = Color(0xFF9E9E9E);
  static const Color statusInProgressColor = Color(0xFF2196F3);
  static const Color statusCompletedColor = Color(0xFF4CAF50);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF424242);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x40000000);

  /// Get priority color based on priority string
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case AppConstants.priorityLow:
        return priorityLowColor;
      case AppConstants.priorityMedium:
        return priorityMediumColor;
      case AppConstants.priorityHigh:
        return priorityHighColor;
      default:
        return priorityMediumColor;
    }
  }

  /// Get status color based on status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusPending:
        return statusPendingColor;
      case AppConstants.statusInProgress:
        return statusInProgressColor;
      case AppConstants.statusCompleted:
        return statusCompletedColor;
      default:
        return statusPendingColor;
    }
  }

  /// Get priority icon based on priority string
  static IconData getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case AppConstants.priorityLow:
        return Icons.keyboard_arrow_down;
      case AppConstants.priorityMedium:
        return Icons.drag_handle;
      case AppConstants.priorityHigh:
        return Icons.keyboard_arrow_up;
      default:
        return Icons.drag_handle;
    }
  }

  /// Get status icon based on status string
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusPending:
        return Icons.pending;
      case AppConstants.statusInProgress:
        return Icons.work;
      case AppConstants.statusCompleted:
        return Icons.check_circle;
      default:
        return Icons.pending;
    }
  }

  // Text Styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Button Styles
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: AppConstants.spacingMedium,
    vertical: AppConstants.spacingSmall,
  );

  static const double buttonBorderRadius = AppConstants.borderRadiusLarge;

  // Card Styles
  static const EdgeInsets cardPadding = EdgeInsets.all(
    AppConstants.spacingMedium,
  );
  static const EdgeInsets cardMargin = EdgeInsets.all(
    AppConstants.spacingSmall,
  );
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = AppConstants.borderRadiusLarge;

  // App Bar Styles
  static const double appBarElevation = 0.0;
  static const double appBarHeight = 56.0;
}
