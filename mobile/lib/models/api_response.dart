class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? true,
      message: json['message'],
      data: json['data'] != null && fromJsonT != null 
          ? fromJsonT(json['data']) 
          : json['data'],
      errors: json['errors'],
    );
  }
}

class PaginatedResponse<T> {
  final int currentPage;
  final List<T> data;
  final int firstPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMorePages;

  PaginatedResponse({
    required this.currentPage,
    required this.data,
    required this.firstPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMorePages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final dataList = (json['data'] as List)
        .map((item) => fromJsonT(item as Map<String, dynamic>))
        .toList();

    return PaginatedResponse<T>(
      currentPage: json['current_page'],
      data: dataList,
      firstPage: 1,
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
      hasMorePages: json['current_page'] < json['last_page'],
    );
  }
}
