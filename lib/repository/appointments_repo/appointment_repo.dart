import 'package:hair_salon/models/appointments/appoinment.dart';

abstract class IAppointmentRepository {
  Future<List<Appointment>> fetchAppointments();
  Future<bool> checkSlotAvailability({
    required String specialistUid,
    required DateTime selectedDate,
    required String selectedTime,
  });

  Future<void> saveAppointment(Appointment appointment);

  DateTime calculateNotificationTime(
      DateTime appointmentDate, String appointmentTime);
  Future<void> addToWaitingList(Appointment appointment,
      {required DateTime createdAt});
  Future<void> deleteAppointment(String appointmentId);
  Future<void> deleteAllAppointmentsForSpecificStaff(
      List<Appointment> appointments);
  Future<void> updateAppointment(Appointment appointment);
  cancelAppointment(String appointmentId);
  Future<void> cancelAllAppointments(String specialistUid);
  Future<void> cancelAppointmentFromWaitingList(Appointment appointment);
  Future<void> moveAppointmentToCancelAppointments(Appointment appointment);
  Future<void> moveAppointmentToCancel(Appointment appointment);
  Future<void> deleteAppointmentAndMoveToCancel(Appointment appointment);
}
