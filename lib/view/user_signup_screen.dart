import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/utils/utills.dart';

import '../repository/auth_api/firebase_auth_repository.dart';

class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({super.key});

  @override
  State<UserSignUpScreen> createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
  late TextEditingController phoneController, dateController, nameController;
  String? selectedGender;
  final FirebaseAuthRepository authService =
      FirebaseAuthRepository(); // Initialize AuthService

  var isCreatingUser = false.obs; // Flag to show loading state

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    final String phoneNumber = Get.arguments ?? "";
    phoneController = TextEditingController(text: phoneNumber);
    dateController = TextEditingController();
    selectedGender = "Men";
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    dateController.dispose();
  }

  /// Validates the form and creates the user profile
  void validateAndSignUp() async {
    if (nameController.text.isEmpty) {
      Get.snackbar('error'.tr, 'name_empty'.tr);
      return;
    }

    if (selectedGender == null || selectedGender!.isEmpty) {
      Get.snackbar('error'.tr, 'select_gender'.tr);
      return;
    }

    if (dateController.text.isEmpty) {
      Get.snackbar('error'.tr, 'birthday_empty'.tr);
      return;
    }

    // Show loading state
    setState(() {
      isCreatingUser = true.obs;
    });

    try {
      await authService.createUserProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        birthday: dateController.text.trim(),
        gender: selectedGender!,
      );

      // Navigate to home screen after successful creation
      Get.offAllNamed(RouteName.userHomeScreen);
    } catch (error) {
      Get.snackbar('error'.tr, 'failed_to_sign_up'.tr + error.toString());
    } finally {
      // Hide loading state
      setState(() {
        isCreatingUser = false.obs;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  AppImages.logo,
                  width: 220,
                ),
              ),
              const Gap(50),
              LabelText(
                text: "finish_signing_up".tr,
                textColor: AppColors.purple,
                fontSize: AppFontSize.xlarge,
                weight: FontWeight.w600,
              ),
              const Gap(20),
              CustomTextField(
                label: "full_name".tr,
                hint: "john_devy".tr,
                controller: nameController,
              ),
              const Gap(15),

              // Gender Dropdown
              CustomDropdown(
                label: "gender".tr,
                hintText: "gender".tr,
                items: ["Men", "Female", "Other"],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),
              const Gap(15),

              CustomTextField(
                label: "birthday".tr,
                hint: "mm_dd_yyyy".tr,
                controller: dateController,
                readOnly: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month_outlined),
                  onPressed: () {
                    Utills.selectDate(
                      context,
                      dateController,
                    ); // Open date picker
                  },
                ),
              ),
              const Gap(50),

              // GradientButton
              CustomGradientButton(
                text: "continue".tr,
                onTap: validateAndSignUp,
                isLoading: isCreatingUser,
              ),

              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
