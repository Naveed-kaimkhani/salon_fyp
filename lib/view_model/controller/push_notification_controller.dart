import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PushNotificationController extends GetxController {
  // Reactive variables
  RxBool isReminderEnabled = false.obs;
  RxBool isChangeNotificationEnabled = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationSettings();
  }

  // Fetch the current settings from Firestore
  void fetchNotificationSettings() async {
    try {
      final doc = await _firestore
          .collection('settings')
          .doc('notification_settings')
          .get();

      if (doc.exists) {
        final data = doc.data();
        isReminderEnabled.value = data?['isReminderEnabled'] ?? false;
        isChangeNotificationEnabled.value =
            data?['isChangeNotificationEnabled'] ?? false;
      }
    } catch (e) {
    }
  }

  // Update a specific notification setting in Firestore
  void updateNotificationSetting(String field, bool value) async {
    try {
      await _firestore
          .collection('settings')
          .doc('notification_settings')
          .update({field: value});

      // Update the local reactive variable
      if (field == 'isReminderEnabled') {
        isReminderEnabled.value = value;
      } else if (field == 'isChangeNotificationEnabled') {
        isChangeNotificationEnabled.value = value;
      }
    } catch (e) {
    }
  }
}
