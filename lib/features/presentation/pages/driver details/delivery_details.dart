import 'package:dairy_track_admin/core/utils/utils.dart';
import 'package:dairy_track_admin/features/presentation/widgets/gap.dart';
import 'package:flutter/material.dart';
import 'package:dairy_track_admin/features/data/models/delivery_model.dart';

class DeliveryDetailsPage extends StatelessWidget {
  final DeliveryModel delivery;

  const DeliveryDetailsPage({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delivery ID: ${delivery.id}'),
            const Gap(gap: 5),
            Text('Driver: ${delivery.driver.name}'),
            const Gap(gap: 5),
            Text('Route: ${delivery.route}'),
            const Gap(gap: 5),
            Text('Date :${Utils.formatDate(delivery.date)}'),
            const Gap(gap: 5),
            Text('Initial Stock: ${delivery.initialStock} L'),
            Text('Delivered Stock: ${delivery.deliveredStock} L'),
            Text('Remaining Stock: ${delivery.remainingStock} L'),
            const Gap(gap: 20),
            const Text('Shops:', style: TextStyle(fontWeight: FontWeight.bold)),
            const Gap(gap: 10),
            Expanded(
              child: ListView.builder(
                itemCount: delivery.shops.length,
                itemBuilder: (context, index) {
                  var shop = delivery.shops[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(shop.shopModel.name),
                      subtitle: Text('Delivered: ${shop.deliveredQuantity} L'),
                      trailing: Text(shop.status),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
