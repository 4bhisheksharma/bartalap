import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../theme/my_app_theme.dart';

class ChatScreen extends StatefulWidget {
  final User peerUser;
  const ChatScreen({super.key, required this.peerUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _messageController = TextEditingController();
  late WebSocketChannel _channel;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _initWebSocket();
  }

  void _initWebSocket() async {
    _channel = await _apiService.connectWebSocket();
    _channel.stream.listen(
      (data) {
        try {
          final decoded = jsonDecode(data);
          if (decoded['error'] != null) {
            // Handle error from server
            debugPrint('WebSocket error: ${decoded['error']}');
            return;
          }
          setState(() {
            _messages.add({
              'username': decoded['username'] ?? 'Unknown',
              'message': decoded['message'] ?? '',
              'timestamp': decoded['timestamp'],
            });
          });
        } catch (e) {
          debugPrint('Error parsing WebSocket message: $e');
        }
      },
      onError: (error) {
        debugPrint('WebSocket error: $error');
      },
      onDone: () {
        debugPrint('WebSocket connection closed');
      },
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _channel.sink.add(
        jsonEncode({'message': text, 'to': widget.peerUser.username}),
      );
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with ${widget.peerUser.username}',
          style: TextStyle(color: MyAppTheme.whiteColor),
        ),
        backgroundColor: MyAppTheme.mainFontColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['username'] == 'Me';
                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isMe
                          ? MyAppTheme.firstSuggestionBoxColor
                          : MyAppTheme.assistantCircleColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['message'],
                          style: TextStyle(color: MyAppTheme.whiteColor),
                        ),
                        if (msg['timestamp'] != null) ...[
                          SizedBox(height: 4),
                          Text(
                            DateTime.parse(
                              msg['timestamp'],
                            ).toLocal().toString().substring(11, 16),
                            style: TextStyle(
                              color: MyAppTheme.whiteColor.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: MyAppTheme.whiteColor),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: MyAppTheme.whiteColor),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: MyAppTheme.mainFontColor),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
