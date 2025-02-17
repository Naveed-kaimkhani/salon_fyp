import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BroadcastMessageDialog extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('broadcast_message'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "title".tr),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: bodyController,
            decoration: InputDecoration(labelText: "message".tr),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("cancel".tr),
        ),
        ElevatedButton(
          onPressed: () async {
            final title = titleController.text.trim();
            final body = bodyController.text.trim();

            if (title.isEmpty || body.isEmpty) {
              Get.snackbar("error".tr, "title_and_message_cannot_be_empty".tr);
              return;
            }

            try {
              await FirebaseFirestore.instance
                  .collection('broadcastMessages')
                  .add({
                'title': title,
                'body': body,
                'createdAt': FieldValue.serverTimestamp(),
              });
              Get.back();
              Get.snackbar("success".tr, "broadcast_message_sent".tr);
            } catch (e) {
              Get.snackbar("error".tr, "failed_to_send_broadcast".tr + "$e");
            }
          },
          child: Text("send".tr),
        ),
      ],
    );
  }
}
