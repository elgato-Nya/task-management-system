import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _status = 'Not tested';
  String _currentUrl = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUrl = ApiConfig.effectiveBaseUrl;
  }

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing connection...';
    });

    try {
      final apiService = ApiService.instance;
      final isConnected = await apiService.testConnection();
      setState(() {
        _status = isConnected
            ? '✅ Connection successful!'
            : '❌ Connection failed';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _testTasksAPI() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing tasks API...';
    });

    try {
      final apiService = ApiService.instance;
      final response = await apiService.getTasks();
      setState(() {
        _status = '✅ Tasks API working! Found ${response.data.length} tasks';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Tasks API Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Connection')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Configuration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Current URL: $_currentUrl'),
                    const SizedBox(height: 8),
                    Text('Platform: ${Theme.of(context).platform.name}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connection Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isLoading ? null : _testConnection,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Test Connection'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _testTasksAPI,
                          child: const Text('Test Tasks API'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Troubleshooting',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Make sure Laravel server is running: php artisan serve',
                    ),
                    const Text(
                      '• Check if you can access http://localhost:8000/api/tasks in browser',
                    ),
                    const Text(
                      '• For Android emulator: Use 10.0.2.2 instead of localhost',
                    ),
                    const Text(
                      '• For physical device: Use your computer\'s IP address',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
