import 'package:flutter/material.dart';

Color getProgressColor(double progress) {
  if (progress < 33) return Colors.redAccent;
  if (progress < 66) return Colors.orangeAccent;
  return Colors.greenAccent;
}

class GoalNodeWidget extends StatelessWidget {
  final String name;
  final double progress;

  const GoalNodeWidget({required this.name, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[500]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 4),
          ),
        ],
      ),
      constraints: BoxConstraints(minHeight: 80, minWidth: 100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis, // 👈 adds ...
              maxLines: 3, // optionally limit lines
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(getProgressColor(progress)),
            ),
          ),
        ],
      ),
    );
  }
}