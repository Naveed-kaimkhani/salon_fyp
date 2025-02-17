import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DateSelectionController extends GetxController {
  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());
  
  // Function to update the selected date
  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
  }
}
