import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/router/routes_name.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/core/utils/widgets/snackbar.dart';
import 'package:avatar/feature/auth/presentation/view_model/log_out_cubit/log_out_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AlertDialogBody extends StatelessWidget {
  const AlertDialogBody({super.key});

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
                "Confirm Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Are you sure you want to logout?",
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
                  // Logout button
                  BlocConsumer<LogOutCubit, LogOutState>(
                    listener: (context, state) {
    print('STATE ===> $state');

    if (state is LogOutFailure) {
      showSnackBarFuction(context, state.errMessage, isError: true);
    }

    if (state is LogOutSuccess) {
            if (context.mounted) context.go(RoutesName.logIn);

  // showSnackBarFuction(context,state.successMessage.detail??"", isError: false);

}
                    },
                    builder: (context, state) {
                      return state is LogOutLoading?Center(child: CircularProgressIndicator(color: AppColors.primary,),):  ElevatedButton(
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
    await prefs.clearSession();
  context.read<LogOutCubit>().logOut();

                          }
                        },
                        child: Text(
                          "Logout",
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
