import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';

class UserProfileComponent extends StatelessWidget {
  final String circularAvetartxt;
  final String userName;
  final String number;
  final bool isShowButton;
  final VoidCallback? onButtonTap;

  const UserProfileComponent({
    super.key,
    required this.circularAvetartxt,
    required this.userName,
    required this.number,
    this.isShowButton = true,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.purple,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: AppColors.lightGrey,
              child: LabelText(
                text: circularAvetartxt,
                fontSize: 32,
                weight: FontWeight.w600,
                textColor: AppColors.purple,
              ),
            ),
          ),
          const Gap(10),
          LabelText(
            text: userName,
            fontSize: 18,
            weight: FontWeight.w600,
          ),
          const Gap(5),
          LabelText(
            text: number,
            fontSize: 14,
            weight: FontWeight.w400,
            textColor: AppColors.mediumGrey,
          ),
          const Gap(16),
          isShowButton
              ? CustomGradientButton(
                  text: "edit_account".tr,
                  fontSize: 16,
                  height: 45,
                  onTap: onButtonTap,
                  isLoading: false.obs,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
