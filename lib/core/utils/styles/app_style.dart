import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
   static final TextStyle _baseStyle = GoogleFonts.inter(
        color: AppColors.textColor,

  );
   static final text20 = _baseStyle.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 20,

  );
  static final text14 = _baseStyle.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14,

  );
  static final text18 = _baseStyle.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 18,

  );
    static final text16 = _baseStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 16,

  );
   static final text28 = _baseStyle.copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 28,

  );
}