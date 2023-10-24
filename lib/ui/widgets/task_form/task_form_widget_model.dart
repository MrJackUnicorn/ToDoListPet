import 'package:flutter/material.dart';
import 'package:to_do_list_project/domain/entity/data_provider/box_manager.dart';
import '../../../domain/entity/task.dart';

class TaskFormWidgetModel {
  int groupKey;
  var taskText = '';

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;
    final task = Task(text: taskText, isDone: false);
    final box = await BoxManager.instanse.openTasksBox(groupKey);
    await box.add(task);
    await BoxManager.instanse.closeBox(box);
    Navigator.of(context).pop();
  }
}

class TasksFormWidgetModelProvider extends InheritedNotifier {
  final TaskFormWidgetModel model;
  const TasksFormWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static TasksFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksFormWidgetModelProvider>();
  }

  static TasksFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TasksFormWidgetModelProvider>()
        ?.widget;
    0;
    return widget is TasksFormWidgetModelProvider ? widget : null;
  }
}
