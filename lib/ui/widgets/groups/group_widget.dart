import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:to_do_list_project/ui/widgets/groups/group_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();
  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupsWidgetBody(),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Groups'),
        ),
        body: const _GroupsListWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              GroupsWidgetModelProvider.read(context)?.model.showForm(context),
          child: const Icon(Icons.add),
        ));
  }
}

class _GroupsListWidget extends StatelessWidget {
  const _GroupsListWidget();

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupsWidgetModelProvider.watch(context)?.model.groups.length ?? 0;
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return _GroupsListRowWidget(
            indexInList: index,
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 1,
          );
        },
        itemCount: groupsCount);
  }
}

class _GroupsListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupsListRowWidget({required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModel();
    final group =
        GroupsWidgetModelProvider.read(context)!.model.groups[indexInList];
    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) => model.deleteGroup(indexInList),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(group.name),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: () => model.showTasks(context, indexInList),
      ),
    );
  }
}
