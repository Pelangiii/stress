// import 'package:flutter/material.dart';
// import 'dart:math' as math;

// class StressGaugePainter extends CustomPainter {
//   final double radius;
//   final double centerX;
//   final double centerY;
//   final double startAngle;
//   final double sweepAngle;
//   final double currentValue;

//   StressGaugePainter({
//     required this.radius,
//     required this.centerX,
//     required this.centerY,
//     required this.startAngle,
//     required this.sweepAngle,
//     required this.currentValue,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint grayPaint = Paint()
//       ..color = const Color(0xFF9E9E9E).withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4.0
//       ..strokeCap = StrokeCap.round;

//     canvas.drawArc(
//       Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
//       startAngle,
//       -sweepAngle,
//       false,
//       grayPaint,
//     );

//     final Paint orangePaint = Paint()
//       ..color = Colors.orange
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4.0
//       ..strokeCap = StrokeCap.round;

//     canvas.drawArc(
//       Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
//       startAngle,
//       -(currentValue * sweepAngle),
//       false,
//       orangePaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
