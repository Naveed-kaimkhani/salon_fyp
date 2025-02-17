import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/index.dart';
import 'package:hair_salon/view/admin/admin.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class AdminBottomNavBar extends StatelessWidget {
  AdminBottomNavBar({super.key});

  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  // List of screens corresponding to each tab
  final List<Widget> _screens = [
    AdminHomeScreen(),
    ManageServicesScreen(),
    const StaffManagementScreen(),
    WorkHoursScreen(),
    // BlockDatesScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[bottomNavController.selectedBottomNav.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: bottomNavController.selectedBottomNav.value,
          onTap: bottomNavController.changeBottomNav,
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.purple,
          unselectedItemColor: AppColors.black,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppSvgIcons.homeOutlined),
              activeIcon: SvgPicture.asset(AppSvgIcons.homeFilled),
              label: 'home'.tr,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppSvgIcons.hairDryerOutlined),
              activeIcon: SvgPicture.asset(AppSvgIcons.hairDryerFilled),
              label: 'services'.tr,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppSvgIcons.userGroupOutlined),
              activeIcon: SvgPicture.asset(AppSvgIcons.userGroupFilled),
              label: 'manage_staff'.tr,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppSvgIcons.colockOutlined),
              activeIcon: SvgPicture.asset(AppSvgIcons.clockFilled),
              label: 'work_hours'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
