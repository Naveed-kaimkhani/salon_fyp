import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/models.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view_model/controller/appointment_provider.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;
  AppointmentDetailsScreen({super.key, required this.appointment});
  final controller = Get.find<AppointmentProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'appointment_details'.tr,
        isLeadingNeed: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              _buildAppointmentInfoCard(appointment),
              const Gap(10),
              _buildDateTimeSection(appointment),
              const Gap(20),
              _buildPersonalDetailsSection(appointment),
              const Gap(20),
              CustomGradientButton(
                text: "cancel_appointment".tr,
                onTap: () async {
                  controller.isLoading.value = true;
                  // await controller.deleteAppointment(appointment);
               await    controller.deleteAppointmentAndMoveToCancel(appointment);
                  controller.isLoading.value = false;
                  Get.snackbar('info'.tr, 'appointment_cancelled'.tr);
                  Get.back();
                },
                isLoading: controller.isLoading,
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentInfoCard(Appointment appointment) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          text: 'appointment_information'.tr,
          weight: FontWeight.w600,
          fontSize: AppFontSize.medium,
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.lightGrey,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: appointment.serviceImageUrl ?? '',
                  height: 169,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelText(
                      text: appointment.stylist,
                      fontSize: AppFontSize.medium,
                      weight: FontWeight.w600,
                    ),
                    LabelText(
                      text: appointment.charges.toString(),
                      weight: FontWeight.w600,
                      fontSize: AppFontSize.xxmedium,
                      textColor: AppColors.purple,
                    ),
                  ],
                ),
                Row(
                  children: [
                    LabelText(
                      text: appointment.appointmentFor,
                      textColor: AppColors.mediumGrey,
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.alarm,
                      color: AppColors.mediumGrey,
                      size: 22,
                    ),
                    LabelText(
                      text: appointment.duration,
                      textColor: AppColors.mediumGrey,
                    ),
                  ],
                ),
                const Gap(10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(Appointment appointment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          text: 'date_time'.tr,
          weight: FontWeight.w600,
          fontSize: AppFontSize.medium,
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _buildInfoTile(
                icon: AppSvgIcons.calenderIcon,
                label: 'date'.tr,
                value: appointment.date.toString(),
                showDivider: true,
              ),
              _buildInfoTile(
                icon: AppSvgIcons.clockIcon,
                label: 'time'.tr,
                value: Utills.convertTo24Hour(appointment.time),
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required String icon,
    required String label,
    required String value,
    bool showDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(icon),
              const Gap(5),
              LabelText(
                text: label,
                fontSize: AppFontSize.small,
              ),
              const Spacer(),
              SizedBox(
                width: 170,
                child: LabelText(
                  text: value,
                  fontSize: AppFontSize.small,
                  textColor: AppColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: 2,
            color: AppColors.lightGrey,
          ),
      ],
    );
  }

  Widget _buildPersonalDetailsSection(Appointment appoinment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          text: 'personal_details'.tr,
          weight: FontWeight.w600,
          fontSize: AppFontSize.medium,
        ),
        const Gap(10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _buildInfoTile(
                icon: AppSvgIcons.userIcon,
                label: 'gender'.tr,
                value: appoinment.gender,
                showDivider: true,
              ),
              _buildInfoTile(
                icon: AppSvgIcons.calenderIcon,
                label: 'date_of_birth'.tr,
                value: appoinment.birthday.toString(),
                showDivider: true,
              ),
              _buildInfoTile(
                icon: AppSvgIcons.call,
                label: 'phone_number'.tr,
                value: "+972 ${appoinment.phoneNumber}",
                showDivider: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
