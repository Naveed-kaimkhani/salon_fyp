import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const LabelText(
              text: 'Shlomi Stav',
              fontSize: AppFontSize.medium,
              weight: FontWeight.w600,
              textColor: AppColors.white,
            ),
            accountEmail: LabelText(
              text: user?.email ?? 'shlomistav@gmail.com',
              fontSize: AppFontSize.small,
              weight: FontWeight.w400,
              textColor: AppColors.white,
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                border: Border.all(
                  color: AppColors.purple,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: LabelText(
                  text: _getInitials(user?.displayName ?? "Shlomi Stav"),
                  fontSize: AppFontSize.large,
                  weight: FontWeight.w700,
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AppImages.drawerBackgroundImage,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.lightGrey,
                ),
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      drawerItemsTile(
                        title: "manage_services".tr,
                        iconData: AppSvgIcons.hairDryerIcon,
                        onTap: () {
                          Get.toNamed(RouteName.manageServicesScreen);
                        },
                      ),
                      drawerItemsTile(
                        title: "image_management".tr,
                        iconData: AppSvgIcons.albumIcon,
                        onTap: () {
                          Get.toNamed(RouteName.imageManagementScreen);
                        },
                      ),
                      drawerItemsTile(
                        title: "notifications".tr,
                        iconData: AppSvgIcons.notification,
                        onTap: () {
                          Get.toNamed(RouteName.pushNotificationScreen);
                        },
                      ),
                      drawerItemsTile(
                        title: "change_language".tr,
                        iconData: AppSvgIcons.languageIcon,
                        onTap: () async {
                          await TranslationService.changeLocale();
                        },
                      ),
                      drawerItemsTile(
                        title: "logout".tr,
                        iconData:
                            AppSvgIcons.logOutIcon, // Add an appropriate icon
                        isLastItem: true,
                        onTap: _logout,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _logout() async {
    // Implement your logout logic here
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAdminAuthenticated', false);
    await FirebaseAuth.instance.signOut();
    // Clear user session or token
    // Navigate to login screen
    Get.offAllNamed(RouteName.splashScreen);
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      return nameParts
          .map((part) => part.isNotEmpty ? part[0].toUpperCase() : '')
          .take(2)
          .join();
    }
  }

  Widget drawerItemsTile({
    required String title,
    final isLastItem = false,
    required String iconData,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13),
            child: Row(
              children: [
                SvgPicture.asset(iconData,
                    colorFilter:
                        ColorFilter.mode(AppColors.purple, BlendMode.srcIn)),
                const Gap(10),
                LabelText(
                  text: title,
                  fontSize: AppFontSize.small,
                  weight: FontWeight.w400,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.mediumGrey,
                ),
              ],
            ),
          ),
          isLastItem
              ? const SizedBox.shrink()
              : const Divider(
                  height: 0,
                )
        ],
      ),
    );
  }
}
