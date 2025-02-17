import 'package:get/get.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var dateOfBirth = ''.obs;
  var gender = 'Gender'.obs;
  var isLoading = false.obs;

  final FirebaseAuthRepository _authRepository = FirebaseAuthRepository();

  // Fetch user data
  Future<void> fetchUserData() async {
    try {
      isLoading(true);
      final userDetails = await _authRepository.fetchUserDetails();

      if (userDetails != null) {
        name.value = userDetails['name'] ?? '';
        dateOfBirth.value = userDetails['birthday'] ?? '';
        gender.value = userDetails['gender'] ?? 'gender'.tr;
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_fetch_user_data'.tr);
    } finally {
      isLoading(false);
    }
  }

  // Update user data
  Future<void> updateUserData() async {
    try {
      isLoading(true);
      final updatedData = {
        'name': name.value.trim(),
        'birthday': dateOfBirth.value.trim(),
        'gender': gender.value,
      };
      await _authRepository.updateUserData(updatedData);
      Get.snackbar('success'.tr, 'profile_updated'.tr);
    } catch (e) {
      Get.snackbar('error'.tr, 'update_failed'.tr);
    } finally {
      isLoading(false);
    }
  }
}
