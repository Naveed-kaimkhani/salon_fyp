// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';

class UserLogInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool verifyCode = false.obs;
  final FirebaseAuthRepository authService = FirebaseAuthRepository();
  final RxBool isLoading = false.obs;

  UserLogInScreen({super.key});

  /// Validates the form and creates the user profile
  void validateAndSignUp(context) {
    if (emailController.text.isEmpty) {
      Get.snackbar('error'.tr, 'email_empty'.tr);
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'password_empty'.tr);
      return;
    }

    _loginWithEmailPassword(context);
  }

  Future<void> _loginWithEmailPassword(context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    isLoading.value = true;

    if (email.isEmpty || password.isEmpty) {
      isLoading.value = false;
      Get.snackbar("error".tr, 'enter_email_and_password'.tr);
      return;
    }

    try {
      await authService.SignUpUserWithEmailPass(email, password, context);
      isLoading.value = false;

      // if (user != null) {
      //   Get.offAllNamed(RouteName.adminBottomNavBar);
      // }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('error'.tr, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Gap(30),
                // Center(
                //   child: Image.asset(
                //     AppImages.logo,
                //     width: 220,
                //   ),
                // ),
                const Gap(30),
                LabelText(
                  text: "Hi, Signup",
                  textColor: AppColors.purple,
                  fontSize: AppFontSize.xlarge,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                CustomTextField(
                  label: "Enter Email".tr,
                  hint: "xyz@gmail.com",
                  controller: emailController,
                ),
                const Gap(15),
                const Gap(10),
                CustomTextField(
                  label: "Enter Password".tr,
                  hint: "******",
                  controller: passwordController,
                  obscureText: true,
                ),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: TextButton(
                //     onPressed: () {
                //       Get.toNamed(RouteName.adminLoginScreen);
                //     },
                //     child: Text(
                //       "login_as_owner".tr,
                //       style: const TextStyle(color: AppColors.purple),
                //     ),
                //   ),
                // ),
                const Gap(20),
                Obx(() {
                  return CustomGradientButton(
                    text: "continue".tr,
                    isLoading: isLoading.value.obs,
                    onTap: () => validateAndSignUp(context),
                  );
                }),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
