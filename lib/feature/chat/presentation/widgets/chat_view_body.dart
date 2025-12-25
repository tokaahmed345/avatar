
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/feature/chat/presentation/view_model/cubit/message_cubit.dart';
import 'package:avatar/feature/chat/presentation/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    messages.add({"text": "مرحبًا! كيف يمكنني مساعدتك اليوم؟", "isUser": false});
    _loadBusinessId();
    _initSpeech();
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  Future<void> _loadBusinessId() async {
    final id = await sharedPrefs.getBusinessId();
    _safeSetState(() {
      businessId = id;
    });
    print('📦 BusinessId: $businessId');
  }

  Future<void> _initSpeech() async {
    print('🎤 Initializing speech...');

    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        print('🎤 Status: $status');
        _safeSetState(() {
          if (status == 'done') _isListening = false;
        });
      },
      onError: (error) {
        print('🎤 Speech error: ${error.errorMsg}');
        _safeSetState(() => _isListening = false);
      },
    );
    print('🎤 Speech initialized: $_speechAvailable');
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty || businessId == null) return;

    _safeSetState(() => messages.add({"text": text, "isUser": true}));
    _controller.clear();
    _scrollToBottom();

    final language = _detectLanguage(text);

    context.read<MessageCubit>().fetchMessage(
          businessId: businessId!,
          question: text,
          language: language,
        );
  }

  String _detectLanguage(String text) {
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

  void _onMicPressed() async {
    print('🎤 Mic pressed');

    if (_isRequestingPermission) return;
    _isRequestingPermission = true;

    if (!await Permission.microphone.isGranted) {
      if (!await Permission.microphone.request().isGranted) {
        print('⚠️ Microphone permission denied');
        _isRequestingPermission = false;
        return;
      }
    }
    _isRequestingPermission = false;

    if (!_speechAvailable) return;

    if (!_isListening) {
      _safeSetState(() => _isListening = true);
      print('🎤 Listening started');

      _speech.listen(
        onResult: (val) {
          print('🎤 Recognized: ${val.recognizedWords}');
          _safeSetState(() => _controller.text = val.recognizedWords);
        },
        localeId: widget.selectedLanguage,
        listenMode: stt.ListenMode.dictation,
      );
    } else {
      _safeSetState(() => _isListening = false);
      print('🎤 Listening stopped');
      _speech.stop();
    }
  }

  @override
  void dispose() {
    print('🎤 Disposing ChatViewBody...');
    _speech.stop();
    _speech.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
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
                    onPressed: _onMicPressed,
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  ),
                  const Spacer(),
                  Text(
                    'Chat',
                    style: AppStyle.text18.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.blackColor),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      widget.onClose();
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocConsumer<MessageCubit, MessageState>(
                listener: (context, state) {
                  if (state is MessageLoading) {
                    _safeSetState(() => messages.add({"text": "", "isUser": false, "isLoading": true}));
                    _scrollToBottom();
                  }
                  if (state is MessageSuccess) {
                    _safeSetState(() {
                      if (messages.isNotEmpty && messages.last["isLoading"] == true) messages.removeLast();
                      messages.add({"text": state.messages.answer, "isUser": false});
                    });
                    _scrollToBottom();
                  }
                  if (state is MessageFailure) {
                    _safeSetState(() {
                      if (messages.isNotEmpty && messages.last["isLoading"] == true) messages.removeLast();
                         String errorMessage = widget.selectedLanguage == 'ar'
        ? 'حدثت مشكلة في الاتصال، يرجى المحاولة مرة أخرى'
        : 'A connection error occurred, please try again';
                      messages.add({"text": errorMessage
                      , "isUser": false});
                    });
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                            child: const SizedBox(
                              width: 24,
                              height: 24,
                              child: SpinKitDoubleBounce(color: Colors.grey, size: 16),
                            ),
                          ),
                        );
                      }
                      return ChatBubble(text: message["text"], isUser: message["isUser"]);
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
                    child: IconButton(icon: const Icon(Icons.upload, color: Colors.white), onPressed: _sendMessage),
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
