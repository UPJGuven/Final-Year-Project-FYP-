import 'package:flutter/material.dart';
import '../todo_service.dart';
import 'settings_screen.dart';
import 'help_guidance_screen.dart';

class ToDoListScreen extends StatefulWidget {
  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final Map<String, TextEditingController> _controllers = {};
  // textbox controllers
  final Map<String, FocusNode> _focusNodes = {};
  // focused items
  String? _editingTaskId;
  // track which items are being edited
  bool _isLoading = true;
  List<Map<String, dynamic>> _tasks = [];
  // to-do list list


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
  // initialise task list from todo_service's getUserTasks()

  void _refreshTasks() async {
    final fetchedTasks = await getUserTasks().first;
    setState(() {
      _tasks = fetchedTasks;
    });
  }

  // refresh tasks

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
  // when user stops editing a to-do, call todo_service's updateTask()

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    _focusNodes.values.forEach((f) => f.dispose());
    super.dispose();
  }
  // stops memory leak and performance issues

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
            Text("To-Do",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(width: 8),
            Image.asset('assets/images/FYP Logo No Text v1.0.png', height: 30),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => HelpGuidanceScreen(showOnComplete: false))),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => SettingsScreen())),
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
                    child: Text("Tap the '+' button to add your first to-do!",
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[600])),
                  )
                : ReorderableListView.builder(
                    itemCount: _tasks.length,
                    onReorder: (oldIndex, newIndex) async {
                      if (newIndex > oldIndex) newIndex--;
                      // adjust newIndex if the item is moved down the list

                      final updated = List.of(_tasks);

                      // clone the current task list to reorder it

                      final moved = updated.removeAt(oldIndex);
                      updated.insert(newIndex, moved);
                      // remove the item from its old position and insert it into the new position

                      setState(() => _tasks = updated);
                      // update UI

                      for (int i = 0; i < updated.length; i++) {
                        await updateTaskPosition(updated[i]['id'], i);
                      }

                      // update the position of each task in firebase to create the new order

                      await Future.delayed(Duration(milliseconds: 250));
                      _refreshTasks();
                    },
                    buildDefaultDragHandles: false,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      final taskId = task['id'];
                      _controllers.putIfAbsent(taskId,
                          () => TextEditingController(text: task['text']));
                      _focusNodes.putIfAbsent(taskId, () {
                        final node = FocusNode();
                        node.addListener(() {
                          if (!node.hasFocus && _editingTaskId == taskId) {
                            _unfocusAndSave(taskId, task['completed']);
                          }
                        });
                        // if focus is lost and this was the editing task, save changes
                        return node;
                      });

                      return Container(
                        key: ValueKey(taskId),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 8),
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
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              task['completed']
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: task['completed']
                                  ? Colors.orange[600]
                                  : Colors.white,
                            ),
                            onPressed: () {
                              updateTask(taskId, _controllers[taskId]!.text,
                                      !task['completed'])
                                  .then((_) => _refreshTasks());
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
                                    decoration: task['completed']
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() => _editingTaskId = taskId);
                                    _focusNodes[taskId]!.requestFocus();
                                  },
                                  child: Text(
                                    _controllers[taskId]!.text.isEmpty
                                        ? 'Enter task...'
                                        : _controllers[taskId]!.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontStyle:
                                          _controllers[taskId]!.text.isEmpty
                                              ? FontStyle.italic
                                              : FontStyle.normal,
                                      color: Colors.white,
                                      decoration: task['completed']
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),

                          // code to edit to-do list text

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PopupMenuButton<String>(
                                icon: Icon(Icons.delete_forever_rounded,
                                    color: Colors.white),
                                onSelected: (value) {
                                  if (value == 'delete')
                                    deleteTask(taskId)
                                        .then((_) => _refreshTasks());
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 'delete', child: Text('Delete')),
                                ],
                              ),

                              // delete to-do task button

                              GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(Icons.drag_handle,
                                      color: Colors.white),
                                ),
                              ),

                              // drag to-do task button
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

      // create to-do task button

    );
  }
}
