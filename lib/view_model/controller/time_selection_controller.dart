import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TimeSelectionController extends GetxController {
  RxString selectedTime = ''.obs;
  RxList<String> availableTimes = <String>[].obs;

  // Update the selected time
  void updateSelectedTime(String time) {
    selectedTime.value = time;
  }

  // Update available times
  void updateAvailableTimes(List<String> times) {
    availableTimes.value = times;
  }
}
