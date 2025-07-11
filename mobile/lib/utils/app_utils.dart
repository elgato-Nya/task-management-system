import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

/// Utility functions for common operations
class AppUtils {
  /// Private constructor to prevent instantiation
  AppUtils._();

  /// Format date to readable string
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Format date for display
  static String formatDisplayDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Check if date is overdue
  static bool isOverdue(DateTime? dueDate) {
    if (dueDate == null) return false;
    return dueDate.isBefore(DateTime.now());
  }

  /// Get days until due date
  static int getDaysUntilDue(DateTime? dueDate) {
    if (dueDate == null) return 0;
    final now = DateTime.now();
    return dueDate.difference(now).inDays;
  }

  /// Capitalize first letter of string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Format task status for display
  static String formatStatus(String status) {
    switch (status.toLowerCase()) {
      case AppConstants.statusPending:
        return 'Pending';
      case AppConstants.statusInProgress:
        return 'In Progress';
      case AppConstants.statusCompleted:
        return 'Completed';
      default:
        return capitalize(status);
    }
  }

  /// Format task priority for display
  static String formatPriority(String priority) {
    switch (priority.toLowerCase()) {
      case AppConstants.priorityLow:
        return 'Low';
      case AppConstants.priorityMedium:
        return 'Medium';
      case AppConstants.priorityHigh:
        return 'High';
      default:
        return capitalize(priority);
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate title length
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppConstants.validationRequired;
    }
    if (value.length > AppConstants.maxTitleLength) {
      return AppConstants.validationTitleTooLong;
    }
    return null;
  }

  /// Validate description length
  static String? validateDescription(String? value) {
    if (value != null && value.length > AppConstants.maxDescriptionLength) {
      return AppConstants.validationDescriptionTooLong;
    }
    return null;
  }

  /// Show snackbar with success message
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppConstants.spacingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
    );
  }

  /// Show snackbar with error message
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppConstants.spacingMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
      ),
    );
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = AppConstants.dialogConfirm,
    String cancelText = AppConstants.dialogCancel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Show loading dialog
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: AppConstants.spacingMedium),
            Text(message),
          ],
        ),
      ),
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Debounce function calls
  static Timer? _debounceTimer;
  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }
}
