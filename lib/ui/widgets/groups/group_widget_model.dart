import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list_project/domain/entity/group.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_list_project/ui/navigation/main_navigation.dart';
import 'package:to_do_list_project/ui/widgets/tasks/tasks_widget.dart';

import '../../../domain/entity/data_provider/box_manager.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _box;
  ValueListenable<Object>? _listenableBox;
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _box).getAt(groupIndex);
    if (group != null) {
      final configuration = TaskWidgetConfiguration(
        group.key as int,
        group.name,
      );

      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: configuration,
      );
    }
  }

  Future<void> _readGroupsFromHive() async {
    _groups = (await _box).values.toList();
    notifyListeners();
  }

  Future<void> deleteGroup(int groupIndex) async {
    final box = await _box;
    final groupKey = (await _box).keyAt(groupIndex) as int;
    final taskBoxName = BoxManager.instanse.makeTaskBoxName(groupKey);
    await Hive.deleteBoxFromDisk(taskBoxName);
    box.deleteAt(groupIndex);
  }

  void _setup() async {
    _box = BoxManager.instanse.openGroupsBox();
    await _readGroupsFromHive();
    _listenableBox = (await _box).listenable();
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instanse.closeBox((await _box));
    super.dispose();
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;
  const GroupsWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
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
