
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/feature/chat/presentation/view_model/cubit/message_cubit.dart';
import 'package:avatar/feature/chat/presentation/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class ChatViewBody extends StatefulWidget {
  const ChatViewBody({
    super.key,
    required this.isChatOpen,
    required this.onClose,
    required this.selectedLanguage,
  });

  final bool isChatOpen;
  final VoidCallback onClose;
  final String selectedLanguage;

  @override
  State<ChatViewBody> createState() => _ChatViewBodyState();
}

class _ChatViewBodyState extends State<ChatViewBody> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final SharedPrefs sharedPrefs = getIt.get<SharedPrefs>();

  List<Map<String, dynamic>> messages = [];
  String? businessId;

  @override
  void initState() {
    super.initState();
      messages.add({
    "text": "مرحبًا! كيف يمكنني مساعدتك اليوم؟",
    "isUser": false,
  });
    _loadBusinessId();
  }

  Future<void> _loadBusinessId() async {
    final id = await sharedPrefs.getBusinessId();
    setState(() {
      businessId = id;
    });
    debugPrint('📦 BusinessId: $businessId');
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || businessId == null) return;

    setState(() {
      messages.add({
        "text": text,
        "isUser": true,
      });
    });

    _controller.clear();
    _scrollToBottom();

    final language = detectLanguage(text);

    context.read<MessageCubit>().fetchMessage(
          businessId: businessId!,
          question: text,
          language: language,
        );
  }

  String detectLanguage(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? 'ar' : 'en';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      bottom: widget.isChatOpen ? 0 : -280,
      left: 0,
      right: 0,
      child: Container(
        height: 260,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mic),
                  ),
                  const Spacer(),
                  Text(
                    'Chat',
                    style: AppStyle.text18.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.blackColor),
                    onPressed: (){
    FocusScope.of(context).unfocus(); 
widget.onClose();
                    }
                  ),
                ],
              ),
            ),
            const Divider(),

            Expanded(
              child: BlocConsumer<MessageCubit, MessageState>(
                listener: (context, state) {
                  if (state is MessageLoading) {
                    setState(() {
                      messages.add({
                        "text": "",
                        "isUser": false,
                        "isLoading": true,
                      });
                    });
                    _scrollToBottom();
                  }

                  if (state is MessageSuccess) {
                    setState(() {
                      if (messages.isNotEmpty &&
                          messages.last["isLoading"] == true) {
                        messages.removeLast();
                      }
                      messages.add({
                        "text": state.messages.answer,
                        "isUser": false,
                      });
                    });
                    _scrollToBottom();
                  }

                  if (state is MessageFailure) {
                    setState(() {
                      if (messages.isNotEmpty &&
                          messages.last["isLoading"] == true) {
                        messages.removeLast();
                      }
                      messages.add({
                        "text": state.errMessage,
                        "isUser": false,
                      });
                    });
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      if (message["isLoading"] == true) {
                        return Align(
      alignment: Alignment.centerLeft, 
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300, 
          borderRadius: BorderRadius.circular(16),
        ),
        child:  SizedBox(
          width: 24, 
          height: 24,
          child: SpinKitDoubleBounce(
            color:Colors.grey,
            size: 16,
          ),
        ),
      ),
    );
                      }

                      return ChatBubble(
                        text: message["text"],
                        isUser: message["isUser"],
                      );
                    },
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
                          borderRadius:
                              BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        AppColors.primary.withOpacity(.8),
                    child: IconButton(
                      icon: const Icon(Icons.upload,
                          color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
