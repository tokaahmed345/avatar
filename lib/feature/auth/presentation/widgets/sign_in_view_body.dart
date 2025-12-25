import 'package:avatar/core/utils/assets/app_assets.dart';
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/constant/shared_prefrence.dart';
import 'package:avatar/core/utils/function/validators.dart';
import 'package:avatar/core/utils/router/routes_name.dart';
import 'package:avatar/core/utils/service_locator/service_locator.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/core/utils/widgets/custom_text_form_field.dart';
import 'package:avatar/core/utils/widgets/snackbar.dart';
import 'package:avatar/feature/auth/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import 'package:avatar/feature/auth/presentation/widgets/sign_in_curve_clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  @override
  void dispose() {
    _emailController.dispose();

    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Image.asset(
          AppAssets.logIn,
          width: size.width,
          height: size.height,
          fit: BoxFit.cover,
        ),

        SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),

                ClipPath(
                  clipper: LoginCurveClipper(),
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                    color: AppColors.whiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "Email",
                          style: AppStyle.text14.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          hint: "Enter Email",
                          validator: (value) =>
                              Validators.emailValidator(value),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Password",
                          style: AppStyle.text14.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CustomFormField(
                          validator: (value) =>
                              Validators.passwordValidator(value),

                          hint: "Enter Password",
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _rememberMe
                                          ? AppColors.primary
                                          : Colors.transparent,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Text("Remember Me", style: AppStyle.text14),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        BlocConsumer<SignInCubit, SignInState>(
                          listener: (context, state) async {
                            print('STATE ===> $state');

                            if (state is SignInFailure) {
                              showSnackBarFuction(
                                context,
                                state.errorMessage,
                                isError: true,
                              );
                            }

                            if (state is SignInSuccess) {
                              final sharedPrefs = getIt.get<SharedPrefs>();
                              await sharedPrefs.saveIsLoggedIn(true);
                              await sharedPrefs.saveRememberMe(_rememberMe);

                              showSnackBarFuction(
                                context,
                                "Login successfully",
                                isError: false,
                              ).then((_) {
                                if (context.mounted)
                                  context.go(RoutesName.home);
                              });

                              // if (_rememberMe) {
                              //   await sharedPrefs.saveIsLoggedIn(true);
                              // } else {
                              //   await sharedPrefs.saveIsLoggedIn(false);
                              // }
                            }
                          },
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: state is SignInLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.buttonBackground,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                              FocusScope.of(context).unfocus(); 

                                          context.read<SignInCubit>().signIn(
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Sign In",
                                        style: AppStyle.text20.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
