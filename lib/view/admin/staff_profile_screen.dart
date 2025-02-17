

///////////////
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/assigned_services_widget.dart';
import 'package:hair_salon/components/edit_assign_services.dart';
import 'package:hair_salon/components/profile_image.dart';
import 'package:hair_salon/components/show_days.dart';
import 'package:hair_salon/constants/app_fonts.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/repository/index.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view/admin/add_staff_member/add_staff_member.dart';
import 'package:hair_salon/view_model/controller/edit_staff_controller.dart';

import '../../components/components.dart';
import '../../view_model/index.dart';

class StaffProfileScreen extends StatefulWidget {
  final StaffModel staff;
  const StaffProfileScreen({super.key, required this.staff});

  @override
  State<StaffProfileScreen> createState() => _StaffProfileScreenState();
}

class _StaffProfileScreenState extends State<StaffProfileScreen> {
  final controller = Get.find<EditStaffController>();
  Uint8List? _profileImage;

  final ManageServiceRepo _servicesController = Get.find<ManageServiceRepo>();
  final StaffServicesRepository _staffServices =
      Get.find<StaffServicesRepository>();
  // final ManageServiceRepo _servicesController = Get.find<ManageServiceRepo>();
  final serviceProvider = Get.find<ManageServiceProvider>();
  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();
    controller.initializeFields(widget.staff);
    selectedDays = widget.staff.days;
  }

  Future<void> uploadImage() async {
    if (_profileImage != null) {
      controller.photo.value = await _staffServices.uploadProfileImage(
        imageFile: _profileImage!,
        uid: widget.staff.uid,
      );
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
          ? ProfileImage(imagePath: widget.staff.photoURL)
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        isLeadingNeed: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: uploadProfile(_profileImage)),
              const Gap(10),
              CustomTextField(
                label: "full_name".tr,
                hint: widget.staff.displayName,
                controller: controller.nameController,
              ),
              const Gap(10),
              CustomDropdown(
                label: "role".tr,
                items: ['Hair Stylist', 'Manager', 'Receptionist'],
                hintText: widget.staff.role.tr,
                defaultValue: controller.selectedRole.value.isEmpty
                    ? widget.staff.role.tr
                    : controller.selectedRole.value.tr,
                onChanged: (value) {
                  controller.selectedRole.value = value ?? 'Hair Stylist';
                },
              ),
              const Gap(10),
              LabelText(
                text: "schedule".tr,
                weight: FontWeight.w600,
                fontSize: AppFontSize.xmedium,
              ),
              const Gap(10),
              ShowDays(
                initialSelectedDays: widget.staff.days,
                onSelectionChanged: (updatedSelectedDays) {
                  selectedDays = updatedSelectedDays;
                },
              ),
              const Gap(10),
              LabelText(
                text: "hours".tr,
                fontSize: AppFontSize.xsmall,
                weight: FontWeight.w400,
              ),
              const Gap(10),
              Row(
                children: [
                  TimePickerComponent(
                    labelText: "start_time".tr,
                    time: controller.startTime,
                    selectTime: controller.selectTime,
                  ),
                  const Gap(8),
                  TimePickerComponent(
                    labelText: "end_time".tr,
                    time: controller.endTime,
                    selectTime: controller.selectTime,
                  ),
                ],
              ),
              const Gap(10),
              LabelText(
                text: "assigned_services".tr,
                fontSize: AppFontSize.xmedium,
                weight: FontWeight.w600,
              ),
              const Gap(10),
              AssignedServicesWidget(
                servicesController: _servicesController,
                listOfServices: widget.staff.listOfServices,
              ),
              const Gap(10),
              Center(
                child: CustomGradientButton(
                  height: 45,
                  width: 200,
                  text: "edit_assigned_services".tr,
                  onTap: () async {
                    var updatedServices =
                        await Get.to(() => EditAssignedServicesScreen(
                              selectedServices: widget.staff.listOfServices,
                            ));
            
                    if (updatedServices != null) {
                      // setState(() {
                      // });
                      controller.assignedServices.value = List<String>.from(
                          updatedServices); // Update the list with the returned services
                    }
                  },
                  isLoading: false.obs,
                ),
              ),
              const Gap(30),
              CustomGradientButton(
                isShowGradient: false,
                text: 'remove'.tr,
                isLoading: false.obs,
                onTap: () {
                  Get.dialog(
                    DeleteAccountDialog(
                      title: "remove_staff_member".tr,
                      content:
                          '${'remove_staff_confirmation_part1'.tr} ${widget.staff.displayName} ${'remove_staff_confirmation_part2'.tr}',
                      actionButtonTitle: 'remove'.tr,
                      onActionButtonTap: () {
                        controller.removeStaffMember(
                          widget.staff.uid,
                        );
                      },
                    ),
                  );
                },
              ),
              const Gap(10),
              CustomGradientButton(
                text: "save".tr,
                onTap: () async {
                  await controller.editStaffMember(widget.staff, selectedDays);
             
                },
                isLoading: controller.isActionLoading,
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
