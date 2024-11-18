// ignore_for_file: invalid_use_of_protected_member

import 'package:dairy_track_admin/core/utils/utils.dart';
import 'package:dairy_track_admin/core/validations/validations.dart';
import 'package:dairy_track_admin/features/data/models/delivery_model.dart';
import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/presentation/getx/delivery_management.dart';
import 'package:dairy_track_admin/features/presentation/getx/user_management.dart';
import 'package:dairy_track_admin/features/presentation/pages/driver%20details/delivery_details.dart';

import 'package:dairy_track_admin/features/presentation/themes/themes.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_text_button.dart';
import 'package:dairy_track_admin/features/presentation/widgets/custom_textformfiled.dart';
import 'package:dairy_track_admin/features/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverDetailsPage extends StatefulWidget {
  final DriverModel driver;

  const DriverDetailsPage({super.key, required this.driver});

  @override
  State<DriverDetailsPage> createState() => _DriverDetailsPageState();
}

class _DriverDetailsPageState extends State<DriverDetailsPage> {
  final DeliveryManagementController deliveryManagementController =
      Get.put(DeliveryManagementController());
  final UserManagementController userManagementController =
      Get.put(UserManagementController());
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    deliveryManagementController.checkQuantityUpdated(widget.driver.id);
    deliveryManagementController.getAllOrders(widget.driver.id);
    controller.text = '250';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          deliveryManagementController.checkQuantityUpdated(widget.driver.id);
          deliveryManagementController.getAllOrders(widget.driver.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ..._driversDetailsForm,
              const Gap(),
              _stockQuantityInputRow(),
              const Gap(),
              _totalDeliveries()
            ],
          ),
        ),
      ),
    );
  }

  Obx _totalDeliveries() {
    return Obx(
      () {
        if (deliveryManagementController.loading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<DeliveryModel> data =
              deliveryManagementController.deliveries.value;
          return Column(
            children: List.generate(
              data.length,
              (index) => Card(
                child: ListTile(
                  onTap: () {
                    Get.to(() => DeliveryDetailsPage(delivery: data[index]));
                  },
                  title: Text(Utils.formatDate(data[index].date)),
                  subtitle: Text(data[index].route),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Obx _stockQuantityInputRow() {
    return Obx(
      () {
        if (deliveryManagementController.isQuantityUpdated.value) {
          return const SizedBox.shrink();
        }
        return Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: controller,
                labelText: 'Stock Quantity in L',
                keyboardType: TextInputType.number,
                validator: Validations.validateNumber,
              ),
            ),
            Gap.width(gap: 10),
            deliveryManagementController.loading.value
                ? Expanded(child: CustomTextButton(progress: true))
                : Expanded(
                    child: CustomTextButton(
                    text: 'Submit',
                    onPressed: () {
                      final DeliveryModel model = DeliveryModel(
                          id: '',
                          driver: widget.driver,
                          date: DateTime.now(),
                          route: widget.driver.route,
                          initialStock: double.parse(controller.text.trim()),
                          remainingStock: double.parse(controller.text.trim()),
                          shops: userManagementController.shopsModel.value
                              .where((e) => e.route == widget.driver.route)
                              .map((e) => ShopDeliveryModel(shopModel: e))
                              .toList());
                      deliveryManagementController.createTodaysOrder(model);
                    },
                  ))
          ],
        );
      },
    );
  }

  List<Widget> get _driversDetailsForm {
    return [
      Text(
        widget.driver.name,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      const Gap(gap: 16),
      _buildInfoRow('Name:', widget.driver.name),
      _buildInfoRow('Phone Number:', widget.driver.phoneNumber.toString()),
      _buildInfoRow('License Number:', widget.driver.licenceNumber),
      _buildInfoRow('Route:', widget.driver.route),
      _buildInfoRow('User name:', widget.driver.name),
      _buildInfoRow('password:', widget.driver.password.toString()),
    ];
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Themes.primary,
      foregroundColor: Themes.secondary,
      centerTitle: true,
      title: const Text('Driver Details'),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
