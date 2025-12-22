
import 'dart:ui';

import 'package:flutter/material.dart';

class LoginCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.75, 0);
    path.quadraticBezierTo(
      size.width * 0.92,
      size.height * 0.02,
      size.width,
      size.height * 0.18,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
