import 'package:flutter/material.dart';

class ChatSupportPage extends StatefulWidget {
  const ChatSupportPage({super.key});

  @override
  _ChatSupportPageState createState() => _ChatSupportPageState();
}

class _ChatSupportPageState extends State<ChatSupportPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;
  late AnimationController _dotController;

  final Color backgroundDark = const Color(0xFF0A0A12);
  final Color bubbleUser = const Color(0xFFFFD700);
  final Color bubbleBot = const Color(0xFF1E1E2A);
  final Color inputBackground = const Color(0xFF1B1B24);
  final Color neonAccent = const Color(0xFFFFD700);

  @override
  void initState() {
    super.initState();

    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _addBotGreeting();
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  void _addBotGreeting() {
    setState(() => _isBotTyping = true);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isBotTyping = false;
        _messages.add({
          "sender": "bot",
          "text": "👋 Hello! Welcome to Skymiles Support. How can I help you today?",
        });
      });
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() => _messages.add({"sender": "user", "text": text}));
    _controller.clear();
    setState(() => _isBotTyping = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      String botReply = _generateBotReply(text);
      setState(() {
        _isBotTyping = false;
        _messages.add({"sender": "bot", "text": botReply});
      });
    });
  }

  String _generateBotReply(String userMessage) {
    String msg = userMessage.toLowerCase();
    if (msg.contains("book") || msg.contains("flight")) {
      return "🛫 Sure! I can help you with bookings. Could you tell me your travel dates and destination?";
    } else if (msg.contains("cancel")) {
      return "❌ I can assist you with cancellations. Please provide your booking reference number.";
    } else if (msg.contains("miles") || msg.contains("reward")) {
      return "💎 You can view and redeem your miles in the Rewards section of the app.";
    } else if (msg.contains("hello") || msg.contains("hi")) {
      return "👋 Hello there! How can I help you today?";
    } else if (msg.contains("thank")) {
      return "😊 You're most welcome! Is there anything else I can help you with?";
    }
    return "✈ I'm here to help! Could you please provide more details about your request?";
  }

  Widget _typingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _dotController,
          builder: (context, child) {
            double value = _dotController.value;
            double opacity = (value * 3 - index).clamp(0.0, 1.0).toDouble();
            return Opacity(
              opacity: opacity,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  "•",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: [bubbleUser.withOpacity(0.9), bubbleUser.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [bubbleBot.withOpacity(0.85), bubbleBot.withOpacity(0.65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 20 : 4),
            topRight: Radius.circular(isUser ? 4 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: isUser ? bubbleUser.withOpacity(0.4) : Colors.black26,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      appBar: AppBar(
        title: const Text('Chat Support'),
        backgroundColor: neonAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isBotTyping && index == _messages.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [bubbleBot.withOpacity(0.8), bubbleBot.withOpacity(0.6)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _typingIndicator(),
                      ),
                    ),
                  );
                }
                final message = _messages[index];
                bool isUser = message["sender"] == "user";
                return _buildBubble(message["text"]!, isUser);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: inputBackground,
              boxShadow: [
                BoxShadow(
                  color: neonAccent.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: inputBackground.withOpacity(0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [neonAccent.withOpacity(0.9), neonAccent.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: neonAccent.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
