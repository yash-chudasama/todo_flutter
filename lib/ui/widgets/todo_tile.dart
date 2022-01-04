import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ToDoTile extends StatelessWidget {
  final String title, description;
  final bool hasDone;
  final DateTime? date;
  final void Function()? onClick, onDelete;
  final DateFormat dateFormat = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
  final nowDate = DateTime.now();

  ToDoTile({
    Key? key,
    this.title = "ToDo Title",
    this.description = "ToDo Description",
    this.hasDone = false,
    this.date,
    this.onClick,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) => onDelete?.call(),
          backgroundColor: const Color(0xFFFE4A49),
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
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              dateFormat.format(date ?? DateTime.now()),
              style: TextStyle(
                fontSize: 12,
                color:
                    (DateTime(nowDate.year, nowDate.month, nowDate.day, 23, 59)
                                .isAfter(date ?? nowDate) &&
                            !hasDone)
                        ? Colors.red
                        : Colors.grey,
              ),
            ),
          ],
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
