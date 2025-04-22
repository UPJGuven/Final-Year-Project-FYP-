// goal_detail_popup.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

void showGoalDetailPopup({
  required BuildContext context,
  required String goalId,
  required VoidCallback onEdit,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('Goal').doc(goalId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data == null) {
                return Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text("Goal not found"),
                  ),
                );
              }

              final details = data['goalDetails'] ?? {};
              final name = details['name'] ?? '[Unnamed]';
              final description = details['description'] ?? '';
              final startDate = (details['startDate'] as Timestamp).toDate();
              final endDate = (details['endDate'] as Timestamp).toDate();

              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                  child: Material(
                    color: Colors.white.withOpacity(0.9),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
                      padding: const EdgeInsets.all(20),
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 4.0,
                          radius: Radius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Icon(Icons.flag_rounded, size: 50, color: Colors.orange[600]),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    description,
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Start", style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                                          Text(
                                            "${startDate.day}/${startDate.month}/${startDate.year}",
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("End", style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                                          Text(
                                            "${endDate.day}/${endDate.month}/${endDate.year}",
                                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange[600],
                                        foregroundColor: Colors.white,
                                      ),
                                      icon: Icon(Icons.edit),
                                      label: Text("Edit Goal"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        onEdit();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ));
      return SlideTransition(position: slideAnimation, child: child);
    },
  );
}
