import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedBottomNav = 0.obs;

  void changeBottomNav(int index) {
    selectedBottomNav.value = index;
  }
}
