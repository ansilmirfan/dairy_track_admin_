import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/widgets/delete_alert_dialog.dart';
import 'package:dairy_track_admin/features/presentation/pages/driver%20details/detaild_view_shop.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/widgets/detailed_view_driver.dart';
import 'package:dairy_track_admin/features/presentation/pages/user_management/edit_user_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        fromStore ? (item as ShopModel).name : (item as DriverModel).name;
    final route =
        fromStore ? (item as ShopModel).route : (item as DriverModel).route;
    final String id =
        fromStore ? (item as ShopModel).id : (item as DriverModel).id;

    return ListTile(
      leading: _circleAvathar(),
      title: Text(name),
      subtitle: Text(route),
      onTap: () {
        if (fromStore) {
          showStoreDetails(store: item as ShopModel);
        } else {
          Get.to(DriverDetailsPage(
            driver: item,
          ));
        }
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditUserPage(
                    drivers: !fromStore,
                    driverModel: fromStore ? null : item,
                    shopModel: fromStore ? item : null,
                  ));
            },
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
        (fromStore ? (item as ShopModel).name : (item as DriverModel).name)[0]
            .toUpperCase(),
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
