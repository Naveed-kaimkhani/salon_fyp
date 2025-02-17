import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late TextEditingController phoneController, otpController;
  final FirebaseAuthRepository authService = FirebaseAuthRepository();
  final RxBool isVerifying = false.obs;
  final RxBool isDeleting = false.obs;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  /// Handles the delete account process
  Future<void> deleteAccountFlow(String phoneNumber, String otp) async {
    try {
      isDeleting.value = true;

      // Call the delete account logic from FirebaseAuthRepository
      await authService.handleDeleteAccount(phoneNumber, otp);

      // Navigate to login screen after successful deletion
      Get.offAllNamed(RouteName.userLoginScreen);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_delete_account'.trParams({'error': e.toString()}));
    } finally {
      isDeleting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'delete_account'.tr,
        isLeadingNeed: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(50),
              LabelText(
                text: "delete_account".tr,
                textColor: AppColors.purple,
                fontSize: AppFontSize.xlarge,
                weight: FontWeight.w600,
              ),
              const Gap(20),

              // Phone number input
              CustomTextField(
                label: "phone_number".tr,
                hint: "50 123 4567",
                controller: phoneController,
                isPhoneNumber: true,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const Gap(20),

              // Send OTP button
              Center(
                child: Obx(() => CustomGradientButton(
                      isLoading: isVerifying.value.obs,
                      text: "send_otp".tr,
                      height: 45,
                      width: 150,
                      onTap: () async {
                        final phoneNumber = phoneController.text.trim();
                        if (phoneNumber.isEmpty) {
                          Get.snackbar('error'.tr, 'enter_phone_number'.tr);
                          return;
                        }

                        try {
                          isVerifying.value = true;

                          // Send OTP
                          await authService.sendVerificationCode(phoneNumber,context);

                          Get.snackbar(
                              'success'.tr,
                              'otp_sent'
                                  .trParams({'phoneNumber': phoneNumber}));
                        } catch (e) {
                          Get.snackbar(
                              'error'.tr,
                              'failed_to_send_otp'
                                  .trParams({'error': e.toString()}));
                        } finally {
                          isVerifying.value = false;
                        }
                      },
                    )),
              ),
              const Gap(20),

              // OTP input
              CustomTextField(
                label: "enter_verification_code".tr,
                hint: "123456",
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const Gap(20),

              // Delete Account button
              Center(
                child: Obx(() => CustomGradientButton(
                      isLoading: isDeleting.value.obs,
                      text: "delete_account_button".tr,
                      height: 45,
                      width: 200,
                      onTap: () async {
                        final phoneNumber = phoneController.text.trim();
                        final otp = otpController.text.trim();

                        if (phoneNumber.isEmpty || otp.isEmpty) {
                          Get.snackbar('error'.tr, 'enter_phone_and_otp'.tr);
                          return;
                        }

                        // Trigger the delete flow
                        await deleteAccountFlow(phoneNumber, otp);
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
