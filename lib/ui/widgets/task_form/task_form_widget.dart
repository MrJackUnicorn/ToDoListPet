import 'package:flutter/material.dart';
import 'package:to_do_list_project/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;
  const TaskFormWidget({super.key, required this.groupKey});

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TasksFormWidgetModelProvider(
      model: _model,
      child: const _TextFormWidgetBody(),
    );
  }
}

class _TextFormWidgetBody extends StatelessWidget {
  const _TextFormWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new task')),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: _TaskTextWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            TasksFormWidgetModelProvider.read(context)?.model.saveTask(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget();

  @override
  Widget build(BuildContext context) {
    final model = TasksFormWidgetModelProvider.read(context)?.model;

    return TextField(
      expands: true,
      maxLines: null,
      minLines: null,
      onEditingComplete: () => model?.saveTask(context),
      onChanged: (value) => model?.taskText = value,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Task Text',
      ),
    );
  }
}
