class ApiConfig {
  // For Windows desktop/web connecting to local Laravel server
  static const String baseUrl = 'http://localhost:8000/api';
  
  // For Android emulator connecting to local Laravel server
  // static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // For iOS simulator connecting to local Laravel server
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // For physical device on same network (replace with your computer's IP)
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  // Request timeout duration
  static const Duration timeout = Duration(seconds: 30);
  
  // Common headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
