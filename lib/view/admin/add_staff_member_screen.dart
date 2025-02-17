import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/repository/manage_staff_api/manage_staff_repo.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view/admin/admin.dart';
import 'package:hair_salon/view_model/controller/controller.dart';
import 'package:hair_salon/view_model/loading_controller.dart';
import 'package:uuid/uuid.dart';

class AddStaffMemberScreen extends StatefulWidget {
  AddStaffMemberScreen({super.key});

  @override
  State<AddStaffMemberScreen> createState() => _AddStaffMemberScreenState();
}

class _AddStaffMemberScreenState extends State<AddStaffMemberScreen> {
  final controller = Get.find<StaffController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoadingController loadingController = Get.put(LoadingController());
  final StaffServicesRepository _staffServices =
      Get.find<StaffServicesRepository>();
  final String uid = Uuid().v4(); // Generate a unique identifier

  Uint8List? _profileImage;
  void _submitForm() async {
    if (controller.assignedServices.isEmpty) {
      Get.snackbar("error".tr, "please_assign_service".tr);
      return;
    }
    if (_profileImage == null) {
      Get.snackbar("error".tr, "please_upload_profile_picture".tr);
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (controller.selectedDays.isEmpty) {
        Get.snackbar("error".tr, "please_select_available_day".tr);
        return;
      }

      if (controller.startTime.value.isEmpty ||
          controller.endTime.value.isEmpty) {
        Get.snackbar("error".tr, "please_select_working_hours".tr);
        return;
      }

      if (!_isValidTimeRange()) {
        Get.snackbar("error".tr, "end_time_after_start_time".tr);
        return;
      }

      try {
        loadingController.isLoading.value = true; // Start loading

        // Upload profile image
        controller.photo.value = await _staffServices.uploadProfileImage(
          imageFile: _profileImage!,
          uid: uid,
        );

        // Add staff member
        await controller.addStaffMember();
        loadingController.isLoading.value = false; // Stop loading
      } catch (e) {
        loadingController.isLoading.value = false;
        Get.snackbar("error".tr, "something_went_wrong".tr);
      } finally {
        loadingController.isLoading.value = false; // Stop loading
      }
    }
  }

  bool _isValidTimeRange() {
    final startTime = _parseTime(controller.startTime.value);
    final endTime = _parseTime(controller.endTime.value);

    if (startTime == null || endTime == null) {
      return false; // Invalid time strings
    }

    return startTime.isBefore(endTime);
  }

  DateTime? _parseTime(String time) {
    try {
      final parts = time.split(" ");
      final timeParts = parts[0].split(":");
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final isPM = parts[1].toLowerCase() == "pm";

      // Adjust hours for PM times
      final adjustedHour =
          isPM && hour < 12 ? hour + 12 : (hour == 12 && !isPM ? 0 : hour);

      return DateTime(0, 1, 1, adjustedHour, minute);
    } catch (e) {
      return null;
    }
  }

  Widget uploadProfile(Uint8List? image) {
    return GestureDetector(
      onTap: () async {
        Uint8List? _image = await Utills.pickImage();
        if (_image != null) {
          setState(() {
            _profileImage = _image;
          });
        }
      },
      child: image == null
          ? Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.lightGrey.withOpacity(.7),
                  child: Icon(
                    Icons.person,
                    size: 90,
                    color: AppColors.mediumGrey.withOpacity(0.5),
                  ),
                ),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(image),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller.nameController.clear();
    controller.selectedRole.value = "hair_stylist".tr;
    controller.selectedDays.clear();
    controller.assignedServices.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "add_staff_member".tr,
        isLeadingNeed: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: uploadProfile(_profileImage),
                ),
                const Gap(20),
                CustomTextField(
                  label: "full_name".tr,
                  hint: "john_devy".tr,
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please_enter_full_name".tr;
                    }
                    return null;
                  },
                ),
                const Gap(16),
                CustomDropdown(
                  label: "role".tr,
                  items: ['hair_stylist'.tr, 'manager'.tr, 'receptionist'.tr],
                  hintText: "hair_stylist".tr,
                  defaultValue: "hair_stylist".tr,
                  onChanged: (value) {
                    controller.selectedRole.value = value ?? "hair_stylist".tr;
                  },
                ),
                const Gap(16),
                LabelText(
                  text: "choose_available_days".tr,
                  fontSize: AppFontSize.xmedium,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 8),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: controller.days.map((day) {
                        final isSelected =
                            controller.selectedDays.contains(day);
                        return GestureDetector(
                          onTap: () => controller.toggleDay(day),
                          child: Container(
                            width: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: AppColors.appGradientColors)
                                  : null,
                              color: isSelected ? null : AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )),
                const Gap(16),
                LabelText(
                  text: "select_working_hours".tr,
                  fontSize: AppFontSize.xmedium,
                  weight: FontWeight.w600,
                ),
                const Gap(8),
                Row(
                  children: [
                    TimePickerWidget(
                      labelText: "start_time".tr,
                      time: controller.startTime,
                      selectTime: controller.selectTime,
                    ),
                    const Gap(8),
                    TimePickerWidget(
                      labelText: "end_time".tr,
                      time: controller.endTime,
                      selectTime: controller.selectTime,
                    ),
                  ],
                ),
                const Gap(24),
                CustomGradientButton(
                  isShowGradient: false,
                  text: "assign_services".tr,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssignServicesScreen(
                                staffName: controller.nameController.text,
                              )),
                    );
                  },
                  isLoading: false.obs,
                ),
                const Gap(12),
                CustomGradientButton(
                  text: "add".tr,
                  onTap: _submitForm,
                  isLoading: loadingController.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimePickerWidget extends StatelessWidget {
  final RxString time;
  final Function(RxString) selectTime;
  final String labelText;

  const TimePickerWidget({
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
                    time.value.isEmpty ? "start_time".tr : time.value,
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
