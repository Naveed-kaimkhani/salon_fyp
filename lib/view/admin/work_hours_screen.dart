import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/blocked_dates.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view/admin/add_staff_member/time_picker_component.dart';
import 'package:hair_salon/view_model/blocked_dates_controller/blocked_date_provider.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class WorkHoursScreen extends StatelessWidget {
  final controller = Get.find<StaffController>();
  final blockedDatesProvider = Get.find<BlockedDatesProvider>();

  WorkHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'work_time_blocks'.tr,
        isTrailingCalender: true,
        onAddButtonTap: () {
          Get.toNamed(RouteName.blockDatesScreen);
        },
      ),
      body: Obx(() {
        if (blockedDatesProvider.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Row(
                  children: [
                    TimePickerComponent(
                      labelText: 'start_time'.tr,
                      time: controller.startTime,
                      selectTime: controller.selectTime,
                    ),
                    const Gap(8),
                    TimePickerComponent(
                      labelText: 'end_time'.tr,
                      time: controller.endTime,
                      selectTime: controller.selectTime,
                    ),
                  ],
                ),
                const Gap(10),
                LabelText(
                  text: 'blocked_dates'.tr,
                  fontSize: AppFontSize.xmedium,
                  weight: FontWeight.w600,
                ),
                const Gap(10),
                blockedDatesProvider.blockedDatesList.isEmpty
                    ? Center(child: Text('no_blocked_dates'.tr))
                    : Container(),

                const Gap(10),
                // List of blocked dates
                ...blockedDatesProvider.blockedDatesList.map(
                  (date) => BlockedDatesComponent(
                    date: Utills().formatDate(date.date),
                    time: "${date.startTime} - ${date.endTime}",
                    uid: date.id ?? "",
                  ),
                ),
                const Gap(10),
                // Block Time Button with Loading Indicator
                CustomGradientButton(
                  text: 'block_time'.tr,
                  isShowGradient: !blockedDatesProvider.isActionLoading.value,
                  isLoading: blockedDatesProvider.isActionLoading,
                  onTap: () async {
                    if (controller.startTime.value.isEmpty ||
                        controller.endTime.value.isEmpty) {
                      Get.snackbar('error'.tr, 'please_select_date_time'.tr);
                      return; // Stop further execution
                    }

                    // Add Blocked Date
                    final blockedDate = BlockedDateModel(
                      date: blockedDatesProvider.selectedDay.value.toString(),
                      startTime: controller.startTime.value.toString(),
                      endTime: controller.endTime.value.toString(),
                    );

                    await blockedDatesProvider.addBlockedDate(blockedDate);
                  },
                ),
                const Gap(10),
              ],
            ),
          ),
        );
      }),
    );
  }
}
