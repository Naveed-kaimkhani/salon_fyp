
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/appointment_details_card.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/view/admin/admin.dart';
import 'package:hair_salon/view/book_appointment/date_selection.dart';
import 'package:hair_salon/view_model/controller/appointment_provider.dart';
import 'package:hair_salon/view_model/controller/date_selction_controller.dart';
import 'package:hair_salon/view_model/controller/switch_controller.dart';

class AllAppointmentsScreen extends StatelessWidget {
  final String uid; // Specialist UID for filtering
  AllAppointmentsScreen({super.key, required this.uid});

  final SwitchController switchController = Get.put(SwitchController());
  final DateSelectionController dateSelectionController = Get.find();
  final AppointmentProvider appointmentProvider = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "all_appointments".tr,
        isLeadingNeed: true,
      ),
      body: Column(
        children: [
          // Date selection component
          SizedBox(
            height: 160,
            child: DateSelection(isShowLabelText: false,),
          ),
          Expanded(
            child: Obx(() {
              if (appointmentProvider.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              // Filter appointments based on specialist UID and selected date
              final filteredAppointments = _filterAppointments();

              if (filteredAppointments.isEmpty) {
                return Center(
                  child: Text(
                    "no_appointments_available".tr,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = filteredAppointments[index];
                  return AppointmentDetailsCard(
                    appointment: appointment,
                    switchController: switchController,
                    onButtonTap: () => _navigateToAppointmentDetails(context, appointment),
                  );
                },
              );
            }),
          ),
          // Cancel appointments button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomGradientButton(
              text: "cancel_all_appointments".tr,
              isLoading: appointmentProvider.isLoading,
              onTap: () => appointmentProvider.deleteAllAppointmentsForSpecificStaff(uid),
            ),
          ),
        ],
      ),
    );
  }

  /// Filters appointments by specialist UID and selected date.
  List<dynamic> _filterAppointments() {
    final selectedDate = dateSelectionController.selectedDate.value;

    return appointmentProvider.appointmentsList.where((appointment) {
      final appointmentDate = appointment.date;
      final matchesSpecialist = appointment.specialistUid == uid;
      final matchesDate = selectedDate.isSameDate(appointmentDate);
      return matchesSpecialist && matchesDate && !appointment.isCancelled;
    }).toList();
  }

  /// Navigates to the appointment details screen.
  void _navigateToAppointmentDetails(BuildContext context, dynamic appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentDetailsScreen(appointment: appointment),
      ),
    );
  }
}

extension DateComparison on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
