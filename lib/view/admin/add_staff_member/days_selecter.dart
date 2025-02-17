import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class DaysSelector extends StatelessWidget {
  // final List<String> days;
    final controller = Get.find<StaffController>();
  DaysSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: controller.days.map(
          (day) {
            final isSelected = controller.selectedDays.contains(day);
            return GestureDetector(
              onTap: () => controller.toggleDay(day),
              child: Container(
                width: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(colors: AppColors.appGradientColors)
                      : null,
                  color: isSelected ? null : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}