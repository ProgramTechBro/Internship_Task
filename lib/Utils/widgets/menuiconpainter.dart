import 'package:flutter/material.dart';
class MenuIconPainter extends CustomPainter {
  final Color color;
  final double lineWidth;
  final double lineHeight;
  final double gap;

  MenuIconPainter({
    required this.color,
    this.lineWidth = 20.0,
    this.lineHeight = 1.5,
    this.gap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = lineHeight
      ..strokeCap = StrokeCap.round;

    double startY = (size.height - (lineHeight * 4 + gap * 3)) / 2;

    for (int i = 0; i < 4; i++) {
      double startX = (size.width - lineWidth) / 2;
      double endX = startX + lineWidth;
      double centerY = startY + lineHeight / 2;
      canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);
      startY += lineHeight + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}