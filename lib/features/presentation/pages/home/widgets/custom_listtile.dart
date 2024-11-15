import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  final String name;
  final String id;
  final void Function()? onPressedEdit;
  final void Function()? onPressedDelete;
  const CustomListtile(
      {super.key,
      required this.name,
      required this.id,
      required this.onPressedDelete,
      required this.onPressedEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _circleAvathar(),
      title: Text(name),
      subtitle: Text(id),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onPressedEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onPressedDelete,
          ),
        ],
      ),
    );
  }

  CircleAvatar _circleAvathar() {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      child: Text(
        name[0].toUpperCase(),
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
