import 'package:flutter/material.dart';

class TodoTaskWidget extends StatelessWidget {
  final ValueChanged<bool?> onMarkDone;
  final VoidCallback onPressRemove;
  final bool isDone;
  final Text task;
  const TodoTaskWidget({
    super.key,
    required this.isDone,
    required this.onMarkDone,
    required this.onPressRemove,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 2),
      child: Card(
        elevation: 3,
        child: ListTile(
          leading: Checkbox(
            value: isDone,
            onChanged: onMarkDone,
          ),
          title: task,
          trailing: IconButton(
            onPressed: onPressRemove,
            icon: const Icon(
              Icons.close,
            ),
          ),
        ),
      ),
    );
  }
}
