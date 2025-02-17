import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // If no user is logged in, show a message
    if (currentUser == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "notifications".tr,
          isLeadingNeed: true,
        ),
        body: Center(child: Text("please_log_in_to_view_notifications".tr)),
      );
    }

    return DefaultTabController(
      length: 2, // Two tabs: User Notifications and Broadcast Messages
      child: Scaffold(
        appBar: AppBar(
          title: Text("notifications".tr),
          bottom: TabBar(
            tabs: [
              Tab(text: "user_notifications".tr),
              Tab(text: "messages_by_admin".tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserNotificationsTab(currentUser),
            _buildBroadcastMessagesTab(),
          ],
        ),
      ),
    );
  }

  // Tab for User-Specific Notifications
  Widget _buildUserNotificationsTab(User currentUser) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userUid', isEqualTo: currentUser.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Error handling
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    "error_loading_notifications:".tr + "${snapshot.error}"));
          }

          // Show loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          // Handle case where no data is found
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("no_user_notifications_found".tr));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification =
                  notifications[index].data() as Map<String, dynamic>;
              String title = notification['title'] ?? 'no_title'.tr;
              String body = notification['body'] ?? 'no_body'.tr;
              Timestamp timestamp = notification['createdAt'];
              String timeAgo = _timeAgo(timestamp.toDate());
              return NotificationTileComponent(
                initials: _getInitials(title),
                title: title,
                subtitle: body,
                timeAgo: timeAgo,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBroadcastMessagesTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('broadcastMessages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Error handling
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    "error_loading_broadcast_messages: ${snapshot.error}".tr));
          }

          // Show loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          // Handle case where no data is found
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("no_broadcast_messages_found.".tr));
          }

          final broadcasts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: broadcasts.length,
            itemBuilder: (context, index) {
              final broadcast =
                  broadcasts[index].data() as Map<String, dynamic>;

              String title = broadcast['title'] ?? 'no_title'.tr;
              String body = broadcast['body'] ?? 'no_body'.tr;
              Timestamp timestamp = broadcast['createdAt'];
              String timeAgo = _timeAgo(timestamp.toDate());

              // Use NotificationTileComponent to display each broadcast message
              return NotificationTileComponent(
                initials: _getInitials(
                    title), // Assuming you want initials of the title
                title: title,
                subtitle: body,
                timeAgo: timeAgo,
              );
            },
          );
        },
      ),
    );
  }

  // Helper function to format time ago
  String _timeAgo(DateTime date) {
    final duration = DateTime.now().difference(date);
    if (duration.inDays > 0) return "${duration.inDays} " + "days_ago".tr;
    if (duration.inHours > 0) return "${duration.inHours} " + "hours_ago".tr;
    if (duration.inMinutes > 0)
      return "${duration.inMinutes} " + "minutes_ago".tr;
    return 'just_now'.tr;
  }

  // Helper function to get initials from a title (or any string)
  String _getInitials(String text) {
    List<String> nameParts = text.split(" ");
    String initials = "";
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0].toUpperCase();
    }
    if (nameParts.length > 1) {
      initials += nameParts[1][0].toUpperCase();
    }
    return initials.isNotEmpty ? initials : "n_a".tr;
  }
}
