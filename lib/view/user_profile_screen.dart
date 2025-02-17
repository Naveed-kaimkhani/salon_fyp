import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/localization/translation_service.dart';
import 'package:hair_salon/repository/auth_api/auth_api.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';
import 'package:hair_salon/view/delete_account_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final AuthRepository authRepository;

  const UserProfileScreen({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Ensure that the user is logged in
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text('please_log_in'.tr),
        ),
      );
    }

    // Fetch user data from Firestore
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    return Scaffold(
      appBar: CustomAppBar(
        title: "user_profile".tr,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userDocRef.snapshots(), // Use Firestore's real-time stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("error_loading_profile".tr));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("no_profile_found".tr));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String name = userData['name'] ?? "name_not_found".tr;
          String phone = userData['phone'] ?? "phone_not_found".tr;
          String avatarText =
              name.isNotEmpty ? name.substring(0, 2).toUpperCase() : "NA";

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                UserProfileComponent(
                  circularAvetartxt: avatarText,
                  userName: name,
                  number: phone,
                  onButtonTap: () => Get.toNamed(RouteName.editProfileScreen),
                ),
                const Gap(20),
                ProfileOptionComponent(
                  label: "my_appointments".tr,
                  onTap: () {
                    Get.toNamed(RouteName.appointmentScreen);
                  },
                  svgIcon: AppSvgIcons.calenderIcon,
                ),
                ProfileOptionComponent(
                  label: "notifications".tr,
                  onTap: () {
                    Get.toNamed(RouteName.notificationScreen);
                  },
                  svgIcon: AppSvgIcons.notificationIcon,
                ),
                ProfileOptionComponent(
                  label: "change_language".tr,
                  onTap: () async {
                    await TranslationService.changeLocale();
                  },
                  svgIcon: AppSvgIcons.languageIcon,
                ),
                ProfileOptionComponent(
                  svgIcon: AppSvgIcons.deleteIcon,
                  label: "delete_account".tr,
                  onTap: () {
                    // Navigate to Delete Account Screen
                    Get.to(() => const DeleteAccountScreen());
                  },
                ),
                ProfileOptionComponent(
                  svgIcon: AppSvgIcons.logOutIcon,
                  label: "logout".tr,
                  onTap: () async {
                    log("log out tap");
                    await FirebaseAuthRepository().signOut();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
