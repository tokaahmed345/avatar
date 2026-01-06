import 'dart:async';

import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/feature/session/data/models/start_session_model.dart';
import 'package:avatar/feature/session/presentation/view_model/keep_session_alive_cubit/keep_session_alive_cubit.dart';
import 'package:avatar/feature/session/presentation/view_model/start_session_cubit/start_session_cubit.dart';
import 'package:avatar/feature/session/presentation/view_model/stop_session_cubit/stop_session_cubit.dart';
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

  // ================= UI =================
  bool isChatOpen = false;
  String liveText = '';
  String detectedLanguage = 'ar';

  // ================= STT =================
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isRestarting = false;


  // ================= SESSION =================
  bool _isSessionActive = false;
  bool _keepAliveCalled = false;

  // ================= ANIMATION =================
  late AnimationController _waveController;

  // ================= STORAGE =================
  final SharedPrefs sharedPrefs = getIt.get<SharedPrefs>();
  String? businessId;
  String? userId;

  // ================= LIVEKIT =================
  Room? _room;
  RemoteVideoTrack? _remoteVideoTrack;
  EventsListener<RoomEvent>? _roomListener;

  // ================= LIFECYCLE =================
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
    _endSession();
    WidgetsBinding.instance.removeObserver(this);
    _waveController.dispose();
    super.dispose();
  }
// ====Timer======
Timer? _keepAliveTimer;

void _startKeepAliveTimer(String sessionId) {
  _keepAliveTimer?.cancel(); 
  _keepAliveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
    print("KeepAlive called at ${DateTime.now()}");

    context.read<KeepSessionAliveCubit>().keepSessionAlive(sessionId: sessionId);
  });
}

void _stopKeepAliveTimer() {
  _keepAliveTimer?.cancel();
  _keepAliveTimer = null;
}

// ================= END SESSION =================
  void _endSession() {
   _keepAliveCalled = false;
    _isRestarting = true;
    _isSessionActive = false;

    _speech.stop();
    _waveController.stop();

    _roomListener?.dispose();
    _room?.disconnect();
    _remoteVideoTrack?.dispose();
_stopKeepAliveTimer();

    _room = null;
    _roomListener = null;
    _remoteVideoTrack = null;

    setState(() {
      _isListening = false;
      liveText = '';
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      _isRestarting = false;
      _startListening();
    });
  }

// ================= CONFIRM END =================
  void _showEndSessionDialog() async {
  showDialog(
    context: context,
    builder: (_) => Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.whiteColor.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "End Session",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Do you want to cancel the session?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: AppStyle.text18.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      final sessionId = await sharedPrefs.getSessionId();
                      if (sessionId != null) {
                        context
                            .read<StopSessionCubit>()
                            .stopSession(sessionId: sessionId);
                      }
                    },
                    child: Text(
                      "End",
                      style: AppStyle.text18.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  // ================= SPEECH =================
  Future<void> _startListening() async {
    if (!mounted || _isListening || _isRestarting) return;

    final available = await _speech.initialize(
      onStatus: (status) async {
        if (!mounted) return;

        if (status == 'done' || status == 'notListening') {
          _waveController.stop();
          setState(() => _isListening = false);

          if (!_isRestarting) {
            await Future.delayed(const Duration(milliseconds: 150));
            if (mounted) _startListening();
          }
        }
      },
      onError: (_) => _waveController.stop(),
    );

    if (!available) return;

    setState(() => _isListening = true);

    _speech.listen(
      listenMode: stt.ListenMode.dictation,
      partialResults: true,
      onResult: (result) {
        liveText = result.recognizedWords;
        detectedLanguage = _detectLanguage(liveText);
        setState(() {});

        if (result.finalResult && liveText.isNotEmpty) {
          if (!_isSessionActive) {
            _speech.stop();
            _waveController.stop();
            _isListening = false;
            context.read<StartSessionCubit>().startSession();
          } else {
            liveText = '';
          }
        }
      },
      onSoundLevelChange: (level) {
        if (level > 3) {
          if (!_waveController.isAnimating) {
            _waveController.repeat(reverse: true);
          }
        } else {
          _waveController.stop();
        }
      },
    );
  }

  String _detectLanguage(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text) ? 'ar' : 'en';
  }

  // ================= LIVEKIT =================
  Future<void> _connectLiveKit(Data data) async {
    if (_room != null) return;

    try {
      final room = Room();
      await room.connect(
        data.livekitUrl!,
        data.livekitClientToken!,
        roomOptions: const RoomOptions(adaptiveStream: true),
      );

      _room = room;
      _isSessionActive = true;

      _roomListener = room.createListener()
        ..on<TrackSubscribedEvent>((event) {
          if (event.track is RemoteVideoTrack) {
            setState(() {
              _remoteVideoTrack = event.track as RemoteVideoTrack;
            });
          }
        });
    } catch (e) {
      _endSession();
    }
  }

  // ================= UI HELPERS =================
  Widget buildAvatarView() {
    if (_remoteVideoTrack == null) {
      return Image.asset(AppAssets.homeBackground, fit: BoxFit.cover);
    }
    return VideoTrackRenderer(_remoteVideoTrack!);
  }

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

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StartSessionCubit, StartSessionState>(
          listener: (context, state) async {
            if (state is StartSessionSuccess && state.startSession.data != null) {
              _connectLiveKit(state.startSession.data!);
if (!_keepAliveCalled) {
  final sessionId = await sharedPrefs.getSessionId();
  if (sessionId != null) {
    context.read<KeepSessionAliveCubit>()
        .keepSessionAlive(sessionId: sessionId);
    _keepAliveCalled = true;
        _startKeepAliveTimer(sessionId);

  }
}
    }
            if (state is StartSessionFailure) {
              _endSession();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage)),
              );
            }
          },
        ),
        BlocListener<StopSessionCubit, StopSessionState>(
          listener: (context, state) {
            if (state is StopSessionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.stopSession.message ?? "Stopped Successfully"),
                  backgroundColor: AppColors.success,
                ),
              );
              _endSession();
            } else if (state is StopSessionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errMessage),
                  backgroundColor: AppColors.redColor,
                ),
              );
            }
          },
        ),
        BlocListener<KeepSessionAliveCubit, KeepSessionAliveState>(
  listener: (context, state) {
    if (state is KeepSessionAliveSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(state.keepSession.message??""),
          duration: Duration(seconds: 1),
                    backgroundColor: AppColors.success,

        ),
      );
    }

    if (state is KeepSessionAliveFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errMessage),
          backgroundColor:           AppColors.redColor,
        ),
      );
    }
  },
),

      ],
      child: SafeArea(
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
                  GlassIconButton(
                    icon: _isSessionActive ? Icons.volume_up : Icons.volume_off,
                    onTap: _isSessionActive ? _showEndSessionDialog : null,
                  ),
                ],
              ),
            ),

            ChtaView(
              isChatOpen: isChatOpen,
              selectedLanguage: detectedLanguage,
              onClose: () => setState(() => isChatOpen = false),
            ),

            Positioned(
              bottom: isChatOpen
                  ? MediaQuery.of(context).size.height * 0.55
                  : 100,
              left: 24,
              right: 24,
              child: Text(
                liveText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                    onTap: _isListening ? null : _startListening,
                  ),
                  const SizedBox(width: 24),
                  buildWave(),
                  const SizedBox(width: 24),
                  GlassIconButton(
                    icon: Icons.chat,
                    isActive: isChatOpen,
                    onTap: () => setState(() => isChatOpen = !isChatOpen),
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
