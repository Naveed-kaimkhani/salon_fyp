// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';

class UserLogInScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final RxBool verifyCode = false.obs;
  final FirebaseAuthRepository authService = FirebaseAuthRepository();
  final isVerifying = false.obs;

  bool isValidPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      Get.snackbar('error'.tr, 'phone_empty'.tr);
      return false;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      Get.snackbar('error'.tr, 'phone_invalid'.tr);
      return false;
    }
    if (phoneNumber.length < 10) {
      Get.snackbar('error'.tr, 'phone_short'.tr);
      return false;
    }
    return true;
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
                  label: "phone_number".tr,
                  hint: "50 123 4567",
                  controller: phoneController,
                  isPhoneNumber: true,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const Gap(15),
                Center(
                  child: Obx(() {
                    return CustomGradientButton(
                      text: "get_code".tr,
                      height: 45,
                      width: 150,
                      isLoading: isVerifying.value.obs,
                      onTap: () async {
                        final phoneNumber = phoneController.text;
                        if (isValidPhoneNumber(phoneNumber)) {
                          isVerifying.value = true;
                          await authService.sendVerificationCode(phoneNumber,context);
                          isVerifying.value = false;
                        }
                      },
                      isShowGradient: false,
                    );
                  }),
                ),
                const Gap(10),
                CustomTextField(
                  label: "enter_verification_code".tr,
                  hint: "123456",
                  maxLength: 6,
                  controller: pinController,
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
                      final phoneNumber = phoneController.text;

                      // Validate phone number
                      if (!isValidPhoneNumber(phoneNumber)) return;

                      // Check if verification code is entered
                      if (pinController.text.isEmpty) {
                        Get.snackbar('error'.tr, 'verification_code_empty'.tr);
                        return;
                      }

                      // Set loading state
                      verifyCode.value = true;

                      try {
                        // Verify code
                        await authService.verifyCode(
                          pinController.text,
                          phoneController.text,
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
