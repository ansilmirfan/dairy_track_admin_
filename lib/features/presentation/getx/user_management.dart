import 'dart:developer';

import 'package:dairy_track_admin/features/data/data_source/firebase/data_source.dart';
import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';

import 'package:get/get.dart';

class UserManagementController extends GetxController {
  var loading = false.obs;
  var success = false.obs;
  //-------create user-------------
  void createUser(
      {DriverModel? driverModel,
      StoreModel? storeModel,
      bool driver = true}) async {
    try {
      if (driver) {
        updateLoading();
        await DataSource().create('drivers', DriverModel.toMap(driverModel!));
        updateLoading(status: false);

        Get.back();
      } else {
        updateLoading();
        await DataSource().create('sellers', StoreModel.toMap(storeModel!));
        updateLoading(status: false);
        success.value = true;
      }
    } catch (e) {
      log('error while adding to firebase:$e');
      updateLoading(status: false);
      success.value = false;
    }
  }

  //-------uodate user-------------
  void updateUser() {}
  //-------delete user------------
  void deleteUser() {}
  //----get all users-----------
  void getAllUser() {}
  updateLoading({bool status = true}) {
    loading.value = status;
  }
}
