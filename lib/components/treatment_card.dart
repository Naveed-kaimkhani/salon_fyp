import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/profile_image.dart';
import 'package:hair_salon/components/treatment_card_V2.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class TreatmentCard extends StatelessWidget {
  final String? uid;
  final String treatmentFor;
  final String service;
  final String duration;
  final double price;
  final String image;
  final bool isShowChackBoxAtTrailing;
  final bool isShowEditButton;
  final bool isShowPrice;
  final bool isShowButton;

  const TreatmentCard({
    super.key,
    this.uid,
    required this.treatmentFor,
    required this.service,
    required this.duration,
    required this.price,
    required this.image,
    this.isShowChackBoxAtTrailing = false,
    this.isShowEditButton = false,
    this.isShowPrice = false,
    this.isShowButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final TreatmentCardController controller =
        Get.find<TreatmentCardController>();
    return Obx(() {
      return GestureDetector(
        onTap: () {
          // Handle the selection
          controller.selectTreatment(
            uid ?? '',
            service,
            duration,
            price,
            image,
            treatmentFor,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: controller.uid.value == uid
                  ? AppColors.purple
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileImage(imagePath: image),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(
                      text:
                          "for".tr + " " + translateTreatmentFor(treatmentFor),
                      weight: FontWeight.w500,
                      fontSize: AppFontSize.xxsmall,
                      textColor: AppColors.grey,
                    ),
                    LabelText(
                      text: service,
                      fontSize: AppFontSize.medium,
                      weight: FontWeight.w600,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.schedule,
                            size: 22, color: AppColors.mediumGrey),
                        LabelText(
                          text: " ${translateDuration(duration)}",
                          fontSize: AppFontSize.small,
                          weight: FontWeight.w400,
                          textColor: AppColors.mediumGrey,
                        ),
                      ],
                    ),
                    if (isShowPrice)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          LabelText(
                            text: " $price",
                            fontSize: AppFontSize.medium,
                            weight: FontWeight.w600,
                            textColor: AppColors.purple,
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
