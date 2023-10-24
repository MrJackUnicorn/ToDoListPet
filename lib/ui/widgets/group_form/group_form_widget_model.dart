import 'package:flutter/material.dart';

import 'package:to_do_list_project/domain/entity/data_provider/box_manager.dart';
import 'package:to_do_list_project/domain/entity/group.dart';

class GroupFormWidgetModel {
  var groupName = '';

  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;
    final box = await BoxManager.instanse.openGroupsBox();
    final group = Group(name: groupName);
    await box.add(group);
    await BoxManager.instanse.closeBox(box);
    Navigator.of(context).pop();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupFormWidgetModel model;
  const GroupsWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    0;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }
}
