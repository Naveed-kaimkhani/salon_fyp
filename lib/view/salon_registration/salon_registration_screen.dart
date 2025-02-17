import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/salon/salon_model.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';
import 'package:hair_salon/utils/utills.dart';

class SalonRegistrationScreen extends StatefulWidget {
  const SalonRegistrationScreen({super.key});

  @override
  State<SalonRegistrationScreen> createState() =>
      _SalonRegistrationScreenState();
}

class _SalonRegistrationScreenState extends State<SalonRegistrationScreen> {
  late TextEditingController phoneController,
      businessNameController,
      ownerNameController,
      emailController,
      passwordController,
      confirmPasswordController;

  final FirebaseAuthRepository authService =
      FirebaseAuthRepository(); // Initialize AuthService

  var isCreatingUser = false.obs; // Flag to show loading state

  @override
  void initState() {
    super.initState();
    businessNameController = TextEditingController();
    ownerNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    businessNameController.dispose();
    ownerNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  /// Validates the form and creates the user profile
  void validateAndSignUp() {
    //validate all other fields
    if (businessNameController.text.isEmpty) {
      Get.snackbar('error'.tr, 'business_name_empty'.tr);
      return;
    }
    if (ownerNameController.text.isEmpty) {
      Get.snackbar('error'.tr, 'owner_name_empty'.tr);
      return;
    }
    if (emailController.text.isEmpty) {
      Get.snackbar('error'.tr, 'email_empty'.tr);
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'password_empty'.tr);
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'confirm_password_empty'.tr);
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('error'.tr, 'password_mismatch'.tr);
      return;
    }

    // Show loading state
    setState(() {
      isCreatingUser = true.obs;
    });

    try {
      Salon salon = Salon(
        phoneNumber: phoneController.text.trim(),
        businessName: businessNameController.text.trim(),
        ownerName: ownerNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        confirmPassword: confirmPasswordController.text.trim(),
      );

      // Navigate to home screen after successful creation
      Get.toNamed(RouteName.bussinessDetails, arguments: salon);
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
                label: "Business Name".tr,
                hint: "Sunita Salon".tr,
                controller: businessNameController,
              ),

              const Gap(15),

              CustomTextField(
                label: "Owner’s Name".tr,
                hint: "Sunita".tr,
                controller: ownerNameController,
              ),

              const Gap(15),

              CustomTextField(
                label: "Phone Number".tr,
                hint: "03103443527".tr,
                controller: phoneController,
              ),

              const Gap(15),
              CustomTextField(
                label: "Email".tr,
                hint: "xyz@gmail.com".tr,
                controller: emailController,
              ),
              const Gap(15),
              CustomTextField(
                label: "Password".tr,
                hint: "******".tr,
                controller: passwordController,
              ),

              const Gap(15),
              CustomTextField(
                label: "Confirm Password".tr,
                hint: "******".tr,
                controller: confirmPasswordController,
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
