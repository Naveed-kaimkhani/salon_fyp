import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/app_colors.dart';
import 'package:hair_salon/models/models.dart';
import 'package:hair_salon/view_model/controller/switch_controller.dart';

class RemindMeToggle extends StatelessWidget {
  final Appointment appointment;
  final SwitchController switchController;
  final String text;

  const RemindMeToggle({
    super.key,
    required this.appointment,
    required this.switchController,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => Transform.scale(
            scaleX: .8,
            scaleY: .75,
            child: CupertinoSwitch(
              value: switchController.initialvalue.value,
              onChanged: (value) {
                switchController.changeSwitchValue(value);
              },
              activeColor: AppColors.purple,
            ),
          ),
        ),
        LabelText(
          text: text,
          fontSize: 14,
          weight: FontWeight.w400,
          textColor: AppColors.mediumGrey,
        ),
      ],
    );
  }
}
