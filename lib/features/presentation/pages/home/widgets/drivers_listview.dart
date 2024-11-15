import 'package:dairy_track_admin/features/data/models/driver_model.dart';
import 'package:dairy_track_admin/features/data/models/store_model.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/widgets/custom_listtile.dart';
import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final List<DriverModel> drivers;
  final List<StoreModel> sellers;
  final bool fromStore;

  const CustomListView({
    super.key,
    this.fromStore = false,
    this.drivers = const [],
    this.sellers = const [],
  });

  @override
  Widget build(BuildContext context) {
    final items = fromStore ? sellers : drivers;
    return items.isEmpty
        ? const Center(child: Text('No data available'))
        : ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return CustomListtile(
                name: fromStore ? (item as StoreModel).name : (item as DriverModel).name,
                id: fromStore ? (item as StoreModel).id : (item as DriverModel).id,
                onPressedDelete: () {},
                onPressedEdit: () {},
              );
            },
          );
  }
}
