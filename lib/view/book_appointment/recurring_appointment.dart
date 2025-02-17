import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class RecurringAppointment extends StatelessWidget {
  RecurringAppointment({super.key});

  // Instantiate the controller
  final RecurringAppointmentController controller =
      Get.put(RecurringAppointmentController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "recurring_appointment".tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              // Use Obx to listen for changes in isRecurring
              Obx(
                () => Transform.scale(
                  scaleX: .8,
                  scaleY: .8,
                  child: CupertinoSwitch(
                    value: controller.isRecurring.value,
                    onChanged: controller.toggleRecurring,
                    activeColor: Colors.purple,
                  ),
                ),
              ),
              const Gap(8),
              const Spacer(),
              // Use Obx to listen for changes in selectedFrequency
              Obx(
                () => DropdownButton<String>(
                  value: controller.selectedFrequency.value,
                  underline: const SizedBox(),
                  items: <String>["Weekly", "Monthly", "Yearly"]
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: LabelText(
                        text: value,
                        fontSize: AppFontSize.small,
                        weight: FontWeight.w400,
                        textColor: AppColors.grey,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.updateFrequency(newValue);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
