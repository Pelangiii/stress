import 'package:flutter/material.dart';
import 'dart:math' as math;

class StressGaugePainter extends CustomPainter {
  final double radius;
  final double centerX;
  final double centerY;
  final double startAngle;
  final double sweepAngle;
  final double currentValue;

  StressGaugePainter({
    required this.radius,
    required this.centerX,
    required this.centerY,
    required this.startAngle,
    required this.sweepAngle,
    required this.currentValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Gray full arc (dashed-like with low opacity)
    final Paint grayPaint = Paint()
      ..color = const Color(0xFF9E9E9E).withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Draw full gray arc clockwise
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      -sweepAngle, // Negative for clockwise
      false,
      grayPaint,
    );

    // Orange progress arc
    final Paint orangePaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Draw orange arc up to currentValue clockwise
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      startAngle,
      - (currentValue * sweepAngle),
      false,
      orangePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}