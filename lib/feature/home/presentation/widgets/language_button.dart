import 'dart:ui';
import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';


class LanguageButton extends StatelessWidget {
  final String text;
final void Function() onTap;
  const LanguageButton({
    super.key,
    required this.text,required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.7),
              shape: BoxShape.circle,
            ),
            child: Text(
              text,
              style: AppStyle.text20.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.whiteColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
