import 'package:flutter/material.dart';

class TaskCreatationBox extends StatelessWidget {
  final TextEditingController inputTaskController;
  final VoidCallback? creationCallback;
  const TaskCreatationBox({
    super.key,
    required this.inputTaskController,
    required this.creationCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 5,
        child: ListTile(
          title: TextField(
            controller: inputTaskController,
            decoration: const InputDecoration.collapsed(hintText: "TODO TASK"),
          ),
          trailing: IconButton(
            onPressed: creationCallback,
            icon: const Icon(Icons.create_rounded),
          ),
        ),
      ),
    );
  }
}
