import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/app_colors.dart';
import 'package:hair_salon/constants/app_svg_icons.dart';
import 'package:hair_salon/constants/routes_names.dart';
import 'package:hair_salon/view_model/controller/notification_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHomeScreen;
  final String title;
  final RxString? userName;
  final String? greetingTxt;
  final String? imageUrl;
  final bool isLeadingNeed;
  final bool isTrailingAddButton;
  final bool isTrailingCalender;
  final VoidCallback? onAddButtonTap;
  final bool isShowDrawer;
  final RxString? circularAvetartxt;

  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({
    super.key,
    this.circularAvetartxt,
    this.isHomeScreen = false,
    this.title = '',
    this.userName,
    this.greetingTxt,
    this.imageUrl,
    this.isLeadingNeed = false,
    this.isTrailingAddButton = false,
    this.isTrailingCalender = false,
    this.onAddButtonTap,
    this.isShowDrawer = false,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.put(NotificationController());

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: isLeadingNeed
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Get.back();
              
              },
            )
          : isShowDrawer
              ? IconButton(
                  onPressed: () {
                    scaffoldKey?.currentState?.openDrawer();
                  },
                  icon: SvgPicture.asset(AppSvgIcons.menuIcon),
                )
              : null,
      title: isHomeScreen
          ? Row(
              children: [
                Obx((){
              return    CircleAvatar(
                  radius: 27,
                  backgroundColor: AppColors.lightGrey,
                  child: LabelText(
                    text: circularAvetartxt!.value,
                    fontSize: 27,
                    weight: FontWeight.w600,
                    textColor: AppColors.purple,
                  ),
                );
                }),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      text: getGreetingMessage().tr,
                      textColor: AppColors.grey,
                      fontSize: 14,
                      weight: FontWeight.w400,
                    ),
                   Obx((){
                    return  LabelText(
                      text: userName!.value,
                      fontSize: 18,
                      weight: FontWeight.w600,
                    );
                   })
                  ],
                ),
              ],
            )
          : LabelText(
              text: title,
              fontSize: 24,
              weight: FontWeight.w600,
            ),
      centerTitle: isHomeScreen ? false : true,
      actions: [
        isHomeScreen
            ? IconButton(
                icon: Stack(
                  children: [
                    SvgPicture.asset(AppSvgIcons.notificationIcon),
                    Obx(() => notificationController.notificationCount > 0
                        ? Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                notificationController.notificationCount.value
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox()),
                  ],
                ),
                onPressed: () {
                  notificationController.clearNotifications(); // Clear badge
                  Get.toNamed(RouteName.notificationScreen);
                },
              )
            : const SizedBox.shrink(),
        isTrailingAddButton
            ? Row(
                children: [
                  appBarButton(
                    const Icon(Icons.add),
                    onAddButtonTap!,
                  ),
                  const Gap(10),
                ],
              )
            : isTrailingCalender
                ? Row(
                    children: [
                      appBarButton(
                        const Icon(Icons.calendar_month),
                        onAddButtonTap!,
                      ),
                      const Gap(10),
                    ],
                  )
                : const SizedBox.shrink(),
      ],
    );
  }

  Widget appBarButton(Icon icon, VoidCallback onTap) {
    return Transform.scale(
      scaleX: 0.7,
      scaleY: 0.7,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 39,
          width: 39,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.lightGrey,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Transform.scale(
                alignment: isTrailingAddButton
                    ? Alignment.center
                    : isTrailingCalender
                        ? Alignment.center
                        : Alignment.centerLeft,
                scaleX: 1.5,
                scaleY: 1.5,
                child: icon,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "good_morning";
    } else if (hour >= 12 && hour < 17) {
      return "good_afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "good_evening";
    } else {
      return "good_night";
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}