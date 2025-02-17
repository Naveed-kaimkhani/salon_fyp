import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hair_salon/constants/constants.dart';

class ProfileOptionComponent extends StatelessWidget {
  final String svgIcon;
  final String label;
  final VoidCallback onTap;

  const ProfileOptionComponent({
    super.key,
    required this.svgIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.lightGrey,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: ListTile(
          leading: SvgPicture.asset(
            svgIcon,
            colorFilter:
                const ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
          ),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.grey,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.mediumGrey,
            size: 16,
          ),
        ),
      ),
    );
  }
}
