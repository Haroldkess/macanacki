import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width * 0.0025000, 0);
    path0.quadraticBezierTo(size.width * -0.0203125, size.height * 0.0975000,
        size.width * 0.0187500, size.height * 0.1900000);
    path0.cubicTo(
        size.width * 0.1318750,
        size.height * 0.2915000,
        size.width * 0.3606250,
        size.height * 0.3825000,
        size.width * 0.4750000,
        size.height * 0.4700000);
    path0.cubicTo(
        size.width * 0.5065625,
        size.height * 0.4860000,
        size.width * 0.5284375,
        size.height * 0.4740000,
        size.width * 0.5337500,
        size.height * 0.4700000);
    path0.cubicTo(
        size.width * 0.6512500,
        size.height * 0.3720000,
        size.width * 0.8675000,
        size.height * 0.2900000,
        size.width * 0.9825000,
        size.height * 0.1880000);
    path0.quadraticBezierTo(size.width * 1.0187500, size.height * 0.1040000,
        size.width * 0.9975000, 0);
    path0.lineTo(size.width * 0.0025000, 0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
