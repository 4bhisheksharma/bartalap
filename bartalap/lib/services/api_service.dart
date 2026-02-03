import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Message {
  final int id;
  final String username;
  final String content;
  final DateTime timestamp;

  Message({required this.id, required this.username, required this.content, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      username: json['username'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  static const String wsUrl = 'ws://10.0.2.2:8000/ws/chat/';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<http.Response> _post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> _get(String endpoint) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<http.Response> _postAuthenticated(String endpoint, Map<String, dynamic> body) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<String> register(String username, String password) async {
    final response = await _post('/api/register/', {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 201) {
      return 'Registration successful';
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<String> login(String username, String password) async {
    final response = await _post('/api/login/', {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access'];
      await _saveToken(token);
      return token;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<List<Message>> getMessages() async {
    final response = await _get('/api/messages/');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages: ${response.body}');
    }
  }

  Future<void> sendMessage(String message) async {
    final response = await _postAuthenticated('/api/messages/', {
      'content': message,
    });

    if (response.statusCode != 201) {
      throw Exception('Failed to send message: ${response.body}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<WebSocketChannel> connectWebSocket() async {
    final token = await _getToken();
    return WebSocketChannel.connect(
      Uri.parse('$wsUrl?token=$token'),
    );
  }
}
