import 'dart:developer';

import 'package:dairy_track_admin/features/data/data_source/firebase/data_source.dart';
import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';

import 'package:get/get.dart';

class UserManagementController extends GetxController {
  final DataSource _dataSource = DataSource();
  var loading = false.obs;
  var success = false.obs;
  var driversList = <DriverModel>[].obs;
  var shopsModel = <ShopModel>[].obs;
  //-----getting all the data from firebase using stream to listen------------
  UserManagementController() {
    _dataSource.featchAll('drivers').listen((data) {
      driversList.value = data.map((e) => DriverModel.fromMap(e)).toList();
    });
    _dataSource.featchAll('sellers').listen((data) {
      shopsModel.value = data.map((e) => ShopModel.fromMap(e)).toList();
      log('this much data is available in${data.length} ');
    });
  }
  //-------create user-------------
  void createUser(
      {DriverModel? driverModel,
      ShopModel? storeModel,
      bool driver = true}) async {
    try {
      if (driver) {
        updateLoading();
        final id = await _dataSource.create(
            'drivers', DriverModel.toMap(driverModel!));
        if (id != null) {
          await _dataSource.create('deliveries', {'reference': []}, id);
        }

        updateLoading(status: false);

        Get.back();
      } else {
        updateLoading();
        await _dataSource.create('sellers', ShopModel.toMap(storeModel!));
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
  deleteUser(String id, String collection) async {
    updateLoading();
    await _dataSource.delete(id, collection);
    updateLoading(status: false);
  }

  //----get all users-----------
  void getAllDrivers() {}
//----------updating loading---------
  updateLoading({bool status = true}) {
    loading.value = status;
  }
}
