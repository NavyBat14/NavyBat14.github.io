import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  bool _isBotTyping = false;
  late AnimationController _dotController;

  final List<Map<String, dynamic>> quickReplies = [
    {"text": "Information", "icon": Icons.info_outline},
    {"text": "Flight Booking", "icon": Icons.flight_takeoff},
    {"text": "Flight Status", "icon": Icons.schedule},
    {"text": "Reschedule / Cancel", "icon": Icons.edit_calendar},
    {"text": "Check-in & Boarding Pass", "icon": Icons.airplane_ticket},
    {"text": "Feedback / Complaint", "icon": Icons.feedback_outlined},
    {"text": "Offers & Deals", "icon": Icons.local_offer_outlined},
    {"text": "Loyalty Program", "icon": Icons.card_giftcard},
  ];

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 500), () {
      _sendBotMessage(
        "👋 Hello! Welcome to Skymiles Support. How can I help you today?",
      );
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": text});
    });
    _controller.clear();

    setState(() => _isBotTyping = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      String response = _generateBotReply(text);
      _sendBotMessage(response);
    });
  }

  void _sendBotMessage(String text) {
    setState(() {
      _isBotTyping = false;
      _messages.add({"sender": "bot", "text": text});
    });
  }

  String _generateBotReply(String query) {
    query = query.toLowerCase();
    if (query.contains("information")) {
      return "You can ask me about airline information, airport navigation, or flight details.";
    } else if (query.contains("book") || query.contains("flight booking")) {
      return "Sure! Please provide your departure, arrival, and travel date so I can help you book a flight.";
    } else if (query.contains("status")) {
      return "I can give you real-time updates on delays, cancellations, or schedule changes.";
    } else if (query.contains("reschedule") || query.contains("cancel")) {
      return "You can easily reschedule or cancel your flights here. Just provide your booking reference (PNR).";
    } else if (query.contains("check-in") || query.contains("boarding pass")) {
      return "I can help you check-in and generate a digital boarding pass. Please share your booking reference (PNR).";
    } else if (query.contains("feedback") || query.contains("complaint")) {
      return "You can leave feedback or complaints here, and I’ll forward them to the right department.";
    } else if (query.contains("offers") || query.contains("deals")) {
      return "I can show you personalized offers, discounts, and loyalty rewards based on your travel history.";
    } else if (query.contains("loyalty") || query.contains("miles")) {
      return "You can check loyalty points, redeem miles, and view reward tiers directly with me.";
    }
    return "I'm not sure I understand. Can you rephrase?";
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
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Airline Chatbot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isBotTyping && index == _messages.length) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _typingIndicator(),
                    ),
                  );
                }

                final message = _messages[index];
                final isUser = message["sender"] == "user";
                return Container(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message["text"] ?? ""),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = quickReplies[index];
                return ElevatedButton.icon(
                  onPressed: () => _sendMessage(item["text"]),
                  icon: Icon(item["icon"], size: 16, color: Colors.white),
                  label: Text(
                    item["text"],
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemCount: quickReplies.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me something...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
