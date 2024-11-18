// ignore_for_file: must_be_immutable

import 'package:dairy_track_admin/core/utils/utils.dart';
import 'package:dairy_track_admin/features/presentation/getx/delivery_management.dart';
import 'package:dairy_track_admin/features/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:dairy_track_admin/features/data/models/delivery_model.dart';
import 'package:get/get.dart';

class DeliveryDetailsPage extends StatefulWidget {
   DeliveryModel delivery;

   DeliveryDetailsPage({super.key, required this.delivery});

  @override
  State<DeliveryDetailsPage> createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  final DeliveryManagementController controller =
      Get.put(DeliveryManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final data = await controller.getDeliveryModel(
              widget.delivery.id, widget.delivery.driver.id);
          setState(() {
            widget.delivery = data;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery ID: ${widget.delivery.id}'),
              const Gap(gap: 5),
              Text('Driver: ${widget.delivery.driver.name}'),
              const Gap(gap: 5),
              Text('Route: ${widget.delivery.route}'),
              const Gap(gap: 5),
              Text('Date :${Utils.formatDate(widget.delivery.date)}'),
              const Gap(gap: 5),
              Text('Initial Stock: ${widget.delivery.initialStock} L'),
              Text('Delivered Stock: ${widget.delivery.deliveredStock} L'),
              Text('Remaining Stock: ${widget.delivery.remainingStock} L'),
              const Gap(gap: 20),
              const Text('Shops:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Gap(gap: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.delivery.shops.length,
                  itemBuilder: (context, index) {
                    var shop = widget.delivery.shops[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(shop.shopModel.name),
                        subtitle: shop.dateTime == null
                            ? const Text('')
                            : Text(Utils.formatDate(shop.dateTime!)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(shop.status),
                            Text('Delivered:${shop.deliveredQuantity} L')
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
