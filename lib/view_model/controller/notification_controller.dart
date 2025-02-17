import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Observable for notification count
  RxInt notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    listenToNotifications();
  }

  // Listen to unread notifications in Firestore
  void listenToNotifications() {
    final String? userUid = "currentUserId"; // Replace with actual user ID
    if (userUid == null) return;

    FirebaseFirestore.instance
        .collection('notifications')
        .where('userUid', isEqualTo: userUid)
        .where('isRead', isEqualTo: false) // Only count unread notifications
        .snapshots()
        .listen((snapshot) {
      notificationCount.value = snapshot.docs.length; // Update badge count
    });
  }

  // Clear notifications (mark all as read)
  Future<void> clearNotifications() async {
    final String? userUid = "currentUserId"; // Replace with actual user ID
    if (userUid == null) return;

    final unreadNotifications = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userUid', isEqualTo: userUid)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadNotifications.docs) {
      await doc.reference.update({'isRead': true}); // Mark as read
    }

    notificationCount.value = 0; // Clear badge count
  }
}
