// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';

import 'package:dairy_track_admin/features/data/data_source/firebase/data_source.dart';
import 'package:dairy_track_admin/features/data/models/delivery_model.dart';
import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:dairy_track_admin/features/presentation/getx/user_management.dart';
import 'package:get/get.dart';

class DeliveryManagementController extends GetxController {
  final UserManagementController userManagementController =
      Get.put(UserManagementController());
  final DataSource _dataSource = DataSource();
  final deliveries = <DeliveryModel>[].obs;
  var loading = false.obs;
  var isQuantityUpdated = false.obs;

  //---------checking quantity is already updated or not----------
  void checkQuantityUpdated(String id) async {
    isQuantityUpdated.value = await _dataSource.checkQuantityUpdated(id);
  }

//------------getting all delivery orders of a specific driver-------------------
  void getAllOrders(String id) async {
    loading.value = true;

    try {
      final map = await _dataSource.getOne('deliveries', id);

      List<String> referenceList = List<String>.from(map['reference'] ?? []);

      List<DeliveryModel> data = await Future.wait(referenceList.map((e) async {
        final map = await _dataSource.getOne('delivery datasource', e);
        final driverMap = await _dataSource.getOne('drivers', id);
        final List<ShopDeliveryModel> shopDeliveryModel = [];
        final List<Map> shops = List<Map>.from(map['shops'] ?? []);
        //------------converting shops from firebase to shodeliverymodel-------------
        for (var element in shops) {
          ShopModel model = userManagementController.shopsModel.value
              .firstWhere((e) => e.id == element['shop id']);
          shopDeliveryModel.add(ShopDeliveryModel(
              shopModel: model,
              deliveredQuantity: element['delivered quantity'],
              status: element['status']));
        }

        return DeliveryModel.fromMap(
            driverModel: DriverModel.fromMap(driverMap),
            map: map,
            shops: shopDeliveryModel);
      }));
      deliveries.value = data;
      loading.value = false;
    } catch (e) {
      log(e.toString());
      loading.value = false;
    }
  }

  //-----------create todays order-------------------------
  void createTodaysOrder(DeliveryModel model) async {
    loading.value = true;
    final id = await _dataSource.create(
        'delivery datasource', DeliveryModel.toMap(model));
    if (id != null) {
      final map = await _dataSource.getOne('deliveries', model.driver.id);
      final List<String> referenece = List<String>.from(map['reference'] ?? []);
      referenece.add(id);
      _dataSource
          .edit(model.driver.id, 'deliveries', {'reference': referenece});
      loading.value = false;
    }
    loading.value = false;
    checkQuantityUpdated(model.driver.id);
  }
}
