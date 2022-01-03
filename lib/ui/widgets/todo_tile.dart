import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String title, description;
  final bool hasDone;
  final void Function()? onClick, onDelete;

  const ToDoTile({
    Key? key,
    this.title = "ToDo Title",
    this.description = "ToDo Description",
    this.hasDone = false,
    this.onClick,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) => onDelete?.call(),
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration:
                hasDone ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.check_circle,
            color: hasDone ? Colors.green : Colors.grey,
          ),
          onPressed: onClick,
        ),
      ),
    );
  }
}
