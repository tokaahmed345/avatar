import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/core/utils/widgets/snackbar.dart';
import 'package:avatar/feature/session/presentation/view_model/stop_session_cubit/stop_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndSessionDialog extends StatelessWidget {
  const EndSessionDialog({super.key, this.onEnd});
final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    return Center(
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
                "Do you want to end the session?",
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
                  // End Session button
                  BlocConsumer<StopSessionCubit, StopSessionState>(
                    listener: (context, state) {
                      if (state is StopSessionFailure) {
                        showSnackBarFuction(context, state.errMessage, isError: true);
                      }

                      if (state is StopSessionSuccess) {


                        showSnackBarFuction(
                          context,
                          state.stopSession.message ?? "Session Ended",
                          isError: false,
                        );
                              Navigator.pop(context);
                                if (onEnd != null) onEnd!(); 
                      }
                    },
                    builder: (context, state) {
                      return state is StopSessionLoading
                          ? const Center(
                              child: CircularProgressIndicator(color: AppColors.primary),
                            )
                          : ElevatedButton(
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
                                if (context.mounted) {
                                  final prefs = getIt.get<SharedPrefs>();
                                  final sessionId = await prefs.getSessionId();
                                  if (sessionId != null) {
                                    context.read<StopSessionCubit>().stopSession(sessionId: sessionId);
                                  }
                                }
                              },
                              child: Text(
                                "End",
                                style: AppStyle.text18.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
