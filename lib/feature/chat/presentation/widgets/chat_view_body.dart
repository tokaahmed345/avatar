import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/feature/chat/presentation/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatViewBody extends StatefulWidget {
  const ChatViewBody({super.key, required this.isChatOpen, required this.onClose});
  final bool isChatOpen;
  final VoidCallback onClose;
  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
      final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [
  ];
  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              bottom: widget.isChatOpen ? 0 : -280,
              left: 0,
              right: 0,
              child: Container(
                height: 260,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [

                 
    Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(onPressed: (){}, icon:Icon( Icons.mic)),
                Spacer(),
                Text(
                  'Chat',
                  style: AppStyle.text18.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon:  Icon(Icons.close,color: AppColors.blackColor,),
                  onPressed:  widget.onClose
                ),
              ],
            ),
          ),

          const Divider(),
Expanded(
  child: ListView.builder(
    controller: _scrollController,
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    itemCount: messages.length,
    itemBuilder: (context, index) {
      return ChatBubble(
        text: messages[index]["text"],
        isUser: messages[index]["isUser"],
      );
    },
  ),
),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                                controller: _controller,

                              decoration: InputDecoration(
                                hintText: 'Type here...',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                           CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withOpacity(.8),
  child: IconButton(
    icon: const Icon(Icons.upload, color: Colors.white),
    onPressed: _sendMessage,
  ),                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
  }
  void _sendMessage() {
  if (_controller.text.trim().isEmpty) return;

  final userText = _controller.text;

  setState(() {
    messages.add({
      "text": userText,
      "isUser": true,
    });
  });

  _controller.clear();

  Future.delayed(const Duration(milliseconds: 600), () {
    setState(() {
      messages.add({
        "text": "Hello! How can I help you?",
        "isUser": false,
      });
    });

  });
}



  }
