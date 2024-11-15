import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/widgets/delete_alert_dialog.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/widgets/detaild_view.dart';
import 'package:flutter/material.dart';

class CustomListtile extends StatelessWidget {
  final bool fromStore;
  final dynamic item;
  const CustomListtile({
    super.key,
    required this.fromStore,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final name =
        fromStore ? (item as StoreModel).name : (item as DriverModel).name;
    final route =
        fromStore ? (item as StoreModel).route : (item as DriverModel).route;
    final String id =
        fromStore ? (item as StoreModel).id : (item as DriverModel).id;

    return ListTile(
      leading: _circleAvathar(),
      title: Text(name),
      subtitle: Text(route),
      onTap: () {
        if (fromStore) {
          showUserDetails(fromStore: true, store: item as StoreModel);
        } else {
          showUserDetails(driver: item as DriverModel);
        }
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDeleteConfirmationDialog(id: id, fromStore: fromStore);
            },
          ),
        ],
      ),
    );
  }

  CircleAvatar _circleAvathar() {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      child: Text(
        (fromStore ? (item as StoreModel).name : (item as DriverModel).name)[0]
            .toUpperCase(),
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
