import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:avatar/core/utils/styles/app_style.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool obscure;
  final VoidCallback? onPressed;

  const CustomFormField({
    super.key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.icon,
    this.suffixIcon,
    this.obscure = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
    vertical: 12, 
    horizontal: 16,
  ),
        hintText: hint,
        hintStyle: AppStyle.text14.copyWith(fontWeight: FontWeight.w500,color: AppColors.lightGrey),
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.primary)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon, color: AppColors.primary),
                onPressed: onPressed,
              )
            : null,
        // filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
                     borderSide:
        BorderSide(color: AppColors.primary ,width: 1.5),
     
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
        BorderSide(color: AppColors.primary,width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
