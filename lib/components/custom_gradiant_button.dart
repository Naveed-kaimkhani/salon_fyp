import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/app_colors.dart';

class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? fontSize;
  final FontWeight fontWeight;
  final double height;
  final double width;
  final bool? isShowGradient;
  final EdgeInsetsGeometry? margin;
  final RxBool isLoading; // Add an RxBool for loading state

  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isLoading, // Mark as required
    this.fontWeight = FontWeight.w600,
    this.fontSize = 16,
    this.height = 56,
    this.width = double.infinity,
    this.isShowGradient = true,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading.value ? null : onTap, // Disable button when loading
      child: Obx(() => Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: isShowGradient!
                  ? LinearGradient(
                      colors: AppColors.appGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: AppColors.purple,
              ),
            ),
            margin: margin,
            child: Center(
              child: isLoading.value // Check if loading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white), // Progress color
                    )
                  : LabelText(
                      text: text,
                      fontSize: fontSize,
                      weight: fontWeight,
                      textColor:
                          isShowGradient! ? AppColors.white : AppColors.purple,
                    ),
            ),
          )),
    );
  }
}
