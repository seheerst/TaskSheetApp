import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_sheet_app/data/localStorage.dart';
import 'package:task_sheet_app/main.dart';
import 'package:task_sheet_app/models/taskModel.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  const TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskController = TextEditingController();
  late LocalStorage _localStorage;
  @override
  void initState() {

    super.initState();
    _localStorage = locator<LocalStorage>();
    _taskController.text = widget.task.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 10,
            ),
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isComplated = !widget.task.isComplated;
            _localStorage.updateTask(task: widget.task);
            setState(() {});
          },
          child: Container(
              decoration: BoxDecoration(
                  color: widget.task.isComplated ? Colors.green : Colors.white,
                  border: Border.all(color: Colors.grey, width: 0.8),
                  shape: BoxShape.circle),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              )),
        ),
        title: widget.task.isComplated
            ? Text(
                widget.task.name,
                style: const TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                textInputAction: TextInputAction.done,
                minLines: 1,
                maxLines: null,
                controller: _taskController,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger) {
                  if (yeniDeger.length > 3) {
                    widget.task.name = yeniDeger;
                    _localStorage.updateTask(task: widget.task,);
                  }
                },
              ),
        trailing: Text(
          DateFormat('hh:mm a').format(widget.task.createdAt),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
    );
  }
}
