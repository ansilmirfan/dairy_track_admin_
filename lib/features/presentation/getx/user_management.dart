import 'dart:developer';
import 'package:dairy_track_admin/features/data/data_source/firebase/data_source.dart';
import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:get/get.dart';

class UserManagementController extends GetxController {
  final DataSource _dataSource = DataSource();
  var loading = false.obs;
 
  var driversList = <DriverModel>[].obs;
  var shopsModel = <ShopModel>[].obs;

  UserManagementController() {
    _dataSource.featchAll('drivers').listen((data) {
      driversList.value = data.map((e) => DriverModel.fromMap(e)).toList();
    });
    _dataSource.featchAll('sellers').listen((data) {
      shopsModel.value = data.map((e) => ShopModel.fromMap(e)).toList();
      log('this much data is available in${data.length} ');
    });
  }

  void createUser(
      {DriverModel? driverModel,
      ShopModel? storeModel,
      bool driver = true}) async {
    try {

      updateLoading();
      if (driver) {
        final id = await _dataSource.create(
            'drivers', DriverModel.toMap(driverModel!));
        if (id != null) {
          await _dataSource.create('deliveries', {'reference': []}, id);
        }
      } else {
        await _dataSource.create('sellers', ShopModel.toMap(storeModel!));
      }

      updateLoading(status: false);

      Get.back();
    } catch (e) {
      log('error while adding to firebase:$e');
      updateLoading(status: false);
  
    }
  }

  void updateUser(
      {DriverModel? driverModel,
      ShopModel? storeModel,
      bool driver = true}) async {
    updateLoading();

    try {
      if (driver) {
        await _dataSource.edit(
            driverModel!.id, 'drivers', DriverModel.toMap(driverModel));
      } else {
        await _dataSource.edit(
            storeModel!.id, 'sellers', ShopModel.toMap(storeModel));
      }

      updateLoading(status: false);

      Get.back();
    } catch (e) {
      log('error while adding to firebase:$e');
      updateLoading(status: false);

    }
  }

  deleteUser(String id, String collection) async {
    updateLoading();
    await _dataSource.delete(id, collection);
    updateLoading(status: false);
  }

  updateLoading({bool status = true}) {
    loading.value = status;
  }
}
