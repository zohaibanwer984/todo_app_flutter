import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/task_creatation_box.dart';
import 'package:todo_app_flutter/todo_task_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _inputTaskController = TextEditingController();

  List<String> _todoTasks = [];
  final List<bool> _todoTasksFlags = [];

  Future<void> _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("todo_task_list")) {
      return;
    }
    setState(() {
      _todoTasks = prefs.getStringList("todo_task_list")!;
      for (String t in _todoTasks) {
        bool isDone = (t.split(', ')[1] == "1") ? true : false;
        _todoTasksFlags.add(isDone);
      }
    });
  }

  Future<void> _save() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("todo_task_list", _todoTasks);
  }

  _createTask() {
    setState(() {
      _todoTasks.add("${_inputTaskController.text}, 0");
      _todoTasksFlags.add(false);
      _inputTaskController.clear();
      _save();
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "TODO APP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TaskCreatationBox(
                inputTaskController: _inputTaskController,
                creationCallback: _createTask,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _todoTasks.length,
                  itemBuilder: (context, index) {
                    return TodoTaskWidget(
                      task: Text(
                        _todoTasks[index].split(", ")[0],
                        style: (_todoTasks[index].split(", ")[1] == "1")
                            ? const TextStyle(
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.lineThrough,
                              )
                            : const TextStyle(
                                fontStyle: FontStyle.normal,
                                decoration: TextDecoration.none,
                              ),
                      ),
                      isDone: _todoTasksFlags[index],
                      onMarkDone: (value) {
                        setState(() {
                          _todoTasksFlags[index] = value!;
                          _todoTasks[index] = _todoTasks[index].replaceFirst(
                              RegExp(r'0|1'), (value == true) ? '1' : '0');
                          _save();
                        });
                      },
                      onPressRemove: () {
                        setState(() {
                          _todoTasks.removeAt(index);
                          _todoTasksFlags.removeAt(index);
                          _save();
                        });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
