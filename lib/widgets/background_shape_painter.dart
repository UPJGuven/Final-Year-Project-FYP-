import 'package:flutter/material.dart';

class BackgroundShapePainter extends CustomPainter {
  final Offset panOffset;

  BackgroundShapePainter(this.panOffset);

  @override
  void paint(Canvas canvas, Size size) {
    final paintOrange = Paint()..color = Colors.orange.shade600.withOpacity(0.5);
    final paintBlue = Paint()..color = Colors.blue.withOpacity(0.5);

    // object colour and opacity

    canvas.drawCircle(Offset(size.width * 0.25 + panOffset.dx * 0.05, size.height * 0.2 + panOffset.dy * 0.05), 120, paintOrange);
    canvas.drawCircle(Offset(size.width * 0.75 + panOffset.dx * 0.03, size.height * 0.3 + panOffset.dy * 0.03), 100, paintBlue);
    canvas.drawCircle(Offset(size.width * 0.5 + panOffset.dx * 0.04, size.height * 0.8 + panOffset.dy * 0.04), 150, paintOrange);
    canvas.drawCircle(Offset(size.width * 0.2 + panOffset.dx * 0.06, size.height * 0.6 + panOffset.dy * 0.06), 80, paintBlue);

    // move shapes slightly based on panning
  }

  @override
  bool shouldRepaint(covariant BackgroundShapePainter oldDelegate) {
    return oldDelegate.panOffset != panOffset;
  }
}
