import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/repository/manage_staff_api/manage_staff_repo.dart';

class StaffController extends GetxController {
  //add a constructor to inject the repository
  final StaffServicesRepository staffServices;
  StaffController({required this.staffServices});
  // Observable list of staff members
  var staffList = <StaffModel>[].obs;
  var isLoading = true.obs;
  final nameController = TextEditingController();
  RxList<String> assignedServices = <String>[].obs;

  final startTime = ''.obs; // Observable string for start time
  final endTime = ''.obs; // Observable string for end time
  var selectedRole = ''.obs;
  var photo = ''.obs;

  final List<String> roles = [
    'hair_stylist'.tr,
    'manager'.tr,
    'receptionist'.tr
  ];
  var selectedDays = <String>[].obs; // Observable list for selected days
  final List<String> days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  // Add a loading field
  var isActionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch staff data when the controller is initialized
    fetchStaffData();
  }

  Future<void> updateServices({
    required String staffUid,
    required List<String> services,
  }) async {
    try {
      isLoading.value = true;
      await staffServices.updateStaffServices(
          staffUid: staffUid, services: services);
      isLoading.value = true;
      await staffServices.updateStaffServices(
          staffUid: staffUid, services: services);
      // Update locally stored staff data if necessary

      isLoading.value = false;
      Get.snackbar('success'.tr, 'services_updated_successfully'.tr);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('error'.tr,
          'failed_to_update_services'.trParams({'error': e.toString()}));
    }
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

  void toggleDay(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  // Fetch staff data using the repository
  Future<void> fetchStaffData() async {
    try {
      isLoading.value = true;
      final fetchedStaffList = await staffServices.fetchStaffList();
      staffList.value = fetchedStaffList;
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_fetch_staff'.trParams({'error': e.toString()}));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStaffMember() async {
    isActionLoading.value = true; // Start loading for the action
    final name = nameController.text;
    final role = selectedRole.value;
    final days = selectedDays;
    final startTimeValue = startTime.value;
    final endTimeValue = endTime.value;

    final staff = StaffModel(
      displayName: name,
      role: role,
      days: days,
      startTime: startTimeValue,
      endTime: endTimeValue,
      photoURL: photo.value,
      listOfServices: assignedServices,
    );

    try {
      final uploadStaff = await staffServices.addStaffMember(staff);
      staffList.add(uploadStaff);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_add_staff_member'.trParams({'error': e.toString()}));
    } finally {
      isActionLoading.value = false; // Stop loading after action
    }
  }

  Future<void> editStaffMember(
    StaffModel originalStaff,
    List<String> Days,
  ) async {
    final updatedFields = <String, dynamic>{};
    updatedFields['displayName'] = nameController.text;
    updatedFields['role'] = selectedRole.value;
    updatedFields['startTime'] = startTime.value;
    updatedFields['endTime'] = endTime.value;
    updatedFields['listOfServices'] = assignedServices;
    updatedFields['photoURL'] = photo.value;
    if (selectedDays.isNotEmpty) {
      updatedFields['days'] = Days;
    } else {
      updatedFields['days'] = originalStaff.days;
    }
    // if (!selectedDays.toSet().containsAll(originalStaff.days) ||
    //     !originalStaff.days.toSet().containsAll(selectedDays)) {
    //   updatedFields['days'] = selectedDays;
    // }

    // if (nameController.text != originalStaff.displayName) {
    //   updatedFields['displayName'] = nameController.text;
    // }
    // if (selectedRole.value != originalStaff.role) {
    //   updatedFields['role'] = selectedRole.value;
    // }

    // if (!selectedDays.toSet().containsAll(originalStaff.days) ||
    //     !originalStaff.days.toSet().containsAll(selectedDays)) {
    //   updatedFields['days'] = selectedDays;
    // }
    // if (startTime.value != originalStaff.startTime) {
    //   updatedFields['startTime'] = startTime.value;
    // }
    // if (endTime.value != originalStaff.endTime) {
    //   updatedFields['endTime'] = endTime.value;
    // }
    // // Compare assignedServices with original listOfServices
    // if (!ListEquality()
    //     .equals(assignedServices, originalStaff.listOfServices)) {
    //   updatedFields['listOfServices'] = assignedServices;
    // }
    // if (!ListEquality()
    //     .equals(assignedServices, originalStaff.listOfServices)) {
    //   updatedFields['listOfServices'] = assignedServices;
    // }

    if (updatedFields.isNotEmpty) {
      isActionLoading.value = true; // Start loading for the action
      try {
        await staffServices.updateStaffMember(originalStaff.uid, updatedFields);
        // selectedDays = <String>[].obs;
        // selectedRole = ''.obs;
        // startTime.value = '';
        // endTime.value = '';
        // photo.value = '';
        // nameController.clear();
        // assignedServices.clear();
// assignedServices = <String>[].obs;
        await fetchStaffData();
        isActionLoading.value = false; // Start loading for the action

        Get.back();
      } catch (e) {
        Get.snackbar('error'.tr,
            'could_not_update_staff_member'.trParams({'error': e.toString()}));
      } finally {
        isActionLoading.value = false; // Stop loading after action
      }
    } else {
      Get.snackbar('info'.tr, 'no_changes_to_save'.tr);
    }
  }

  Future<void> removeStaffMember(String uid) async {
    isActionLoading.value = true; // Start loading for the action
    try {
      await staffServices.removeStaffMember(uid);
      staffList.removeWhere((staff) => staff.uid == uid);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_remove_staff_member'.trParams({'error': e.toString()}));
    } finally {
      isActionLoading.value = false; // Stop loading after action
    }
  }
}
