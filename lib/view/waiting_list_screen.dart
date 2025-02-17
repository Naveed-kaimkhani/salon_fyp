import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/models/models.dart';
import 'package:hair_salon/view_model/controller/appointment_provider.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class WaitingListScreen extends StatelessWidget {
  WaitingListScreen({super.key});

  final SwitchController switchController = Get.put(SwitchController());

  final appointProvider = Get.find<AppointmentProvider>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'my_waiting_list'.tr,
        isLeadingNeed: false,
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: _getUserWaitingListStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("error".tr + " " + "something_went_wrong".tr));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('no_waiting_list_found'.tr));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final appointment = snapshot.data![index];
              return AppointmentCard(
                appointment: appointment,
                switchController: switchController,
                isShowCancel: true,
                onButtonTap: () {
                  appointProvider.cancelAppointmentFromWaitingList(appointment);
                },
              );
            },
          );
        },
      ),
    );
  }

  /// Fetch real-time waiting list data for the current user
  Stream<List<Appointment>> _getUserWaitingListStream() {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        Get.snackbar('error'.tr, 'user_not_logged_in'.tr);
        return const Stream.empty();
      }

      return FirebaseFirestore.instance
          .collection('waitinglist')
          .where('userUid', isEqualTo: currentUser.uid) // Filter by userUid
          .orderBy('createdAt',
              descending: false) // Sort by createdAt ascending
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();

          // Handle parsing of appointment fields
          return Appointment.fromFirestore(data);
        }).toList();
      });
    } catch (e) {
      Get.snackbar('error'.tr, 'failed_to_fetch_waiting_list'.tr + '$e');
      return const Stream.empty();
    }
  }
}
