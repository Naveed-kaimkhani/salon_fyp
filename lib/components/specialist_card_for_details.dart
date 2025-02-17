import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/profile_image.dart';
import 'package:hair_salon/constants/constants.dart';

class SpecialistCardComponentForDetails extends StatelessWidget {
  final String imagePath;
  final String name;
  final String specialty;

  final String startTime;

  final String endTime;
  final bool isShowButton;
  final VoidCallback? ontap;
  final VoidCallback? buttonOnTap;
  final bool isDetailsButton;

  final List<String> listOfDays;
  final List<String> listOfServices;

  const SpecialistCardComponentForDetails({
    super.key,
    required this.imagePath,
    required this.name,
    required this.specialty,
    this.isShowButton = true,
    this.ontap,
    this.buttonOnTap,
    this.isDetailsButton = false,
    required this.listOfDays,
    required this.listOfServices,
    required this.startTime,
    required this.endTime,
  });

  bool isAvailable() {
    // Check if days or services list is empty
    if (listOfDays.isEmpty || listOfServices.isEmpty) {
      return false;
    }

    // Check if start or end time is empty
    if (startTime.isEmpty || endTime.isEmpty) {
      return false;
    }

    try {
      final now = DateTime.now();

      // Extract hours and minutes from startTime and endTime
      final startParts =
          startTime.split(' '); // Split "1:25 PM" into ["1:25", "PM"]
      final endParts = endTime.split(' ');

      final startHourMinute =
          startParts[0].split(':'); // Split "1:25" into ["1", "25"]
      final endHourMinute = endParts[0].split(':');

      int startHour = int.parse(startHourMinute[0]);
      final int startMinute = int.parse(startHourMinute[1]);
      int endHour = int.parse(endHourMinute[0]);
      final int endMinute = int.parse(endHourMinute[1]);

      // Adjust hours for PM times
      if (startParts[1] == 'PM' && startHour != 12) {
        startHour += 12;
      } else if (startParts[1] == 'AM' && startHour == 12) {
        startHour = 0;
      }

      if (endParts[1] == 'PM' && endHour != 12) {
        endHour += 12;
      } else if (endParts[1] == 'AM' && endHour == 12) {
        endHour = 0;
      }

      // Combine parsed times with today's date
      final startTimeToday =
          DateTime(now.year, now.month, now.day, startHour, startMinute);
      var endTimeToday =
          DateTime(now.year, now.month, now.day, endHour, endMinute);

      // If endTime is earlier than startTime, it means it is after midnight (next day)
      if (endTimeToday.isBefore(startTimeToday)) {
        endTimeToday = endTimeToday.add(const Duration(days: 1));
      }

      // Check if the current time is within the range
      return now.isAfter(startTimeToday) && now.isBefore(endTimeToday);
    } catch (e) {
      debugPrint("Error parsing time: $e");
      return false; // Default to unavailable if there's an error
    }
  }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isAvailable()
                                    ? AppColors.green
                                    : Colors.red,
                              ),
                            ),
                            isAvailable()
                                ? LabelText(
                                    text: ' ' + 'available'.tr,
                                    fontSize: AppFontSize.xxsmall,
                                    weight: FontWeight.w500,
                                  )
                                : LabelText(
                                    text: ' ' + "un_available".tr,
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
                                  text: isDetailsButton
                                      ? "details".tr
                                      : "book_now".tr,
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
