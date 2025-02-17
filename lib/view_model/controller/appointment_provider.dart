import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hair_salon/models/appointments/appoinment.dart';
import 'package:hair_salon/repository/appointments_repo/appointment_repo.dart';

class AppointmentProvider extends GetxController {
  var appointmentsList = <Appointment>[].obs; // Reactive list for appointments
  var isLoading = true.obs; // Loading state

  final IAppointmentRepository _appointmentRepo;

  // Constructor
  AppointmentProvider({required IAppointmentRepository appointmentRepo})
      : _appointmentRepo = appointmentRepo;

  // Fetch appointments for a specific user
  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true; // Show loading
      final fetchedAppointments =
          await _appointmentRepo.fetchAppointments(); // Fetch appointments
      appointmentsList.value =
          fetchedAppointments; // Update appointments list reactively
      isLoading.value = false; // Hide loading once data is fetched
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

//add a delete appointments function to delete appointments
  Future<void> deleteAppointment(Appointment appointment) async {
    try {
      isLoading.value = true;
      await _appointmentRepo.deleteAppointment(appointment.id);

      appointmentsList.removeWhere((element) => element.id == appointment.id);
      isLoading.value = false;
      Get.snackbar('success'.tr, 'appointment_deleted_successfully'.tr);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }

  Future<void> deleteAppointmentAndMoveToCancel(Appointment appointment) async {
    try {
      isLoading.value = true;
      await _appointmentRepo.deleteAppointmentAndMoveToCancel(appointment);

      appointmentsList.removeWhere((element) => element.id == appointment.id);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }

  //add a delete appointments function to delete appointments
  Future<void> deleteAllAppointmentsForSpecificStaff(
      String specialistId) async {
    try {
      isLoading.value = true;
      await _appointmentRepo.cancelAllAppointments(specialistId);
      appointmentsList
          .removeWhere((element) => element.specialistUid == specialistId);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _appointmentRepo.cancelAppointment(appointmentId);
    } catch (e) {
      // Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }

  Stream<List<Appointment>> streamCancelledAppointments() {
    return FirebaseFirestore.instance
        .collection('cancel_appointments')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromFirestore(doc.data()))
            .toList());
  }

  Future<void> cancelAppointmentFromWaitingList(Appointment appointment) async {
    try {
      await _appointmentRepo.cancelAppointmentFromWaitingList(appointment);
    } catch (e) {
      // Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }

  Stream<List<Appointment>> streamAppointments(String userUid) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('userUid', isEqualTo: userUid) // Filter by user UID
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromFirestore(doc.data()))
            .toList());
  }

  @override
  void onInit() {
    super.onInit();
    fetchAppointments(); // Fetch appointments immediately when controller is initialized
  }
}
