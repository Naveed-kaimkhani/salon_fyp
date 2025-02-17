import 'package:get/get.dart';

class RecurringAppointmentController extends GetxController {
  var isRecurring = false.obs;
  var selectedFrequency = "Weekly".obs;

  // Method to toggle the switch
  void toggleRecurring(bool value) {
    isRecurring.value = value;
  }

  // Method to update the frequency
  void updateFrequency(String value) {
    selectedFrequency.value = value;
  }
}
