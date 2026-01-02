// import 'package:avatar/core/utils/assets/app_assets.dart';
// import 'package:avatar/core/utils/colors/app_colors.dart';
// import 'package:avatar/core/utils/service_locator/service_locator.dart';
// import 'package:avatar/feature/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';

// import 'package:avatar/feature/chat/chat_view.dart';
// import 'package:avatar/feature/home/presentation/widgets/alert_dialog_body.dart';
// import 'package:avatar/feature/home/presentation/widgets/glass_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class HomeViewBody extends StatefulWidget {
//   const HomeViewBody({super.key});

//   @override
//   State<HomeViewBody> createState() => _HomeViewBodyState();
// }

// class _HomeViewBodyState extends State<HomeViewBody> {
//   bool isChatOpen = false;
//   String selectedLanguage = 'ar';

//   void _onLanguageChanged(String lang) {
//     setState(() {
//       selectedLanguage = lang.toLowerCase();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(AppAssets.homeBackground, fit: BoxFit.cover),
//           ),

//           Positioned(
//             top: 16,
//             left: 16,
//             right: 16,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 GlassIconButton(
//                   icon: Icons.close,
//                   onTap: () {
//                     showDialog(
//                       context: context,
//                       barrierDismissible: true,
//                       builder: (context) {
//                         return BlocProvider(
//                           create: (context) => getIt.get<LogOutCubit>(),
//                           child: AlertDialogBody(),
//                         );
//                       },
//                     );
//                   },
//                 ),

//                 Row(
//                   children: [
// //                     LanguageButton(         text: selectedLanguage.toUpperCase(),
// //                       onTap:(){
// // //     _onLanguageChanged(selectedLanguage == 'ar' ? 'en' : 'ar');

// // //  print(selectedLanguage);
// //                       },),
//                     const SizedBox(width: 12),
//                     GlassIconButton(icon: Icons.volume_up),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           ChtaView(
//             isChatOpen: isChatOpen,
//             onClose: () {
//               setState(() {
//                 isChatOpen = false;
//               });
//             }, selectedLanguage: selectedLanguage,
//           ),

//           AnimatedPositioned(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//             bottom: isChatOpen ? MediaQuery.of(context).size.height * 0.68: 24,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 GlassIconButton(icon: Icons.mic),
//                 const SizedBox(width: 24),

//                 Container(
//                   height: 50,
//                   width: 120,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: AppColors.primary.withOpacity(.6),
//                   ),
//                   child: const Icon(
//                     Icons.multitrack_audio,
//                     size: 40,
//                     color: AppColors.whiteColor,
//                   ),
//                 ),

//                 const SizedBox(width: 24),

//                 GlassIconButton(
//                   icon: Icons.chat,
//                   isActive: isChatOpen,

//                   onTap: () {
//                     setState(() {
//                       isChatOpen = !isChatOpen;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:avatar/core/utils/assets/app_assets.dart';
// import 'package:avatar/core/utils/colors/app_colors.dart';
// import 'package:avatar/core/utils/constant/shared_prefrence.dart';
// import 'package:avatar/core/utils/service_locator/service_locator.dart';
// import 'package:avatar/feature/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
// import 'package:avatar/feature/chat/chat_view.dart';
// import 'package:avatar/feature/home/presentation/view_model/cubit/voice_text_cubit.dart';
// import 'package:avatar/feature/home/presentation/widgets/alert_dialog_body.dart';
// import 'package:avatar/feature/home/presentation/widgets/glass_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class HomeViewBody extends StatefulWidget {
//   const HomeViewBody({super.key});

//   @override
//   State<HomeViewBody> createState() => _HomeViewBodyState();
// }

// class _HomeViewBodyState extends State<HomeViewBody>
//     with SingleTickerProviderStateMixin {
//   bool isChatOpen = false;
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String recognizedText = '';
//   String detectedLanguage = 'ar';

//   late AnimationController _waveController;
//   final SharedPrefs sharedPrefs = getIt.get<SharedPrefs>();
//   String? businessId;
// String? userId;

// Future<void> _loadIds() async {
// final businessId = await sharedPrefs.getBusinessId();
//  final  userId = await sharedPrefs.getUserId();
//   _startListening();
// }

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
// _loadIds();
//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//       lowerBound: 0.5,
//       upperBound: 1.5,
//     )..repeat(reverse: true);

//     _startListening();
//   }

//   void _startListening() async {
//     bool available = await _speech.initialize(
//       onStatus: (status) {
//         if (status == 'done') {
//           if (recognizedText.isNotEmpty) {
//             // SnackBar للكلام
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text("You said: $recognizedText"),
//                 duration: const Duration(seconds: 2),
//               ),
//             );

//             final voiceCubit = context.read<VoiceTextCubit>();
//             voiceCubit.sendVoiceText (
//               businessId:businessId!,

 
//               userId: userId!,
//               message: recognizedText,
//               language: detectedLanguage,
//             );

//             recognizedText = '';
//           }
//           _waveController.stop();
//           _startListening();
//         }
//       },
//     );

//     if (available) {
//       setState(() => _isListening = true);
//       _speech.listen(
//         onResult: (result) {
//           if (result.finalResult) {
//             recognizedText = result.recognizedWords;
//             detectedLanguage = _detectLanguage(recognizedText);

//             // ممكن هنا لو عايزة تبعتي فوراً لما يكتمل الكلام
//             final voiceCubit = context.read<VoiceTextCubit>();
//             voiceCubit.sendVoiceText(
//               businessId: "64",
//               userId: "49",
//               message: recognizedText,
//               language: detectedLanguage,
//             );
//           } else {
//             if (!_waveController.isAnimating)
//               _waveController.repeat(reverse: true);
//           }
//         },
//         listenMode: stt.ListenMode.confirmation,
//       );
//     }
//   }

//   String _detectLanguage(String text) {
//     final arabicRegex = RegExp(r'[\u0600-\u06FF]');
//     return arabicRegex.hasMatch(text) ? 'ar' : 'en';
//   }

//   @override
//   void dispose() {
//     _waveController.dispose();
//     _speech.stop();
//     super.dispose();
//   }

//   Widget buildWave() {
//     return AnimatedBuilder(
//       animation: _waveController,
//       builder: (context, child) {
//         double scale = _isListening ? _waveController.value : 1.0;
//         return Transform.scale(
//           scaleY: scale,
//           child: Container(
//             height: 50,
//             width: 120,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: AppColors.primary.withOpacity(.6),
//             ),
//             child: const Icon(
//               Icons.multitrack_audio,
//               size: 40,
//               color: AppColors.whiteColor,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<VoiceTextCubit, VoiceTextState>(
//       listener: (context, state) {
//  if (state is VoiceTextSuccess) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Message sent: ${state.voiceText.status}"),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       } else if (state is VoiceTextFailure) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error: ${state.errorMessage}"),
//             duration: const Duration(seconds: 2),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//       },
//       builder: (context, state) {
//         return SafeArea(
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Image.asset(AppAssets.homeBackground, fit: BoxFit.cover),
//               ),
//               Positioned(
//                 top: 16,
//                 left: 16,
//                 right: 16,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GlassIconButton(
//                       icon: Icons.close,
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           barrierDismissible: true,
//                           builder: (context) {
//                             return BlocProvider(
//                               create: (context) => getIt.get<LogOutCubit>(),
//                               child: AlertDialogBody(),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                     Row(
//                       children: [
//                         const SizedBox(width: 12),
//                         GlassIconButton(icon: Icons.volume_up),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               ChtaView(
//                 isChatOpen: isChatOpen,
//                 onClose: () {
//                   setState(() {
//                     isChatOpen = false;
//                   });
//                 },
//                 selectedLanguage: detectedLanguage,
//               ),
//               AnimatedPositioned(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeOut,
//                 bottom: isChatOpen
//                     ? MediaQuery.of(context).size.height * 0.68
//                     : 24,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GlassIconButton(
//                       icon: Icons.mic,
//                       onTap: () {
//                         if (_isListening) {
//                           _speech.stop();
//                           _waveController.stop();
//                           setState(() => _isListening = false);
//                         } else {
//                           _startListening();
//                         }
//                       },
//                     ),
//                     const SizedBox(width: 24),
//                     buildWave(),
//                     const SizedBox(width: 24),
//                     GlassIconButton(
//                       icon: Icons.chat,
//                       isActive: isChatOpen,
//                       onTap: () {
//                         setState(() {
//                           isChatOpen = !isChatOpen;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:avatar/core/utils/assets/app_assets.dart';
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/feature/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:avatar/feature/chat/chat_view.dart';
import 'package:avatar/feature/home/presentation/view_model/cubit/voice_text_cubit.dart';
import 'package:avatar/feature/home/presentation/widgets/alert_dialog_body.dart';
import 'package:avatar/feature/home/presentation/widgets/glass_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with SingleTickerProviderStateMixin {
  bool isChatOpen = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _userRequestedListening = false;

  String recognizedText = '';
  String detectedLanguage = 'ar';

  late AnimationController _waveController;

  final SharedPrefs sharedPrefs = getIt.get<SharedPrefs>();
  String? businessId;
  String? userId;

  // ================= LOAD IDS =================
  Future<void> _loadIds() async {
    businessId = await sharedPrefs.getBusinessId();
    userId = await sharedPrefs.getUserId();
  }

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    _speech = stt.SpeechToText();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.5,
      upperBound: 1.5,
    );

    _loadIds();
    _startListening(); // يبدأ تلقائي
  }

  // ================= TOGGLE MIC =================
  void _toggleListening() async {
    if (_isListening) {
      _userRequestedListening = false;
      await _speech.stop();
      _waveController.stop();

      setState(() => _isListening = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone muted")),
      );
    } else {
      _userRequestedListening = true;
      await _startListening();
    }
  }

  // ================= START LISTENING =================
  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if ((status == 'done' || status == 'notListening') && _isListening) {
          _waveController.stop();
          setState(() => _isListening = false);
        }
      },
    );

    if (!available) return;

    setState(() => _isListening = true);
    _waveController
      ..reset()
      ..repeat(reverse: true);

    _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          recognizedText = result.recognizedWords;
          detectedLanguage = _detectLanguage(recognizedText);

          // ✅ SnackBar يعرض النص المتحوّل من الصوت
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "You said: $recognizedText",
                textAlign: TextAlign.center,
              ),
              duration: const Duration(seconds: 3),
            ),
          );

          context.read<VoiceTextCubit>().sendVoiceText(
                businessId: businessId!,
                userId: userId!,
                message: recognizedText,
                language: detectedLanguage,
              );

          if (!_userRequestedListening) {
            _waveController.stop();
            setState(() => _isListening = false);
          }
        }
      },
      listenMode: stt.ListenMode.confirmation,
    );
  }

  // ================= LANGUAGE DETECTION =================
  String _detectLanguage(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? 'ar' : 'en';
  }

  // ================= DISPOSE =================
  @override
  void dispose() {
    _waveController.dispose();
    _speech.stop();
    super.dispose();
  }

  // ================= WAVE UI =================
  Widget buildWave() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        double scale = _isListening ? _waveController.value : 1.0;
        return Transform.scale(
          scaleY: scale,
          child: Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withOpacity(.6),
            ),
            child: const Icon(
              Icons.multitrack_audio,
              size: 40,
              color: AppColors.whiteColor,
            ),
          ),
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceTextCubit, VoiceTextState>(
      listener: (context, state) {
        if (state is VoiceTextSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Message sent: ${state.voiceText.status}"),
            ),
          );
        } else if (state is VoiceTextFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.errorMessage}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  AppAssets.homeBackground,
                  fit: BoxFit.cover,
                ),
              ),

              // ===== TOP BAR =====
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GlassIconButton(
                      icon: Icons.close,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider(
                            create: (_) => getIt.get<LogOutCubit>(),
                            child: AlertDialogBody(),
                          ),
                        );
                      },
                    ),
                    const GlassIconButton(icon: Icons.volume_up),
                  ],
                ),
              ),

              // ===== CHAT =====
              ChtaView(
                isChatOpen: isChatOpen,
                selectedLanguage: detectedLanguage,
                onClose: () => setState(() => isChatOpen = false),
              ),

              // ===== BOTTOM CONTROLS =====
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                bottom: isChatOpen
                    ? MediaQuery.of(context).size.height * 0.68
                    : 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GlassIconButton(
                      icon: _isListening ? Icons.mic : Icons.mic_off,
                      onTap: _toggleListening,
                    ),
                    const SizedBox(width: 24),
                    buildWave(),
                    const SizedBox(width: 24),
                    GlassIconButton(
                      icon: Icons.chat,
                      isActive: isChatOpen,
                      onTap: () =>
                          setState(() => isChatOpen = !isChatOpen),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
