import 'package:flutter/material.dart';
import 'package:graphite/graphite.dart';

class GoalHierarchyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const goalNodes = '['
        '{"id":"Goal 1","next":[{"outcome":"Goal 2","type":"one"},{"outcome":"Goal 3","type":"one"},{"outcome":"Goal 4","type":"one"}]},'
        '{"id":"Goal 2","next":[]},'
        '{"id":"Goal 3","next":[{"outcome":"Goal 5","type":"one"}]},'
        '{"id":"Goal 4","next":[{"outcome":"Goal 5","type":"one"},{"outcome":"Goal 6","type":"one"}]},'
        '{"id":"Goal 5","next":[]},'
        '{"id":"Goal 6","next":[{"outcome":"Goal 7","type":"one"},{"outcome":"Goal 8","type":"one"}]},'
        '{"id":"Goal 7","next":[]},'
        '{"id":"Goal 8","next":[]}'
        ']';

    List<NodeInput> list = nodeInputFromJson(goalNodes);
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.account_tree_rounded,
          color: Colors.blue,
        ),
        title: Text('Goal Hierarchy'),
      ),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.5,
        maxScale: 2.0,
        boundaryMargin: EdgeInsets.all(800),
        child: DirectGraph(
          list: list,
          centered: true,
          defaultCellSize: Size(100.0, 80.0),
          cellPadding: EdgeInsets.all(30.0),
          orientation: MatrixOrientation.Vertical,
          nodeBuilder: (context, node) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                node.id,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          styleBuilder: (edge) {
            var paint = Paint()
              ..color = Colors.grey
              ..style = PaintingStyle.stroke
              ..strokeCap = StrokeCap.round // Ensure rounded ends
              ..strokeJoin = StrokeJoin.round // Ensure smooth, rounded corners
              ..strokeWidth = 3;

            return EdgeStyle(
              lineStyle: LineStyle.solid,
              linePaint: paint,
              borderRadius:
                  80, // Optional: Adjust line radius for smoother curves
            );
          },
        ),
      ),
    );
  }
}
