import 'package:avatar/core/utils/assets/app_assets.dart';
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:avatar/core/utils/widgets/custom_text_form_field.dart';
import 'package:avatar/feature/auth/presentation/widgets/sign_in_curve_clipper.dart';
import 'package:avatar/feature/auth/presentation/widgets/sign_in_view_body.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:SignInViewBody()
    );
  }
}
