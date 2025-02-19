import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/salon/salon_model.dart';
import 'package:hair_salon/repository/auth_api/auth_api.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view/salon_registration/pending_approval_screen.dart';

class LoginSalon extends StatefulWidget {
  const LoginSalon({super.key});

  @override
  State<LoginSalon> createState() => _LoginSalonState();
}

class _LoginSalonState extends State<LoginSalon> {
  late TextEditingController phoneController,
      businessNameController,
      ownerNameController,
      emailController,
      passwordController,
      confirmPasswordController;

  final FirebaseAuthRepository authService =
      FirebaseAuthRepository(); // Initialize AuthService

  var isCreatingUser = false.obs; // Flag to show loading state
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
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
  void validateAndSignUp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('error'.tr, 'email_empty'.tr);
      return;
    }
    if (!emailRegex.hasMatch(emailController.text)) {
      Get.snackbar('error'.tr, 'invalid_email'.tr);
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'password_empty'.tr);
      return;
    }
    isCreatingUser.value = true;
    FirebaseAuthRepository auth = FirebaseAuthRepository();
    // Navigate to home screen after successful creation
    User? user = await auth.loginWithEmailPass(
        emailController.text, passwordController.text, context);
    // Get.toNamed(RouteName., arguments: salon);
    if (user != null) {
      isCreatingUser.value = false;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PendingApprovalScreen()),
      );
      // Get.offAllNamed(RouteName.adminBottomNavBar);
    } else {
      isCreatingUser.value = false;
      Get.snackbar('error'.tr, 'failed_to_sign_up'.tr);
    }
    // try {
    // } catch (error) {
    //   Get.snackbar('error'.tr, 'failed_to_sign_up'.tr + error.toString());
    // } finally {
    //   // Hide loading state
    //   setState(() {
    //     isCreatingUser = false.obs;
    //   });
    // }
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
                text: "Welcome Back".tr,
                textColor: AppColors.purple,
                fontSize: AppFontSize.xlarge,
                weight: FontWeight.w600,
              ),
              const Gap(20),
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

              const Gap(50),

              // GradientButton
              CustomGradientButton(
                text: "Login".tr,
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
