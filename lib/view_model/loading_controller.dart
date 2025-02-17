import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs; // Observable boolean for loading state

  // // Example function to simulate loading
  // Future<void> submitForm() async {
  //   isLoading.value = true; // Start loading
  //   await Future.delayed(const Duration(seconds: 3)); // Simulate API call
  //   isLoading.value = false; // Stop loading
  // }

}
