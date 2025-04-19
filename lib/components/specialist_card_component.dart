import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/profile_image.dart';
import 'package:hair_salon/constants/constants.dart';

class SpecialistCardComponent extends StatelessWidget {
  final String imagePath;
  final String name;
  final String specialty;

  final String endTime;

  final String startTime;

  final String salonName;
  final bool isShowButton;
  final VoidCallback? ontap;
  final VoidCallback? buttonOnTap;
  final bool isDetailsButton;
  final List<String> listOfDays;
  final List<String> listOfServices;

  const SpecialistCardComponent({
    super.key,
    required this.imagePath,
    required this.name,
    required this.specialty,
    this.isShowButton = true,
    this.ontap,
    this.buttonOnTap,
    required this.salonName,
    this.isDetailsButton = false,
    required this.listOfDays,
    required this.listOfServices,
    required this.endTime,
    required this.startTime,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 100,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.lightGrey,
          ),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImage(imagePath: imagePath),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LabelText(
                      text: name,
                      weight: FontWeight.w600,
                      fontSize: AppFontSize.medium,
                    ),
                    LabelText(
                      text: specialty,
                      fontSize: AppFontSize.xsmall,
                      weight: FontWeight.w400,
                      textColor: AppColors.mediumGrey,
                    ),
                    // LabelText(
                    //   text: "naveed salon",
                    //   fontSize: 5,
                    //   weight: FontWeight.w400,
                    //   textColor: AppColors.mediumGrey,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        isDetailsButton
                            ? const SizedBox.shrink()
                            : Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                    ),
                                  ),
                                  const Gap(5),
                                  LabelText(
                                    text: salonName,
                                    fontSize: AppFontSize.xxsmall,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                        const Spacer(),
                        isShowButton
                            ? ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 90,
                                  maxWidth: 100,
                                ),
                                child: CustomGradientButton(
                                  height: 36,
                                  text: "book_now".tr,
                                  fontSize: AppFontSize.xsmall,
                                  onTap: buttonOnTap,
                                  isLoading: false.obs,
                                ))
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
