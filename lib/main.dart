import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _todoTasks = [];
  List<bool> _todoTasksFlags = [];

  Future<void> _load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("todo_task_list")) {
      setState(() {
        _todoTasks = prefs.getStringList("todo_task_list")!;
        for (var t in _todoTasks) {
          bool isDone = (t.split(', ')[1] == "1") ? true : false;
          _todoTasksFlags.add(isDone);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: const Text(
            "TODO APP",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: const TextField(
                      decoration:
                          InputDecoration.collapsed(hintText: "TODO TASK"),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _todoTasks.add("NEW TASK, 0");
                          _todoTasksFlags.add(false);
                        });
                      },
                      icon: const Icon(Icons.create_rounded),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _todoTasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 2),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          leading: Checkbox(
                            value: _todoTasksFlags[index],
                            onChanged: (value) {
                              setState(() {
                                _todoTasksFlags[index] = value!;
                                _todoTasks[index] = _todoTasks[index]
                                    .replaceFirst(RegExp(r'0|1'),
                                        (value == true) ? '1' : '0');
                              });
                            },
                          ),
                          title: Text(
                            _todoTasks[index].split(", ")[0],
                            style: TextStyle(
                              decoration:
                                  (_todoTasks[index].split(", ")[1] == "1")
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                _todoTasks.removeAt(index);
                                _todoTasksFlags.removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ),
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
