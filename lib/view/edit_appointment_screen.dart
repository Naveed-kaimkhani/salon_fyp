import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/models/appointments/appoinment.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/view_model/index.dart';
import '../repository/index.dart';
import 'book_appointment/index.dart';

class EditAppointmentScreen extends StatefulWidget {
  const EditAppointmentScreen({super.key});

  @override
  _EditAppointmentScreenState createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final Appointment appointment = Get.arguments['appointment'];
  final String specialistName = Get.arguments['specialist'];

  final String specialistUid = Get.arguments['specialistUid'];

  final ScrollController scrollController = ScrollController();
  final TreatmentCardController treatmentController = Get.find();
  final FirebaseAppointmentRepository appointmentService =
      FirebaseAppointmentRepository();
  final FirebaseAuthRepository authService = FirebaseAuthRepository();

  final RxBool isLoading = false.obs;
  final staffProvider = Get.find<StaffController>();

  StaffModel? selectedStaff;

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with current appointment data
    Get.find<DateSelectionController>().selectedDate.value = appointment.date;
    Get.find<TimeSelectionController>().selectedTime.value = appointment.time;
    treatmentController.selectedTreatment.value = appointment.appointmentFor;
    treatmentController.selectedDuration.value = appointment.duration;
    treatmentController.selectedPrice.value = appointment.charges;
    selectedStaff = staffProvider.staffList
        .firstWhereOrNull((staff) => staff.uid == specialistUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'edit_appointment'.tr,
        isLeadingNeed: true,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            if (selectedStaff != null)
              TreatmentSelection(
                staff: selectedStaff ?? StaffModel(),
              )
            else
              const Text("Staff not found"),
            const Gap(10),
            const Divider(),

            // Date Selection
            DateSelection(),
            const Gap(10),
            const Divider(),

            // Time Selection
            TimeSelection(
              scrollController: scrollController,
              specialistUid: appointment.specialistUid,
              specialistName: specialistName,
            ),
            const Gap(20),

            // Update Appointment Button
            Obx(() {
              return CustomGradientButton(
                text: 'update_appointment'.tr,
                onTap: () async {
                  isLoading.value = true;

                  final selectedDate =
                      Get.find<DateSelectionController>().selectedDate.value;
                  final selectedTime =
                      Get.find<TimeSelectionController>().selectedTime.value;
                  final selectedTreatment =
                      treatmentController.selectedTreatment.value;
                  final selectedDuration =
                      treatmentController.selectedDuration.value;
                  final price = treatmentController.selectedPrice.value;

                  if (selectedTreatment.isEmpty) {
                    Get.snackbar('error'.tr, 'please_select_treatment'.tr);
                    isLoading.value = false;
                    return;
                  }

                  // Fetch user details
                  final userDetails = await authService.fetchUserDetails();
                  if (userDetails == null) {
                    Get.snackbar('error'.tr, 'failed_to_fetch_user_details'.tr);
                    isLoading.value = false;
                    return;
                  }

                  // Check for slot availability if date or time has changed
                  if (selectedDate != appointment.date ||
                      selectedTime != appointment.time) {
                    final isAvailable =
                        await appointmentService.checkSlotAvailability(
                      specialistUid: appointment.specialistUid,
                      selectedDate: selectedDate,
                      selectedTime: selectedTime,
                      appointmentId: appointment.id,
                    );

                    if (!isAvailable) {
                      Get.snackbar(
                          'slot_unavailable'.tr, 'slot_unavailable_message'.tr);
                      isLoading.value = false;
                      return;
                    }
                  }

                  final recurringData = {
                    "isRecurring": Get.find<RecurringAppointmentController>()
                        .isRecurring
                        .value,
                    "frequency": Get.find<RecurringAppointmentController>()
                        .selectedFrequency
                        .value,
                  };

                  final updatedAppointment = Appointment(
                    isCancelled: false,
                    id: appointment.id,
                    date: selectedDate,
                    time: selectedTime,
                    stylist: specialistName,
                    specialistUid: appointment.specialistUid,
                    userUid: FirebaseAuth.instance.currentUser!.uid,
                    duration: selectedDuration,
                    charges: price,
                    appointmentFor: selectedTreatment,
                    isUpComing: true,
                    isWaiting: false,
                    gender: userDetails['gender'] ?? 'Unknown',
                    birthday: userDetails['birthday'] ?? 'Unknown',
                    phoneNumber: userDetails['phone'] ?? 'Unknown',
                    notificationTime:
                        appointmentService.calculateNotificationTime(
                      selectedDate,
                      selectedTime,
                    ),
                    serviceImageUrl: appointment.serviceImageUrl,
                    recurring: recurringData,
                  );

                  try {
                    if (appointment.isCancelled) {
                      // Rebooking logic for canceled appointment
                      await appointmentService
                          .rebookAppointment(updatedAppointment);
                    } else {
                      // Update the existing appointment
                      await appointmentService
                          .updateAppointment(updatedAppointment);
                    }

                    // Refresh Appointments List
                    Get.find<AppointmentProvider>().fetchAppointments();

                    // Navigate Back
                    Get.back();
                  } catch (e) {
                    Get.snackbar('error'.tr, e.toString());
                  } finally {
                    isLoading.value = false;
                  }
                },
                isLoading: isLoading.value.obs,
              );
            }),
          ],
        ),
      ),
    );
  }
}
