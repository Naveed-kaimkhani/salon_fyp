import 'package:get/get.dart';

class PasswordController extends GetxController {
  var isObscure = true.obs;

  void toggleVisibility() {
    isObscure.value = !isObscure.value;
  }
}
