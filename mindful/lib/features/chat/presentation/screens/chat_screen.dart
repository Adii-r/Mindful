import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isTyping = false;

  final List<Map<String, dynamic>> messages = [
    {"message": "Hello! 👋", "isUser": false},
    {"message": "I'm Mindy. What's on your mind?", "isUser": false},
  ];

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {
    final prompt = messageController.text.trim();

    if (prompt.isEmpty) return;

    messageController.clear();

    setState(() {
      messages.add({"message": prompt, "isUser": true});

      isTyping = true;
    });

    scrollToBottom();

    try {
      final reply = await ref.read(chatProvider).sendMessage(prompt);

      if (!mounted) return;

      setState(() {
        isTyping = false;

        messages.add({"message": reply, "isUser": false});
      });

      scrollToBottom();
    } catch (e) {
        if (!mounted) return;

        setState(() {
        isTyping = false;

        messages.add({
        "message": "Sorry, something went wrong.",
        "isUser": false,
        });
        });

        scrollToBottom();
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                itemCount: messages.length + (isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (isTyping && index == messages.length) {
                    return const ChatBubble(
                      message: "Typing...",
                      isUser: false,
                    );
                  }

                  final message = messages[index];

                  return ChatBubble(
                    message: message["message"],
                    isUser: message["isUser"],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                20,
              ),
              child: ChatInput(
                controller: messageController,
                onSend: sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
