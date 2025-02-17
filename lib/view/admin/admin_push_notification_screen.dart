import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/push_notification_controller.dart';

class AdminPushNotificationScreen extends StatelessWidget {
  AdminPushNotificationScreen({super.key});

  final PushNotificationController notificationController =
      Get.put(PushNotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'push_notifications'.tr,
        isLeadingNeed: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText(
              text: 'appointment_reminders'.tr,
              fontSize: AppFontSize.xmedium,
              weight: FontWeight.w600,
            ),
            Obx(() => notificationSwitch(
                  text: 'send_reminder'.tr,
                  value: notificationController.isReminderEnabled.value,
                  onChanged: (value) {
                    notificationController.updateNotificationSetting(
                        'isReminderEnabled', value);
                  },
                )),
            LabelText(
              text: 'appointment_changes_cancellations'.tr,
              fontSize: AppFontSize.xmedium,
              weight: FontWeight.w600,
            ),
            Obx(() => notificationSwitch(
                  text: 'notify_changes'.tr,
                  value:
                      notificationController.isChangeNotificationEnabled.value,
                  onChanged: (value) {
                    notificationController.updateNotificationSetting(
                        'isChangeNotificationEnabled', value);
                  },
                )),
            const Spacer(),
            CustomGradientButton(
              text: 'send_broadcast'.tr,
              onTap: () {
                Get.dialog(BroadcastMessageDialog());
              },
              isLoading: false.obs,
            ),
          ],
        ),
      ),
    );
  }

  Widget notificationSwitch({
    required String text,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: value,
              activeColor: AppColors.purple,
              onChanged: onChanged,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LabelText(
                text: text,
                fontSize: AppFontSize.xsmall,
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
