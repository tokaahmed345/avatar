import 'dart:async';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/feature/home/presentation/view_model/cubit/voice_text_cubit.dart';
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
import 'package:cached_network_image/cached_network_image.dart';

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
  bool _isSendingVoiceText = false;
bool _isMuted = false;
  // ================= SESSION =================
  bool _isSessionActive = false;
  bool _keepAliveCalled = false;
  bool _canSendVoiceText = true;

  // ================= ANIMATION =================
  late AnimationController _waveController;
  String? avatarPreviewUrl;
String? logo;
  // ================= STORAGE =================
  final SharedPrefs sharedPrefs = getIt.get<SharedPrefs>();
  String? businessId;
  int? userId;
  String? avatarId;
  String? contextId;
String? voiceId;
  // ================= LIVEKIT =================
  Room? _room;
  RemoteVideoTrack? _remoteVideoTrack;
  EventsListener<RoomEvent>? _roomListener;
  LocalAudioTrack? _localAudioTrack;

  // ================= LIFECYCLE =================
  @override
void didChangeAppLifecycleState(AppLifecycleState state) {
  super.didChangeAppLifecycleState(state);

  if (state == AppLifecycleState.resumed) {

    _isMuted = false;

    if (_isSessionActive) {
      _toggleMuteAvatar(false);
    }

    if (!_isListening && !isChatOpen && !_isRestarting) {
      _resumeListening();
    }

    setState(() {});
  }

  if (state == AppLifecycleState.paused ||
      state == AppLifecycleState.inactive) {
    _stopListening();
  }
}

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
      userId = int.parse(await sharedPrefs.getUserId());
      avatarPreviewUrl = await sharedPrefs.getAvatarPreviewUrl();
logo=await sharedPrefs.getLogo();
      avatarId = await sharedPrefs.getAvatarId();
      contextId = await sharedPrefs.getContextId();
voiceId=await sharedPrefs.getVoiceId();
      if (mounted
      // &&
      //     businessId!.isNotEmpty &&
      //     userId!=null &&
      //     avatarId!.isNotEmpty &&
      // contextId!.isNotEmpty
      ) {
        // print("businessId: $businessId");
        // print("context: $contextId");
        // print("acvatar: $avatarId");
        // print("acvatar: $userId");
        // print("acvatar: $voiceId");

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

  Timer? _keepAliveTimer;
  void _toggleMuteAvatar(bool mute) {
    if (_localAudioTrack != null) {
      if (mute) {
        _localAudioTrack!.mute();
      } else {
        _localAudioTrack!.unmute();
      }
    }
  }
void _toggleMic() {
  if (_isMuted) {
    _isMuted = false;

    _resumeListening();

    if (_isSessionActive) {
      _toggleMuteAvatar(false);
    }
  } else {
    _isMuted = true;

    _stopListening();

    if (_isSessionActive) {
      _toggleMuteAvatar(true);
    }
  }

  setState(() {});
}

  void _startKeepAliveTimer(String sessionId) {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      print("KeepAlive called at ${DateTime.now()}");

      context.read<KeepSessionAliveCubit>().keepSessionAlive(
        sessionId: sessionId,
      );
    });
  }

  void _stopKeepAliveTimer() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
  }

 Future<void>  _endSession()async {
    // _keepAliveCalled = false;
    // _isRestarting = true;
    // _isSessionActive = false;
    // _localAudioTrack?.stop();
    // _localAudioTrack?.dispose();
    // _localAudioTrack = null;
    // _canSendVoiceText = true;
    // _isSendingVoiceText = false;
    // _speech.stop();
    // _waveController.stop();

    // _roomListener?.dispose();
    // _room?.disconnect();
    // _remoteVideoTrack?.dispose();
    // _stopKeepAliveTimer();

    // _room = null;
    // _roomListener = null;
    // _remoteVideoTrack = null;

    // setState(() {
    //   _isListening = false;
    //   liveText = '';
    // });

    // Future.delayed(const Duration(milliseconds: 200), () {
    //   _isRestarting = false;
    //   _startListening();
    // });
    _keepAliveCalled = false;
  _isRestarting = true;
  _isSessionActive = false;
  _canSendVoiceText = true;
  _isSendingVoiceText = false;

  if (_isListening) {
    _speech.stop();
    _waveController.stop();
    _isListening = false;
  }

  try {
    await _localAudioTrack?.stop();
    await _localAudioTrack?.dispose();
  } catch (_) {}
  _localAudioTrack = null;

  try {
    _roomListener?.dispose();
  } catch (_) {}
  _roomListener = null;

  if (_room != null) {
    try {
      await _room!.disconnect().timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint("Failed to disconnect room safely: $e");
    }
  }
  _room = null;

  try {
    await _remoteVideoTrack?.dispose();
  } catch (_) {}
  _remoteVideoTrack = null;

  _stopKeepAliveTimer();

  setState(() {
    liveText = '';
  });

  Future.delayed(const Duration(milliseconds: 200), () {
    _isRestarting = false;
    _startListening();
  });
  }

  // void _showEndSessionDialog() async {
  //   showDialog(
  //     context: context,
  //     builder: (_) => Center(
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           width: 300,
  //           padding: const EdgeInsets.all(24),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: AppColors.whiteColor.withOpacity(0.1),
  //             border: Border.all(color: Colors.white.withOpacity(0.2)),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: AppColors.blackColor.withOpacity(0.2),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 5),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Text(
  //                 "End Session",
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.whiteColor,
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               const Text(
  //                 "Do you want to cancel the session?",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(color: Colors.white70),
  //               ),
  //               const SizedBox(height: 24),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.white24,
  //                       padding: const EdgeInsets.symmetric(
  //                         vertical: 12,
  //                         horizontal: 24,
  //                       ),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     onPressed: () => Navigator.pop(context),
  //                     child: Text(
  //                       "Cancel",
  //                       style: AppStyle.text18.copyWith(
  //                         color: AppColors.whiteColor,
  //                       ),
  //                     ),
  //                   ),
  //                   ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: AppColors.primary,
  //                       padding: const EdgeInsets.symmetric(
  //                         vertical: 12,
  //                         horizontal: 24,
  //                       ),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                     ),
  //                     onPressed: () async {
  //                       Navigator.pop(context);
  //                       final sessionId = await sharedPrefs.getSessionId();
  //                       if (sessionId != null) {
  //                         context.read<StopSessionCubit>().stopSession(
  //                           sessionId: sessionId,
  //                         );
  //                       }
  //                     },
  //                     child: Text(
  //                       "End",
  //                       style: AppStyle.text18.copyWith(
  //                         color: AppColors.whiteColor,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      _waveController.stop();
      setState(() => _isListening = false);
    }
  }

  void _resumeListening() {
    if (!isChatOpen && !_isListening && !_isRestarting) {
      _startListening();
    }
  }

  Future<void> _startListening() async {
    if (!mounted || _isListening || _isRestarting || isChatOpen) return;

    final available = await _speech.initialize(
      onStatus: (status) async {
        if (!mounted) return;

        if ((status == 'done' || status == 'notListening') && !isChatOpen && !_isMuted) {
          _waveController.stop();
          setState(() => _isListening = false);

          if (!_isRestarting) {
            await Future.delayed(const Duration(milliseconds: 150));
            if (mounted && !isChatOpen) _startListening();
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
        if (isChatOpen) {
          if (_isListening) {
            _speech.stop();
            _waveController.stop();
            setState(() => _isListening = false);
          }
          return;
        }

        liveText = result.recognizedWords;
        detectedLanguage = _detectLanguage(liveText);
        setState(() {});
        print("lang: $detectedLanguage");

        if (result.finalResult &&
            liveText.isNotEmpty &&
            !_isSessionActive &&
            _canSendVoiceText) {
          _canSendVoiceText = false;
          _isSendingVoiceText = false;
  
          context
              .read<VoiceTextCubit>()
              .sendVoiceText(
                businessId: businessId!,
                avatartId: avatarId!,
                language: detectedLanguage,
                userId: userId!,
                contextId: contextId!, voiceId: voiceId!, 
              )
              .whenComplete(() {
                _stopListening();
              });
        }
      },
      onSoundLevelChange: (level) {
        if (isChatOpen) return;
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

  // Future<void> _connectLiveKit(Data data) async {
  //   if (_room != null) return;

  //   try {
  //     final room = Room();
  //     await room.connect(
  //       data.livekitUrl!,
  //       data.livekitClientToken!,
  //       roomOptions: const RoomOptions(adaptiveStream: true),
  //     );

  //     _room = room;
  //     _isSessionActive = true;

  //     // Publish audio (your mic)
  //     _localAudioTrack = await LocalAudioTrack.create();
  //     await room.localParticipant?.publishAudioTrack(_localAudioTrack!);

  //     // Subscribe to existing remote video tracks if already published
  //     room.remoteParticipants.values.forEach((participant) {
  //       for (var pub in participant.subscribedTracks) {
  //         if (pub.track is RemoteVideoTrack) {
  //           setState(() {
  //             _remoteVideoTrack = pub.track as RemoteVideoTrack;
  //           });
  //           break;
  //         }
  //       }
  //     });

  //     // Listen for new subscribed tracks
  //     _roomListener = room.createListener()
  //       ..on<TrackSubscribedEvent>((event) {
  //         if (event.track is RemoteVideoTrack) {
  //           setState(() {
  //             _remoteVideoTrack = event.track as RemoteVideoTrack;
  //           });
  //         }
  //         if (event.track is RemoteAudioTrack) {
  //           debugPrint('Remote audio subscribed');
  //         }
  //       });
  //   } catch (e) {
  //     debugPrint('LiveKit connection error: $e');
  //     _endSession();
  //   }
  // }
  
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

    _localAudioTrack = await LocalAudioTrack.create();
    await room.localParticipant?.publishAudioTrack(_localAudioTrack!);

    room.remoteParticipants.values.forEach((participant) {
      for (var pub in participant.subscribedTracks) {
        if (pub.track is RemoteVideoTrack) {
          setState(() {
            _remoteVideoTrack = pub.track as RemoteVideoTrack;
          });
          break;
        }
      }
    });

    _roomListener = room.createListener()
      ..on<TrackSubscribedEvent>((event) {
        if (event.track is RemoteVideoTrack) {
          setState(() {
            _remoteVideoTrack = event.track as RemoteVideoTrack;
          });
        }
      });
    Timer(const Duration(seconds: 60), () async {
      if (_isSessionActive) {
        final sessionId = await sharedPrefs.getSessionId();
        if (sessionId != null) {
          context.read<StopSessionCubit>().stopSession(sessionId: sessionId);
        }
      }
    });

  } catch (e) {
    debugPrint('LiveKit connection error: $e');
    _endSession();
  }
}


  Widget buildAvatarView() {
    if (_remoteVideoTrack == null) {
      if (avatarPreviewUrl != null && avatarPreviewUrl!.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: avatarPreviewUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) =>   Center(child: CircularProgressIndicator(color: AppColors.primary,),),
          errorWidget: (context, url, error) =>SizedBox()
              // Image.asset(AppAssets.homeBackground, fit: BoxFit.cover),
        );
      }

      // return Image.asset(AppAssets.homeBackground, fit: BoxFit.cover);
      return SizedBox();
    }
    return SizedBox.expand(
      child: VideoTrackRenderer(_remoteVideoTrack!, fit: VideoViewFit.cover),
    );
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
            if (state is StartSessionSuccess &&
                state.startSession.data != null) {

              _connectLiveKit(state.startSession.data!);
              if (!_keepAliveCalled) {
                final sessionId = await sharedPrefs.getSessionId();
                if (sessionId != null) {
                  context.read<KeepSessionAliveCubit>().keepSessionAlive(
                    sessionId: sessionId,
                  );
                  _keepAliveCalled = true;
                  _startKeepAliveTimer(sessionId);
                }
              }
            }
            if (state is StartSessionFailure) {
              _endSession();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // content: Text(state.errMessage)
                  content: Text("Failed to start session. Please try again."),
                ),
              );
            }
          },
        ),
        BlocListener<StopSessionCubit, StopSessionState>(
          listener: (context, state) {
            if (state is StopSessionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.stopSession.message ?? "Stopped Successfully",
                  ),
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
      ],
      child: BlocConsumer<VoiceTextCubit, VoiceTextState>(
        listener: (context, state) {
          if (state is VoiceTextSuccess && !_isSessionActive) {
            context.read<StartSessionCubit>().startSession();
          }

          if (state is VoiceTextFailure) {
            String message;

            if (avatarId == null || avatarId!.isEmpty) {
              message = "Please select an avatar to enable voice.";
            } else {
              message = "Something went wrong. Please try again.";
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
               message   ,
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                backgroundColor: AppColors.redColor,
              ),
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
                          // if (_isSessionActive) {
                          //   _showEndSessionDialog();
                          // } else {
                            showDialog(
                              context: context,
                              builder: (_) => BlocProvider(
                                create: (_) => getIt.get<LogOutCubit>(),
                                child: AlertDialogBody(),
                              ),
                            );
                          }
                        
                      ),
                      // _isSessionActive
                      //     ? GlassIconButton(
                      //         icon: Icons.volume_up,
                      //         onTap: _isSessionActive
                      //             ? _showEndSessionDialog
                      //             : null,
                      //       )
                      //  
                      //   : SizedBox(),
                   Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: Colors.white.withOpacity(0.6), 
      width: 2,
    ),
  ),
  child:CircleAvatar(
  radius: 28,
  backgroundColor: AppColors.blueGrey, 
  child: ClipOval(
    child: CachedNetworkImage(
      imageUrl:logo??"" ,
      width: 56, 
      height: 56,
      fit: BoxFit.cover,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      errorWidget: (context, url, error) => SizedBox(),
    ),
  ),
)

),

                    
                    ],

                  ),
                ),

                ChtaView(
                  isChatOpen: isChatOpen,
                  selectedLanguage: detectedLanguage,

                  onClose: () {
                    setState(() {
                      isChatOpen = false;
                    });
                    _toggleMuteAvatar(false);

                    if (mounted && !_isListening && !_isRestarting) {
                      _resumeListening();
                    }
                  },
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
                      // GlassIconButton(
                      //   icon: Icons.mic,
                      //   onTap: _isListening ? null : _startListening,
                      // ),
                      // GlassIconButton(
                      //   icon: !_isSessionActive
                      //       ? Icons.mic
                      //       : (isChatOpen ? Icons.mic_off : Icons.mic),
                      //   onTap: (!_isSessionActive)
                      //       ? null
                      //       : (isChatOpen ? null : _startListening),
                      // ),
                     GlassIconButton(
  icon: _isMuted ? Icons.mic_off : Icons.mic,
  onTap: isChatOpen ? null : _toggleMic,
),



                      const SizedBox(width: 24),
                      buildWave(),
                      const SizedBox(width: 24),

                      // GlassIconButton(
                      //   icon: Icons.chat,
                      //   isActive: isChatOpen,
                      //   onTap: () => setState(() => isChatOpen = !isChatOpen),
                      // ),
                      // GlassIconButton(
                      //   icon: Icons.chat,
                      //   isActive: isChatOpen,
                      //   onTap: () {
                      //     final willOpenChat = !isChatOpen;

                      //     setState(() {
                      //       isChatOpen = willOpenChat;
                      //     });

                      //     if (willOpenChat) {
                      //       _stopListening();
                      //     } else {
                      //       Future.delayed(
                      //         const Duration(milliseconds: 300),
                      //         () {
                      //           if (mounted) {
                      //             _resumeListening();
                      //           }
                      //         },
                      //       );
                      //     }
                      //   },
                      // ),
                      GlassIconButton(
                        icon: Icons.chat,
                        isActive: isChatOpen,
                        onTap: () {
                          final willOpenChat = !isChatOpen;

                          setState(() {
                            isChatOpen = willOpenChat;
                          });

                          if (willOpenChat) {
                            _stopListening();
                            _toggleMuteAvatar(true);
                          } else {
                            _toggleMuteAvatar(false);
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                if (mounted) {
                                  _resumeListening();
                                }
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
