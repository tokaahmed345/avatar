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
//==========================================

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
//     with SingleTickerProviderStateMixin, WidgetsBindingObserver {
//   bool isChatOpen = false;

//   late stt.SpeechToText _speech;
//   bool _isListening = false;

//   String recognizedText = '';
//   String detectedLanguage = 'ar';
//   String liveText = '';
// bool _isRestarting = false;

//   late AnimationController _waveController;

//   final SharedPrefs sharedPrefs = getIt.get<SharedPrefs>();
//   String? businessId;
//   String? userId;

//   // ================= LOAD IDS =================
//   Future<void> _loadIds() async {
//     businessId = await sharedPrefs.getBusinessId();
//     userId = await sharedPrefs.getUserId();
//   }

//   // ================= INIT =================
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     _speech = stt.SpeechToText();

//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//       lowerBound: 0.5,
//       upperBound: 1.5,
//     );

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _loadIds();
//       if (mounted && businessId != null && userId != null) {
//         _startListening();
//       }
//     });
//   }

//   // ================= APP LIFECYCLE =================
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (state == AppLifecycleState.resumed) {
//       await _startListening();
//     } else if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.inactive) {
//       await _speech.stop();
//       _waveController.stop();
//       _isListening = false;
//     }
//   }

//   // ================= START LISTENING =================
//  Future<void> _startListening() async {
//   if (!mounted || _isListening || _isRestarting) return;

//   if (businessId == null || userId == null) {
//     await _loadIds();
//     if (businessId == null || userId == null) return;
//   }

//   bool available = await _speech.initialize(
//     onStatus: (status) async {
//       if (!mounted) return;

//       if (status == 'done' || status == 'notListening') {
//         if (_waveController.isAnimating) _waveController.stop();
//         setState(() {
//           _isListening = false;
//           liveText = '';
//         });

//         if (!_isRestarting && mounted) {
//           _isRestarting = true;
//           await Future.delayed(const Duration(milliseconds: 100));
//           _isRestarting = false;
//           if (mounted) _startListening();
//         }
//       }
//     },
//     onError: (error) {
//       if (!mounted) return;
//       print("Speech error: $error");
//       if (_waveController.isAnimating) _waveController.stop();
//       setState(() {
//         _isListening = false;
//         liveText = '';
//       });

//       if (!_isRestarting && mounted) {
//         _isRestarting = true;
//         Future.delayed(const Duration(milliseconds: 200), () {
//           _isRestarting = false;
//           if (mounted) _startListening();
//         });
//       }
//     },
//   );

//   if (!available || !mounted) return;

//   setState(() => _isListening = true);

//   _speech.listen(
//     listenMode: stt.ListenMode.dictation,
//     partialResults: true,
//     onResult: (result) async {
//       if (!mounted) return;

//       recognizedText = result.recognizedWords;
//       detectedLanguage = _detectLanguage(recognizedText);
//       setState(() => liveText = recognizedText);

//       if (recognizedText.isNotEmpty) {
//         if (!_waveController.isAnimating) _waveController.repeat(reverse: true);
//       } else {
//         if (_waveController.isAnimating) _waveController.stop();
//       }

//       if (result.finalResult && recognizedText.isNotEmpty) {
//         // try {
//         //   await context.read<VoiceTextCubit>().sendVoiceText(
//         //         businessId: businessId!,
//         //         userId: userId!,
//         //         message: recognizedText,
//         //         language: detectedLanguage,
//         //       );
//         // } catch (e) {
//         //   print("Failed to send message: $e");
//         // }

//         recognizedText = '';
//         setState(() {
//           liveText = '';
//           _isListening = false;
//         });

//         if (_waveController.isAnimating) _waveController.stop();
//       }
//     },
//     onSoundLevelChange: (level) {
//       if (!mounted) return;
//       if (level > 3) {
//         if (!_waveController.isAnimating) _waveController.repeat(reverse: true);
//       } else {
//         if (_waveController.isAnimating) _waveController.stop();
//       }
//     },
//   );
// }


//   // ================= LANGUAGE DETECTION =================
//   String _detectLanguage(String text) {
//     final arabicRegex = RegExp(r'[\u0600-\u06FF]');
//     return arabicRegex.hasMatch(text) ? 'ar' : 'en';
//   }

//   // ================= DISPOSE =================
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _waveController.dispose();
//     _speech.stop();
//     super.dispose();
//   }

//   // ================= WAVE UI =================
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

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<VoiceTextCubit, VoiceTextState>(
//       listener: (context, state) {
//         if (state is VoiceTextSuccess) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Message sent: ${state.voiceText.status}"),
//             ),
//           );
//         } else if (state is VoiceTextFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Error: ${state.errorMessage}"),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return SafeArea(
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Image.asset(
//                   AppAssets.homeBackground,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               // ===== TOP BAR =====
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
//                           builder: (_) => BlocProvider(
//                             create: (_) => getIt.get<LogOutCubit>(),
//                             child: AlertDialogBody(),
//                           ),
//                         );
//                       },
//                     ),
//                     const GlassIconButton(icon: Icons.volume_up),
//                   ],
//                 ),
//               ),
//               // ===== CHAT =====
//               ChtaView(
//                 isChatOpen: isChatOpen,
//                 selectedLanguage: detectedLanguage,
//                 onClose: () => setState(() => isChatOpen = false),
//               ),
//               // ===== LIVE TEXT DISPLAY =====
//               Positioned(
//                 bottom: isChatOpen
//                     ? MediaQuery.of(context).size.height * 0.55
//                     : 100,
//                 left: 24,
//                 right: 24,
//                 child: Text(
//                   liveText,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(blurRadius: 4, color: Colors.black54, offset: Offset(2,2))
//                     ],
//                   ),
//                 ),
//               ),
//               // ===== BOTTOM CONTROLS =====
//               AnimatedPositioned(
//                 duration: const Duration(milliseconds: 300),
//                 bottom: isChatOpen
//                     ? MediaQuery.of(context).size.height * 0.68
//                     : 24,
//                 left: 0,
//                 right: 0,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GlassIconButton(
//                       icon:  Icons.mic ,
//                       onTap: () {},
//                     ),
//                     const SizedBox(width: 24),
//                     buildWave(),
//                     const SizedBox(width: 24),
//                     GlassIconButton(
//                       icon: Icons.chat,
//                       isActive: isChatOpen,
//                       onTap: () => setState(() => isChatOpen = !isChatOpen),
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

// ============================
import 'package:avatar/feature/session/data/models/start_session_model.dart';
import 'package:avatar/feature/session/presentation/view_model/cubit/start_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:livekit_client/livekit_client.dart';
import 'package:avatar/core/utils/assets/app_assets.dart';
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/feature/home/presentation/widgets/glass_button.dart';
import 'package:avatar/feature/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:avatar/feature/home/presentation/widgets/alert_dialog_body.dart';
import 'package:avatar/feature/chat/chat_view.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isChatOpen = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String liveText = '';
  bool _isRestarting = false;
  String detectedLanguage = 'ar';

  late AnimationController _waveController;

  final SharedPrefs sharedPrefs = getIt.get<SharedPrefs>();
  String? businessId;
  String? userId;

  // LiveKit
  Room? _room;
  RemoteVideoTrack? _remoteVideoTrack;
  late final EventsListener<RoomEvent> _roomListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _speech = stt.SpeechToText();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: 0.5,
      upperBound: 1.5,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      businessId = await sharedPrefs.getBusinessId();
      userId = await sharedPrefs.getUserId();
      if (mounted && businessId != null && userId != null) {
        _startListening();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _waveController.dispose();
    _speech.stop();
    _room?.disconnect();
    _remoteVideoTrack?.dispose();
    _roomListener.dispose();
    super.dispose();
  }

  // ====================== SPEECH ======================
  Future<void> _startListening() async {
    if (!mounted || _isListening || _isRestarting) return;

    bool available = await _speech.initialize(
      onStatus: (status) async {
        if (!mounted) return;

        if (status == 'done' || status == 'notListening') {
          if (_waveController.isAnimating) _waveController.stop();

          setState(() {
            _isListening = false;
            liveText = '';
          });

          if (!_isRestarting && mounted) {
            _isRestarting = true;
            await Future.delayed(const Duration(milliseconds: 100));
            _isRestarting = false;
            if (mounted) _startListening();
          }
        }
      },
      onError: (_) {
        if (_waveController.isAnimating) _waveController.stop();
        setState(() {
          _isListening = false;
          liveText = '';
        });
      },
    );

    if (!available || !mounted) return;

    setState(() => _isListening = true);

    _speech.listen(
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      onResult: (result) {
        if (!mounted) return;

        liveText = result.recognizedWords;
        detectedLanguage = _detectLanguage(liveText);
        setState(() {});

        if (result.finalResult && liveText.isNotEmpty) {
          _speech.stop();
          _waveController.stop();
          _isListening = false;

          // ✅ بس نطلب Start Session
          context.read<StartSessionCubit>().startSession();
        }
      },
      onSoundLevelChange: (level) {
        if (!mounted) return;

        if (level > 3 && !_waveController.isAnimating) {
          _waveController.repeat(reverse: true);
        } else if (level <= 3 && _waveController.isAnimating) {
          _waveController.stop();
        }
      },
    );
  }

  // ================= LANGUAGE DETECTION =================
  String _detectLanguage(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? 'ar' : 'en';
  }

  // ====================== LIVEKIT ======================
  Future<void> _connectLiveKit(Data sessionData) async {
    if (_room != null) return; // ✅ يمنع فتح أكتر من session

    try {
      final room = Room();

      await room.connect(
        sessionData.livekitUrl!,
        sessionData.livekitClientToken!,
        roomOptions: const RoomOptions(adaptiveStream: true),
      );

      _room = room;

      _roomListener = _room!.createListener()
        ..on<TrackSubscribedEvent>((event) {
          final track = event.track;
          if (track is RemoteVideoTrack) {
            setState(() {
              _remoteVideoTrack = track;
            });
          }
        });
    } catch (e) {
      print("LiveKit Error: $e");
    }
  }

  // ====================== UI ======================
  Widget buildWave() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        final scale = _isListening ? _waveController.value : 1.0;
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

  Widget buildAvatarView() {
    if (_remoteVideoTrack == null) {
      return Image.asset(AppAssets.homeBackground, fit: BoxFit.cover);
    }
    return VideoTrackRenderer(_remoteVideoTrack!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StartSessionCubit, StartSessionState>(
      listener: (context, state) {
        if (state is StartSessionSuccess) {
          if (state.startSession.data != null) {
            _connectLiveKit(state.startSession.data!);
          }
        }

        if (state is StartSessionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Session Error: ${state.errMessage}")),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: buildAvatarView()),

              // TOP BAR
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

              // CHAT
              ChtaView(
                isChatOpen: isChatOpen,
                selectedLanguage: detectedLanguage,
                onClose: () => setState(() => isChatOpen = false),
              ),

              // LIVE TEXT
              Positioned(
                bottom:
                    isChatOpen ? MediaQuery.of(context).size.height * 0.55 : 100,
                left: 24,
                right: 24,
                child: Text(
                  liveText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      )
                    ],
                  ),
                ),
              ),

              // BOTTOM CONTROLS
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
                      icon: Icons.mic,
                      onTap: _startListening,
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
