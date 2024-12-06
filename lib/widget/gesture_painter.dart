import 'package:flutter/material.dart';

class GesturePatternPainter extends CustomPainter {
  final List<Offset> points;

  GesturePatternPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(GesturePatternPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}