import 'package:flutter/material.dart';

Color getProgressColor(double progress) {
  if (progress < 33) return Colors.redAccent;
  if (progress < 99) return Colors.orangeAccent;
  return Colors.greenAccent;
}

class GoalNodeWidget extends StatelessWidget {
  final String name;
  final double progress;

  const GoalNodeWidget({required this.name, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 110, minHeight: 160),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[500]!, Colors.blue[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: null,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 6,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                  getProgressColor(progress),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}