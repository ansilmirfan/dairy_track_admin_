import 'package:dairy_track_admin/features/presentation/pages/user_management/user_management.dart';
import 'package:dairy_track_admin/features/presentation/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appBar(),
        body: const TabBarView(
          children: [
            Center(child: Text("Drivers Content")),
            Center(child: Text("Shops Content")),
          ],
        ),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Themes.primary,
      foregroundColor: Themes.secondary,
      shape: const CircleBorder(),
      onPressed: () {
        Get.to(const UserManagement());
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
