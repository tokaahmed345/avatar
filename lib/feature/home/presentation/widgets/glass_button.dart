import 'package:avatar/core/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const GlassIconButton({
    super.key,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? AppColors.whiteColor
              : AppColors.primary.withOpacity(.5),
        ),
        child: Icon(
          icon,
          color: isActive
              ? AppColors.primary
              : AppColors.whiteColor,
        ),
      ),
    );
  }
}
