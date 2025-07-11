import 'app_config.dart';

/// Network-related configuration and constants
class NetworkConfig {
  // API Endpoints
  static const String tasksEndpoint = '/tasks';
  static const String authEndpoint = '/auth';

  /// Get full API URL for a specific endpoint
  static String getApiUrl(String endpoint) {
    return '${AppConfig.effectiveApiUrl}$endpoint';
  }

  /// Get tasks API URL with optional query parameters
  static String getTasksUrl({
    int? page,
    String? status,
    String? priority,
    String? search,
  }) {
    final uri = Uri.parse(getApiUrl(tasksEndpoint));
    final queryParams = <String, String>{};

    if (page != null) queryParams['page'] = page.toString();
    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (priority != null && priority.isNotEmpty) {
      queryParams['priority'] = priority;
    }
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    return uri.replace(queryParameters: queryParams).toString();
  }

  /// Get single task URL
  static String getTaskUrl(int taskId) {
    return '${getApiUrl(tasksEndpoint)}/$taskId';
  }

  // HTTP Status Codes
  static const int statusOk = 200;
  static const int statusCreated = 201;
  static const int statusNoContent = 204;
  static const int statusBadRequest = 400;
  static const int statusUnauthorized = 401;
  static const int statusForbidden = 403;
  static const int statusNotFound = 404;
  static const int statusInternalServerError = 500;

  /// Check if HTTP status code indicates success
  static bool isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if HTTP status code indicates client error
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if HTTP status code indicates server error
  static bool isServerError(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }
}
