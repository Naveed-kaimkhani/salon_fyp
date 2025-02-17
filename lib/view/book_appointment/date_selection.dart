

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class DateSelection extends StatelessWidget {
  DateSelection({
    super.key,
    this.isShowLabelText = true, 

  });

  final bool isShowLabelText;
  final DateSelectionController controller = Get.put(DateSelectionController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isShowLabelText)
          LabelText(
            text: "select_date".tr,
            weight: FontWeight.w600,
            fontSize: AppFontSize.xmedium,
          ),
        const Gap(10),
        Obx(() => EasyInfiniteDateTimeLine(
              firstDate: DateTime.now(),
              lastDate: DateTime(3000),
              onDateChange: (selectedDate) {
                // Update selected date in the controller
                controller.updateSelectedDate(selectedDate);
           
              },
              focusDate: controller.selectedDate.value,
              dayProps: EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                activeDayStyle: DayStyle(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.appGradientColors,
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
