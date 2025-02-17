import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/app_colors.dart';

class NotificationTileComponent extends StatelessWidget {
  final String initials;
  final String title;
  final String subtitle;
  final String timeAgo;

  const NotificationTileComponent({
    super.key,
    required this.initials,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: AppColors.appGradientColors,
                  ),
                ),
                child: Center(
                  child: LabelText(
                    text: initials,
                    textColor: AppColors.white,
                    fontSize: 18,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LabelText(
                              text: title,
                              fontSize: 16,
                              weight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis),
                        ),
                        const Gap(8),
                        LabelText(
                          text: timeAgo,
                          fontSize: 12,
                          weight: FontWeight.w400,
                          textColor: AppColors.mediumGrey,
                        ),
                      ],
                    ),
                    const Gap(4),
                    LabelText(
                      text: subtitle,
                      fontSize: 14,
                      weight: FontWeight.w400,
                      textColor: AppColors.grey,
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
