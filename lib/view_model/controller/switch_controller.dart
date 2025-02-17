import 'package:get/get.dart';
import 'package:hair_salon/models/appointments/appoinment.dart';

class SwitchController extends GetxController {
  RxBool initialvalue = Appointment.isRemindMe.obs;

  void changeSwitchValue(bool value) {
    initialvalue.value = value;
  }
}
