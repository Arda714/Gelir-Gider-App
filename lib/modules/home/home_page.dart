import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:gelir_gider_app/modules/dashboard/dashboard_page.dart';
import 'package:gelir_gider_app/profile/profile_page.dart';
import 'package:gelir_gider_app/themes/app_colors.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pariva"),
      ),

      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            DashboardPage(),
            ProfilePage(),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToTransaction,
        backgroundColor: AppColors.hotPinkAccent,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add_rounded,
          size: 32,
          color: Colors.white,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          gapLocation: GapLocation.center,
          backgroundColor: AppColors.primaryLight,
          icons: const [
            Icons.dashboard_outlined,
            Icons.person,
          ],
          activeIndex: controller.currentIndex.value,
          splashColor: Colors.white,
          activeColor: Colors.white,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          inactiveColor: Colors.white54,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
