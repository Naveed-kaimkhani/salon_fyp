import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionButtonTitle,
    required this.onActionButtonTap,
  });

  final String title;
  final String content;
  final VoidCallback onActionButtonTap;
  final String actionButtonTitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.lightGrey.withOpacity(0.4),
              child: const Icon(
                Icons.warning,
                color: AppColors.purple,
                size: 30,
              ),
            ),
            const Gap(20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.purple,
              ),
            ),
            const Gap(10),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.mediumGrey,
              ),
            ),
            const Gap(20),
            CustomGradientButton(
              text: actionButtonTitle,
              onTap: onActionButtonTap,
              isLoading: false.obs,
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Text(
                "cancel".tr,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
