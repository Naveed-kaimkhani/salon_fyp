import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/repository/manage_staff_api/manage_staff_repo.dart';
import 'package:hair_salon/view_model/controller/staff_controller.dart';

class EditStaffController extends GetxController {
  final StaffServicesRepository staffServices;

  EditStaffController({required this.staffServices});

  // Observable fields for editing staff
  final nameController = TextEditingController();
  var assignedServices = <String>[].obs;
  var startTime = ''.obs;
  var endTime = ''.obs;
  var selectedRole = ''.obs;
  var photo = ''.obs;
  var selectedDays = <String>[].obs;
  var isActionLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> selectTime(RxString time) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final formattedTime = pickedTime.format(Get.context!);
      time.value = formattedTime;
    }
  }

  Future<void> uploadImage(Uint8List image, String uid) async {
    try {
      photo.value = await staffServices.uploadProfileImage(
        imageFile: image,
        uid: uid,
      );
    } catch (e) {
      Get.snackbar(
          'error'.tr, 'image_upload_failed'.trParams({'error': e.toString()}));
    }
  }

  Future<void> editStaffMember(
      StaffModel originalStaff, List<String> days) async {
    final updatedFields = <String, dynamic>{};

    updatedFields['displayName'] = nameController.text;
    updatedFields['role'] = selectedRole.value;
    updatedFields['startTime'] = startTime.value;
    updatedFields['endTime'] = endTime.value;
    updatedFields['listOfServices'] = assignedServices;
    updatedFields['photoURL'] = photo.value;
    updatedFields['days'] = days != originalStaff.days? days : originalStaff.days;
    if (updatedFields.isNotEmpty) {
      isActionLoading.value = true;
      try {
        await staffServices.updateStaffMember(originalStaff.uid, updatedFields);

        final staffProvider = Get.find<StaffController>();
        staffProvider.fetchStaffData();
        // Notify success and close screen
      } catch (e) {
        Get.snackbar(
            'error'.tr, 'edit_failed'.trParams({'error': e.toString()}));
      } finally {
        isActionLoading.value = false;
      }
    } else {
      Get.snackbar('info'.tr, 'no_changes_to_save'.tr);
    }
  }

  void initializeFields(StaffModel staff) {
    nameController.text = staff.displayName;
    selectedRole.value = staff.role;
    startTime.value = staff.startTime;
    endTime.value = staff.endTime;
    assignedServices.value = staff.listOfServices;
    photo.value = staff.photoURL;
    selectedDays.value = staff.days;
  }

  Future<void> removeStaffMember(String uid) async {
    isActionLoading.value = true; // Start loading for the action
    try {
      await staffServices.removeStaffMember(uid);

      final staffProvider = Get.find<StaffController>();
      staffProvider.staffList.removeWhere((staff) => staff.uid == uid);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_remove_staff_member'.trParams({'error': e.toString()}));
    } finally {
      isActionLoading.value = false; // Stop loading after action
    }
  }
}
