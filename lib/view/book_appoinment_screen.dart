import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/index.dart';
import 'package:hair_salon/models/appointments/appoinment.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/repository/index.dart';
import 'package:hair_salon/view/book_appointment/index.dart';
import 'package:intl/intl.dart';

import '../view_model/index.dart';

class BookingAppointmentScreen extends StatefulWidget {
  BookingAppointmentScreen({super.key});

  @override
  State<BookingAppointmentScreen> createState() =>
      _BookingAppointmentScreenState();
}

class _BookingAppointmentScreenState extends State<BookingAppointmentScreen> {
  final Rx<StaffModel?> selectedSpecialist =
      Rx<StaffModel?>(Get.arguments as StaffModel?);

  final ScrollController scrollController = ScrollController();

  final TreatmentCardController treatmentController = Get.find();

  final FirebaseAppointmentRepository appointmentService =
      FirebaseAppointmentRepository();

  final FirebaseAuthRepository authService = FirebaseAuthRepository();

  final AppointmentProvider appointmentProvider = Get.find();

  final BlockedDatesProvider blockedDatesProvider = Get.find();

  // final TreatmentCardController treatmentController = Get.find();
  final RxBool isLoading = false.obs;
  // Loading state
  final timeController = Get.find<TimeSelectionController>();

  final DateSelectionController controller = Get.put(DateSelectionController());
  @override
  void dispose() {
    final TreatmentCardController treatmentController = Get.find();
    treatmentController.selectedTreatment.value = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "booking_details".tr,
        isLeadingNeed: true,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => SpecialistSelection(
                selectedSpecialist: selectedSpecialist.value,
                onSelectSpecialist: (specialist) {
                  treatmentController.selectedTreatment.value = '';
                  selectedSpecialist.value = specialist;
                })),
            const Gap(20),
            Obx(() => TreatmentSelection(
                  staff: selectedSpecialist.value ?? StaffModel(),
                )),
            const Gap(10),
            const Divider(),
            DateSelection(),
            const Gap(10),
            const Divider(),
            const Gap(10),
            TimeSelection(
              scrollController: scrollController,
              specialistUid: selectedSpecialist.value?.uid ?? '',
              specialistName:
                  selectedSpecialist.value?.displayName ?? 'Unknown Specialist',
            ),
            Gap(20),
            RecurringAppointment(),
            const Gap(20),
            CustomGradientButton(
              isLoading: isLoading,
              text: "book_appointment".tr,
              onTap: _handleBooking,
            ),
          ],
        ),
      ),
    );
  }

  /// Handles the booking logic.
  Future<void> _handleBooking() async {
    if (isLoading.value) return;
    isLoading.value = true;

    final currentSpecialist = selectedSpecialist.value;
    if (!_validateInputs(currentSpecialist)) {
      isLoading.value = false;
      return;
    }

    final userDetails = await _fetchUserDetails();
    if (userDetails == null) {
      isLoading.value = false;
      return;
    }

    await blockedDatesProvider.fetchBlockedDates();
    if (_isDateBlocked()) {
      isLoading.value = false;
      return;
    }

    if (!await _checkSlotAvailability(currentSpecialist!.uid)) {
      isLoading.value = false;
      return;
    }

    await _saveAppointment(currentSpecialist, userDetails);
    isLoading.value = false;
  }

  /// Validates user inputs.
  bool _validateInputs(StaffModel? currentSpecialist) {
    if (currentSpecialist == null) {
      Get.snackbar("error".tr, "error_select_specialist".tr);
      return false;
    }
    String dayName = DateFormat('EEEE')
        .format(controller.selectedDate.value); // Full day name
    String dayPrefix = dayName.substring(0, 2); // First two characters

    // Check if the selected day prefix is in the list of available days
    if (!selectedSpecialist.value!.days.contains(dayPrefix)) {
      // Show a dialog if the day is unavailable
      Get.snackbar(
        'day_unavailable'.tr,
        'staff_is_not _available_for_selected_day'.tr,
      );
      return false;
    }

    final selectedTreatment = treatmentController.selectedTreatment.value;
    if (selectedTreatment.isEmpty) {
      Get.snackbar("error".tr, "please_select_treatment".tr);
      return false;
    }
    final selectedTime = timeController.selectedTime.value;
    if (selectedTime.isEmpty) {
      Get.snackbar("error".tr, "please_select_time".tr);
      return false;
    }
    return true;
  }

  /// Fetches user details from the auth service.
  Future<Map<String, dynamic>?> _fetchUserDetails() async {
    final userDetails = await authService.fetchUserDetails();
    if (userDetails == null) {
      Get.snackbar("error".tr, "failed_to_fetch_user_details".tr);
    }
    return userDetails;
  }

  /// Checks if the selected date is blocked.
  bool _isDateBlocked() {
    final selectedDate = Get.find<DateSelectionController>().selectedDate.value;
    final selectedTime = Get.find<TimeSelectionController>().selectedTime.value;
    final blockedDatesList = blockedDatesProvider.blockedDatesList;

    for (var blockedDate in blockedDatesList) {
      final blockedDateTime = DateTime.parse(blockedDate.date);

      if (_isSameDate(selectedDate, blockedDateTime) &&
          _isTimeWithinInterval(
            _parseTime(selectedTime),
            _parseTime(blockedDate.startTime),
            _parseTime(blockedDate.endTime),
          )) {
        Get.snackbar("date_blocked".tr, "date_blocked_message".tr);
        return true;
      }
    }
    return false;
  }

  /// Checks slot availability with the backend.
  Future<bool> _checkSlotAvailability(String specialistUid) async {
    final selectedDate = Get.find<DateSelectionController>().selectedDate.value;
    final selectedTime = Get.find<TimeSelectionController>().selectedTime.value;

    final isAvailable = await appointmentService.checkSlotAvailability(
      specialistUid: specialistUid,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
    );

    if (!isAvailable) {
      Get.snackbar("slot_already_booked".tr, "slot_already_booked_message".tr);
    }
    return isAvailable;
  }

  /// Saves the appointment.
  Future<void> _saveAppointment(
      StaffModel specialist, Map<String, dynamic> userDetails) async {
    final selectedDate = Get.find<DateSelectionController>().selectedDate.value;
    final selectedTime = Get.find<TimeSelectionController>().selectedTime.value;

    final recurringController = Get.find<RecurringAppointmentController>();
    final appointment = Appointment(
      id: '',
      date: selectedDate,
      time: selectedTime,
      stylist: specialist.displayName,
      specialistUid: specialist.uid,
      userUid: FirebaseAuth.instance.currentUser!.uid,
      duration: treatmentController.selectedDuration.value,
      charges: treatmentController.selectedPrice.value,
      appointmentFor: treatmentController.selectedTreatment.value,
      isUpComing: true,
      isWaiting: false,
      gender: userDetails['gender'] ?? 'Unknown',
      birthday: userDetails['birthday'] ?? 'Unknown',
      phoneNumber: userDetails['phone'] ?? 'Unknown',
      notificationTime: appointmentService.calculateNotificationTime(
          selectedDate, selectedTime),
      serviceImageUrl: treatmentController.selectedImageUrl.value,
      recurring: {
        "isRecurring": recurringController.isRecurring.value,
        "frequency": recurringController.selectedFrequency.value,
      },
    );

    await appointmentService.saveAppointment(appointment);
    Get.toNamed(RouteName.bookingConfirmedScreen, arguments: {
      'isWaitlisted': false,
      'specialistName': specialist.displayName,
      'selectedDate': selectedDate,
      'selectedTime': selectedTime,
    });
  }

  /// Parses a time string into a [TimeOfDay].
  TimeOfDay _parseTime(String timeString) {
    final timeParts = timeString.split(' ');
    final period = timeParts[1];
    final time = timeParts[0].split(':');

    final hours = int.tryParse(time[0]) ?? 0;
    final minutes = int.tryParse(time[1]) ?? 0;

    final adjustedHours = period == 'PM' && hours != 12
        ? hours + 12
        : (period == 'AM' && hours == 12 ? 0 : hours);

    return TimeOfDay(hour: adjustedHours, minute: minutes);
  }

  /// Checks if two dates are the same.
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Checks if a time falls within a specific interval.
  bool _isTimeWithinInterval(
      TimeOfDay time, TimeOfDay startTime, TimeOfDay endTime) {
    final now = DateTime.now();
    final timeToCheck =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final start = DateTime(
        now.year, now.month, now.day, startTime.hour, startTime.minute);
    final end =
        DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

    return (timeToCheck.isAtSameMomentAs(start) ||
            timeToCheck.isAfter(start)) &&
        (timeToCheck.isAtSameMomentAs(end) || timeToCheck.isBefore(end));
  }
}
