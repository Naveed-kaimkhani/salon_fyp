import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/profile_image.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/manage_services_provider.dart';
import 'package:hair_salon/view_model/controller/treatment_card_controllerv2.dart';

class TreatmentCardV2 extends StatelessWidget {
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

  const TreatmentCardV2({
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
    final TreatmentCardControllerV2 controller =
        Get.put(TreatmentCardControllerV2());
    final servicesController = Get.find<ManageServiceProvider>();
    log("$duration:$duration");
    return Obx(() {
      return Container(
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
            // DecoratedImage(image: image),
            ProfileImage(imagePath: image),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelText(
                    text: "${'for'.tr} ${translateTreatmentFor(treatmentFor)}",
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
                        text: translateDuration(duration),
                        weight: FontWeight.w500,
                        fontSize: AppFontSize.xxsmall,
                        textColor: AppColors.grey,
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
                        CustomGradientButton(
                          height: 32,
                          width: 90,
                          text: "remove".tr,
                          onTap: () {
                            servicesController.removeService(uid ?? '');
                          },
                          isLoading: servicesController.isLoading,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

String translateTreatmentFor(String treatmentFor) {
  // A fallback map for translation if no .tr key is found
  final Map<String, Map<String, String>> translations = {
    "Men": {"en": "Men", "he": "גברים"},
    "Women": {"en": "Women", "he": "נשים"},
    "Both": {"en": "Both", "he": "שניהם"},
    "Male": {"en": "Male", "he": "זכר"},
  };

  // Detect the current locale
  String locale = Get.locale?.languageCode ?? "en";

  // Return the translation for the current locale
  return translations[treatmentFor.trim()]?[locale] ?? treatmentFor;
}

String translateDuration(String duration) {
  // Detect the current locale
  String locale = Get.locale?.languageCode ?? "en";

  // Extract the numeric part of the duration (assumes it's in the format "30 minutes")
  String numericDuration = duration.split(' ')[0];

  // Define the translation for "minutes"
  String minutesLabel = locale == 'he' ? "דקות" : "minutes";

  // Return the formatted string with the translated duration
  return "$numericDuration $minutesLabel";
}
