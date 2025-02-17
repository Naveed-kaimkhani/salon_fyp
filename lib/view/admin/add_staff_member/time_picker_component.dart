import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';

class TimePickerComponent extends StatelessWidget {
  final RxString time;
  final Function(RxString) selectTime;
  final String labelText;

  const TimePickerComponent({
    super.key,
    required this.time,
    required this.selectTime,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelText(
            text: labelText,
            fontSize: AppFontSize.xsmall,
            weight: FontWeight.w400,
          ),
          Container(
            height: 56,
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.mediumGrey,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Text(
                    time.value.isEmpty ? "select_time".tr : time.value,
                    style: TextStyle(
                      color: time.value.isEmpty
                          ? AppColors.mediumGrey
                          : Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => selectTime(time),
                  child: const Icon(
                    Icons.access_time,
                    color: AppColors.mediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
