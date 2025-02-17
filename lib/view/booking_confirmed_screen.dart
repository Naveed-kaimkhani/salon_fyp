import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:intl/intl.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive arguments passed from the previous screen
    final args = Get.arguments;
    final bool isWaitlisted = args['isWaitlisted'];
    final String specialistName = args['specialistName'];
    final DateTime selectedDate = args['selectedDate'];
    final String selectedTime = args['selectedTime'];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            const Gap(56),
            Image.asset(AppImages.bookingComfirmed),
            LabelText(
              text: "booking_confirmed".tr,
              fontSize: AppFontSize.large,
              weight: FontWeight.w600,
            ),
            // Show dynamic message
            LabelText(
              text: isWaitlisted
                  ? "added_to_waitlist".trParams({
                      'specialistName': specialistName,
                      'selectedTime': selectedTime,
                      'selectedDate':
                          DateFormat('MMMM dd, yyyy').format(selectedDate),
                    })
                  : "scheduled_appointment".trParams({
                      'specialistName': specialistName,
                      'selectedTime': Utills.convertTo24Hour(selectedTime),
                      'selectedDate':
                          DateFormat('MMMM dd, yyyy').format(selectedDate),
                    }),
              fontSize: AppFontSize.small,
              weight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            CustomGradientButton(
              text: "back_to_home".tr,
              onTap: () {
                Get.back();
                Get.back();
              },
              isLoading: false.obs,
            ),

            const Gap(20),
          ],
        ),
      ),
    );
  }
}
