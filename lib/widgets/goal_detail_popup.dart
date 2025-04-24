import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

void showGoalDetailPopup({
  required BuildContext context,
  required String goalId,
  required VoidCallback onEdit,
  required VoidCallback onSubGoal,
  required VoidCallback onParentGoal,
  required VoidCallback onDelete,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Goal Details",
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 300),

    // barrier outline

    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.fromLTRB(24, 24, 24, 60),
          child: FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance.collection('Goal').doc(goalId).get(),



            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data!.data() as Map<String, dynamic>?;
              if (data == null) {
                return Center(child: Text("Goal not found"));
              }
              // get goal data

              final details = data['goalDetails'] ?? {};
              final name = details['name'] ?? '[Unnamed]';
              final description = details['description'] ?? '';
              final startDate = (details['startDate'] as Timestamp).toDate();
              final endDate = (details['endDate'] as Timestamp).toDate();
              final hasParent =
                  data['parentGoalId'] != null && data['parentGoalId'] != '';
              double progress = (details['progress'] ?? 0).toDouble();

              // assign goal data to UI variables.

              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.75,
                    ),
                    color: Colors.white.withOpacity(0.95),
                      child: Scrollbar(
                        radius: Radius.circular(8),
                        thumbVisibility: true,
                        thickness: 5,
                        child: StatefulBuilder(
                          builder: (context, setState) => SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
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
                                    Icon(Icons.flag_rounded,
                                        size: 50, color: Colors.blue),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(description,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Start",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 18)),
                                        Text(
                                            "${startDate.day}/${startDate.month}/${startDate.year}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("End",
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 18)),
                                        Text(
                                            "${endDate.day}/${endDate.month}/${endDate.year}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),

                                Text("Progress: ${progress.toInt()}%",
                                    style: TextStyle(fontSize: 16)),
                                Slider(
                                  value: progress,
                                  min: 0,
                                  max: 100,
                                  divisions: 20,
                                  label: "${progress.toInt()}%",
                                  activeColor: Colors.blue,
                                  thumbColor: Colors.orange[600],
                                  onChanged: (value) =>
                                      setState(() => progress = value),
                                  onChangeEnd: (value) async {
                                    await FirebaseFirestore.instance
                                        .collection('Goal')
                                        .doc(goalId)
                                        .update({
                                      'goalDetails.progress': value,
                                    });
                                  },
                                ),

                                // progress slider, updates progress field in firebase upon change

                                SizedBox(height: 24),

                                Center(
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      ElevatedButton.icon(
                                        icon: Icon(Icons.edit),
                                        label: Text("Edit"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange[600],
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          onEdit();
                                        },
                                      ),

                                      // edit goal button

                                      ElevatedButton.icon(
                                        icon: Icon(Icons.add_box_rounded),
                                        label: Text("Subgoal"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange[600],
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          onSubGoal();
                                        },
                                      ),

                                      // create subgoal button

                                      if (!hasParent)
                                        ElevatedButton.icon(
                                          icon: Icon(Icons.arrow_circle_up),
                                          label: Text("Parent Goal"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange[600],
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            onParentGoal();
                                          },
                                        ),

                                      // create parent goal button

                                      ElevatedButton.icon(
                                        icon: Icon(Icons.delete_forever),
                                        label: Text("Delete"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[600],
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          onDelete();
                                        },
                                      ),

                                      // delete button

                                    ],
                                  ),
                                )
                              ],
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
      return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );

      // goal widget slide up animation.
    },
  );
}
