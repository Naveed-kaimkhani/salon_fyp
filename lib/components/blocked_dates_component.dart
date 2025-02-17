import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/blocked_dates_controller/blocked_date_provider.dart';

class BlockedDatesComponent extends StatelessWidget {
  const BlockedDatesComponent(
      {super.key, required this.date, required this.time, required this.uid});
  final String date;
  final String uid;
  final String time;

  @override
  Widget build(BuildContext context) {
    final blockedDatesProvider = Get.find<BlockedDatesProvider>();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lightGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.purple)),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.calendar_month,
                  color: AppColors.purple,
                ),
              ),
            ),
            const Gap(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelText(
                  text: date,
                  fontSize: AppFontSize.medium,
                  weight: FontWeight.w600,
                ),
                LabelText(
                  text: time,
                  fontSize: AppFontSize.xsmall,
                  weight: FontWeight.w400,
                  textColor: AppColors.mediumGrey,
                ),
              ],
            ),
            const Spacer(),
            CustomGradientButton(
              isLoading: false.obs,
              height: 32,
              width: 80,
              text: 'unblock'.tr,
              fontSize: AppFontSize.xsmall,
              fontWeight: FontWeight.w500,
              onTap: () {
               

                blockedDatesProvider.deleteBlockedDate(uid);
              },
            ),
          ],
        ),
      ),
    );
  }
}
