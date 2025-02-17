import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/treatment_card_V2.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/models.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view_model/controller/controller.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentDetailsCard extends StatelessWidget {
  final Appointment appointment;
  final SwitchController switchController;
  final VoidCallback? onButtonTap;

  const AppointmentDetailsCard({
    super.key,
    required this.appointment,
    required this.switchController,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format date and time using intl
    final formattedDate = DateFormat('yyyy-MM-dd').format(appointment.date);
    final formattedTime = Utills.convertTo24Hour(appointment.time);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.lightGrey,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // Ensure the column adapts to its content
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelText(
                  text: "$formattedDate $formattedTime",
                  weight: FontWeight.w600,
                  fontSize: AppFontSize.xmedium,
                ),
                const Gap(10),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: appointment.serviceImageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Container(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 80,
                          color: AppColors.mediumGrey,
                        ),
                      ),
                    ),
                    const Gap(20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelText(
                            text: translateTreatmentFor(
                                appointment.appointmentFor),
                            weight: FontWeight.w600,
                            fontSize: AppFontSize.small,
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: AppColors.mediumGrey,
                              ),
                              const Gap(8),
                              LabelText(
                                text: translateDuration(appointment.duration),
                                fontSize: 16,
                                weight: FontWeight.w400,
                                textColor: AppColors.mediumGrey,
                              ),
                            ],
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LabelText(
                                text: 'with_stylist'
                                    .trParams({'stylist': appointment.stylist}),
                                fontSize: 14,
                                weight: FontWeight.w400,
                                textColor: AppColors.mediumGrey,
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 100,
                                  height: 40,
                                  child: CustomGradientButton(
                                    isLoading: false.obs,
                                    text: 'details'.tr,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    onTap: onButtonTap,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
