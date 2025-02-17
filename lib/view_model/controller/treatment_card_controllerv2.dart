import 'package:get/get.dart';

class TreatmentCardControllerV2 extends GetxController {
  var selectedPrice = 0.0.obs;  // Use RxInt to make selectedPrice reactive
  var selectedTreatment = ''.obs;
  var selectedDuration = ''.obs;
  var isChecked = false.obs;
  var uid=''.obs;
  // Method to select treatment with an int price
  void selectTreatment(String uid, String treatment, String duration, double price) {
    selectedTreatment.value = treatment;
    selectedDuration.value = duration;
    selectedPrice.value = price;  // Use .value to update RxInt
  }

  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }

  void clearSelection() {
    selectedTreatment.value = '';
    selectedDuration.value = '';
    selectedPrice.value = 0;  // Reset to 0
  }
}