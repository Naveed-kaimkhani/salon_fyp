import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/repository/auth_api/auth_api.dart';
import 'package:hair_salon/view/view.dart';
import 'package:hair_salon/view/waiting_list_screen.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class BottomNavigationBarComponent extends StatelessWidget {
  BottomNavigationBarComponent({super.key});

  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  // List of screens corresponding to each tab
  final List<Widget> _screens = [
    UserHomeScreen(),
    AppointmentScreen(),
    WaitingListScreen(),
    UserProfileScreen(authRepository: Get.find<AuthRepository>()),
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
              icon: SvgPicture.asset(AppSvgIcons.calendarOutlined),
              activeIcon: SvgPicture.asset(AppSvgIcons.calendarFilled),
              label: 'bookings'.tr,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppSvgIcons.noteBookOutlined),
              activeIcon: SvgPicture.asset(AppSvgIcons.noteBookFilled),
              label: 'waiting_list'.tr,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppSvgIcons.personOutlined),
              activeIcon: SvgPicture.asset(AppSvgIcons.personFilled),
              label: 'profile'.tr,
            ),
          ],
        ),
      ),
    );
  }

  /// this should be called above and use it as component for admin side too
  BottomNavigationBarItem buildBottomNavigationBarItem({
    required String svgIcon,
    required String filledSvgIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(svgIcon),
      activeIcon: SvgPicture.asset(filledSvgIcon),
      label: label,
    );
  }
}
