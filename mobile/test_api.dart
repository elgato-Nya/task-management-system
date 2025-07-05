import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() async {
  print('Testing API connection...');
  
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
    
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print('Success: ${jsonData['success']}');
      if (jsonData['data'] != null && jsonData['data']['data'] != null) {
        print('Tasks count: ${jsonData['data']['data'].length}');
      }
    }
  } on SocketException catch (e) {
    print('Socket Exception: $e');
    print('This usually means the server is not reachable.');
  } on http.ClientException catch (e) {
    print('Client Exception: $e');
    print('This usually means connection failed.');
  } catch (e) {
    print('Error: $e');
  }
}
