import 'package:dairy_track_admin/features/presentation/getx/user_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDeleteConfirmationDialog(
    {required String id, bool fromStore = false}) {
  final UserManagementController userManagementController =
      Get.put(UserManagementController());
  Get.dialog(
    AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text('Do you want to delete this item?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        Obx(() {
          if (userManagementController.loading.value) {
            return const TextButton(
                onPressed: null, child: CircularProgressIndicator());
          } else {
            return TextButton(
              onPressed: () async {
                await userManagementController.deleteUser(
                    id, fromStore ? 'sellers' : 'drivers');
                Get.back();
              },
              child: const Text('Delete'),
            );
          }
        }),
      ],
    ),
  );
}
