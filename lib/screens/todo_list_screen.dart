import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../todo_service.dart';
import 'settings_screen.dart';
import 'help_guidance_screen.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  String? _editingTaskId;
  bool _isLoading = true;
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    getUserTasks().first.then((fetchedTasks) {
      setState(() {
        _tasks = fetchedTasks;
        _isLoading = false;
      });
    });
  }

  void _refreshTasks() async {
    final fetchedTasks = await getUserTasks().first;
    setState(() {
      _tasks = fetchedTasks;
    });
  }

  void _unfocusAndSave(String taskId, bool completed) {
    final controller = _controllers[taskId];
    if (controller != null) {
      final newText = controller.text.trim();
      if (newText.isNotEmpty) {
        updateTask(taskId, newText, completed);
      }
    }
    setState(() => _editingTaskId = null);
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    _focusNodes.values.forEach((f) => f.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("To-Do", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(width: 8),
            Image.asset('assets/images/FYP Logo No Text v1.0.png', height: 30),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpGuidanceScreen(showOnComplete: false))),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text("Tap the '+' button to add your first to-do!", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ),
        )
            : ReorderableListView.builder(
          itemCount: _tasks.length,
          onReorder: (oldIndex, newIndex) async {
            if (newIndex > oldIndex) newIndex--;
            final updated = List.of(_tasks);
            final moved = updated.removeAt(oldIndex);
            updated.insert(newIndex, moved);

            setState(() => _tasks = updated);

            for (int i = 0; i < updated.length; i++) {
              await updateTaskPosition(updated[i]['id'], i);
            }

            await Future.delayed(Duration(milliseconds: 250));
            _refreshTasks();
          },
          buildDefaultDragHandles: false,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            final taskId = task['id'];
            _controllers.putIfAbsent(taskId, () => TextEditingController(text: task['text']));
            _focusNodes.putIfAbsent(taskId, () {
              final node = FocusNode();
              node.addListener(() {
                if (!node.hasFocus && _editingTaskId == taskId) {
                  _unfocusAndSave(taskId, task['completed']);
                }
              });
              return node;
            });

            return Container(
              key: ValueKey(taskId),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: IconButton(
                  icon: Icon(
                    task['completed'] ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: task['completed'] ? Colors.orange[600] : Colors.white,
                  ),
                  onPressed: () {
                    updateTask(taskId, _controllers[taskId]!.text, !task['completed']).then((_) => _refreshTasks());
                  },
                ),
                title: _editingTaskId == taskId
                    ? TextField(
                  focusNode: _focusNodes[taskId],
                  controller: _controllers[taskId],
                  onEditingComplete: () {
                    _unfocusAndSave(taskId, task['completed']);
                    FocusScope.of(context).unfocus();
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter task...',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.visible,
                    color: Colors.white,
                    decoration: task['completed'] ? TextDecoration.lineThrough : null,
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    setState(() => _editingTaskId = taskId);
                    _focusNodes[taskId]!.requestFocus();
                  },
                  child: Text(
                    _controllers[taskId]!.text.isEmpty ? 'Enter task...' : _controllers[taskId]!.text,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: _controllers[taskId]!.text.isEmpty ? FontStyle.italic : FontStyle.normal,
                      color: Colors.white,
                      decoration: task['completed'] ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PopupMenuButton<String>(
                      icon: Icon(Icons.delete_forever_rounded, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'delete') deleteTask(taskId).then((_) => _refreshTasks());
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_handle, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addTask("");
          _refreshTasks();
        },
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
