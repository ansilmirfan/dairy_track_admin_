import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:dairy_track_admin/features/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showUserDetails(
    {bool fromStore = false, StoreModel? store, DriverModel? driver}) {
  String name = fromStore ? store!.name : driver!.name;
  String phone = fromStore
      ? store!.phoneNumber.toString()
      : driver!.phoneNumber.toString();
  String route = fromStore ? store!.route : driver!.route;
  String place = fromStore ? store!.place : '';
  String location = fromStore
      ? '(${store!.location.latitude}, ${store.location.longitude})'
      : '';
  String license = fromStore ? '' : driver!.licenceNumber;
  String userName = driver?.userName ?? '';
  String password = driver?.password ?? '';

  Get.dialog(
    AlertDialog(
      title: Text(name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: $name',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Gap(gap: 8),
          Text('Phone: $phone'),
          const Gap(gap: 8),
          Text('Route: $route'),
          const Gap(gap: 8),
          if (fromStore) ...[
            Text('Place: $place'),
            const Gap(gap: 8),
            Text('Location: $location'),
          ] else ...[
            Text('License: $license'),
            const Gap(gap: 8),
            Text('User Name: $userName'),
            const Gap(gap: 8),
            Text('Password: $password'),
            const Gap(gap: 8),
          ]
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
