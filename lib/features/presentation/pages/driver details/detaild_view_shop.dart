import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:dairy_track_admin/features/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showStoreDetails({required ShopModel store}) {
  String name = store.name;
  String phone = store.phoneNumber.toString();
  String route = store.route;
  String place = store.place;
  String location = '(${store.location.latitude}, ${store.location.longitude})';

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
          Text('Place: $place'),
          const Gap(gap: 8),
          Text('Location: $location'),
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
