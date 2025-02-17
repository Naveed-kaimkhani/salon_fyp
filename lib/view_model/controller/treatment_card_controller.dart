import 'package:get/get.dart';
class TreatmentCardController extends GetxController {
  var selectedPrice = 0.0.obs;
  var selectedTreatment = ''.obs;
  var selectedDuration = ''.obs;
  var isChecked = false.obs;
  var uid = ''.obs;
  var selectedImageUrl = ''.obs;
  var treatmentFor = ''.obs;

  // Method to select treatment
  void selectTreatment(String uid, String treatment, String duration,
      double price, String imageUrl, String gender) {
    selectedTreatment.value = treatment;
    selectedDuration.value = duration;
    selectedPrice.value = price;
    selectedImageUrl.value = imageUrl;
    treatmentFor.value = gender;
    this.uid.value = uid; // Update the UID for highlighting
  }

  void toggleCheckbox(bool value) {
    isChecked.value = value;
  }

  void clearSelection() {
    selectedTreatment.value = '';
    selectedDuration.value = '';
    selectedPrice.value = 0.0;
    selectedImageUrl.value = ''; // Reset the image URL
  }

  // Initialize with default values (first service)
  void initializeDefaultTreatment(String uid, String treatment, String duration,
      double price, String imageUrl, String gender) {
    selectedTreatment.value = treatment;
    selectedDuration.value = duration;
    selectedPrice.value = price;
    selectedImageUrl.value = imageUrl;
    treatmentFor.value = gender;
    this.uid.value = uid;
    
  }
}
