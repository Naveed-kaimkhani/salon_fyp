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
  final isVerifying = false.obs;
/// Validates the form and creates the user profile
  void validateAndSignUp() {
    //validate all other fields
  
    if (emailController.text.isEmpty) {
      Get.snackbar('error'.tr, 'email_empty'.tr);
      return;
    }
    if (passwordController.text.isEmpty) {
      Get.snackbar('error'.tr, 'password_empty'.tr);
      return;
    }

      _loginWithEmailPassword();

      // Navigate to home screen after successful creation

  }
  Future<void> _loginWithEmailPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    isLoading.value = true;

    if (email.isEmpty || password.isEmpty) {
      isLoading.value = false;
      Get.snackbar("error".tr, 'enter_email_and_password'.tr);
      return;
    }

    final user = await authRepository
        .loginWithEmailPass(email, password, context);
    isLoading.value = false;

    if (user != null) {
      Get.offAllNamed(RouteName.adminBottomNavBar);
    } else {
      isLoading.value = false;
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(30),
                Center(
                  child: Image.asset(
                    AppImages.logo,
                    width: 220,
                  ),
                ),
                const Gap(30),
                LabelText(
                  text: "welcome".tr,
                  textColor: AppColors.purple,
                  fontSize: AppFontSize.xlarge,
                  weight: FontWeight.w600,
                ),
                const Gap(20),
                CustomTextField(
                  label: "Enter Email".tr,
                  hint: "xyz@gmail.com",
                  controller: emailController,
                  // isPhoneNumber: true,
                  // maxLength: 10,
                  // keyboardType: TextInputType.number,
                  // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const Gap(15),
                // Center(
                //   child: Obx(() {
                //     return CustomGradientButton(
                //       text: "get_code".tr,
                //       height: 45,
                //       width: 150,
                //       isLoading: isVerifying.value.obs,
                //       onTap: () async {
                //         final phoneNumber = emailController.text;
                //         if (isValidPhoneNumber(phoneNumber)) {
                //           isVerifying.value = true;
                //           await authService.sendVerificationCode(phoneNumber,context);
                //           isVerifying.value = false;
                //         }
                //       },
                //       isShowGradient: false,
                //     );
                //   }),
                // ),
                const Gap(10),
                CustomTextField(
                  label: "Enter Password".tr,
                  hint: "******",
                  maxLength: 6,
                  controller: passwordController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(RouteName.adminLoginScreen);
                    },
                    child: Text(
                      "login_as_owner".tr,
                      style: const TextStyle(color: AppColors.purple),
                    ),
                  ),
                ),
                const Gap(20),
                Obx(() {
                  return CustomGradientButton(
                    text: "continue".tr,
                    isLoading: verifyCode.value.obs,
                    onTap: () async {
                      final phoneNumber = emailController.text;

                      // Validate phone number
                      if (!isValidPhoneNumber(phoneNumber)) return;

                      // Check if verification code is entered
                      if (passwordController.text.isEmpty) {
                        Get.snackbar('error'.tr, 'verification_code_empty'.tr);
                        return;
                      }

                      // Set loading state
                      verifyCode.value = true;

                      try {
                        // Verify code
                        await authService.verifyCode(
                          passwordController.text,
                          emailController.text,
                        );
                      } catch (e) {
                        // Handle errors
                        Get.snackbar(
                            'error'.tr,
                            'verification_failed'
                                .trParams({'error': e.toString()}));
                      } finally {
                        // Reset loading state
                        verifyCode.value = false;
                      }
                    },
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
