// ignore_for_file: invalid_use_of_protected_member

import 'package:dairy_track_admin/features/presentation/getx/user_management.dart';
import 'package:dairy_track_admin/features/presentation/pages/home/widgets/custom_listview.dart';
import 'package:dairy_track_admin/features/presentation/pages/user_management/user_management.dart';
import 'package:dairy_track_admin/features/presentation/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final UserManagementController userManagementController =
      Get.put(UserManagementController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: TabBarView(
          children: [
            Obx(
              () => CustomListView(
                drivers: userManagementController.driversList.value,
              ),
            ),
            Obx(() => CustomListView(
                  sellers: userManagementController.shopsModel.value,
                  fromStore: true,
                )),
          ],
        ),
        floatingActionButton: _floatingActionButton(context),
      ),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Themes.primary,
      foregroundColor: Themes.secondary,
      shape: const CircleBorder(),
      onPressed: () {
        Get.to(() => const UserManagement());
      },
      child: const Icon(Icons.add),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Home'),
      centerTitle: true,
      backgroundColor: Themes.primary,
      foregroundColor: Themes.secondary,
      bottom: TabBar(
        tabs: [
          _tabBarItem('Drivers'),
          _tabBarItem('Shops'),
        ],
        indicator: BoxDecoration(
          color: Themes.secondary,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Themes.primary,
        unselectedLabelColor: Themes.secondary,
      ),
    );
  }

  Padding _tabBarItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(text),
    );
  }
}
