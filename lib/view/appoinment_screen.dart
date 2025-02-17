import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/app_colors.dart';
import 'package:hair_salon/models/appointments/appoinment.dart';
import 'package:hair_salon/view_model/controller/appointment_provider.dart';
import 'package:hair_salon/view_model/controller/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Timestamp

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({super.key});

  final SwitchController switchController = Get.put(SwitchController());
  final MyTabController appointmentScreenTabController =
      Get.put(MyTabController(3));

  final appointProvider = Get.find<AppointmentProvider>();
  final List<Tab> tabs = [
    Tab(text: 'upcoming'.tr),
    Tab(text: 'completed'.tr),
    Tab(text: 'cancelled'.tr),
  ];

  @override
  Widget build(BuildContext context) {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'my_appointments'.tr,
          isLeadingNeed: true,
        ),
        body: Center(
          child: Text('user_not_logged_in'.tr),
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'my_appointments'.tr,
          isLeadingNeed: false,
        ),
        body: Column(
          children: [
            Container(
              color: AppColors.white,
              child: TabBar(
                controller: appointmentScreenTabController.tabController,
                onTap: (index) =>
                    appointmentScreenTabController.changeTab(index),
                indicator: UnderlineTabIndicator(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  borderSide: BorderSide(
                    width: 6.0,
                    color: AppColors.appGradientColors.first,
                  ),
                  insets: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width / 5),
                ),
                labelColor: AppColors.black,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelColor: AppColors.mediumGrey,
                tabs: tabs,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: appointmentScreenTabController.tabController,
                children: [
                  // Upcoming Appointments Tab
                  UpcomingAppointmentsWidget(currentUserUid),

                  // Completed Appointments Tab
                  completedAppointmentsWidget(currentUserUid),

                  // Cancelled Appointments Tab
                  cancelledAppointmentsWidget(currentUserUid),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Upcoming Appointments Widget
  StreamBuilder<List<Appointment>> UpcomingAppointmentsWidget(
      String currentUserUid) {
    return StreamBuilder<List<Appointment>>(
      stream:
          Get.find<AppointmentProvider>().streamAppointments(currentUserUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(
              child:
                  Text('error'.trParams({'error': snapshot.error.toString()})));
        }

        final appointments = snapshot.data ?? [];
        final now = DateTime.now();

        final upcomingAppointments = appointments.where((appointment) {
          try {
            // Convert Firebase Timestamp to DateTime
            final appointmentDate = appointment.date is Timestamp
                ? (appointment.date as Timestamp).toDate()
                : appointment.date;

            // Parse `appointment.time` if it's a string
            final timeParts =
                appointment.time.split(' '); // Split into "5:30" and "PM"
            final period = timeParts[1]; // AM or PM
            final time = timeParts[0].split(':'); // Split hours and minutes
            final hours = int.tryParse(time[0]) ?? 0;
            final minutes = int.tryParse(time[1]) ?? 0;

            // Adjust hours for AM/PM
            final adjustedHours = period == 'PM' && hours != 12
                ? hours + 12
                : (period == 'AM' && hours == 12 ? 0 : hours);

            // Combine date and parsed time
            final appointmentDateTime = DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
              adjustedHours,
              minutes,
            );

            // Check if the appointment is in the future
            return appointmentDateTime.isAfter(now) &&
                appointment.isCancelled == false;
          } catch (e) {
            return false;
          }
        }).toList();

        if (upcomingAppointments.isEmpty) {
          return Center(child: Text('no_upcoming_appointments'.tr));
        }

        return buildAppointmentList(
          appointments: upcomingAppointments,
          switchController: switchController,
        );
      },
    );
  }

  // Completed Appointments Widget
  StreamBuilder<List<Appointment>> completedAppointmentsWidget(
      String currentUserUid) {
    return StreamBuilder<List<Appointment>>(
      stream:
          Get.find<AppointmentProvider>().streamAppointments(currentUserUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(
              child:
                  Text('error'.trParams({'error': snapshot.error.toString()})));
        }

        final appointments = snapshot.data ?? [];
        final now = DateTime.now();

        final completedAppointments = appointments.where((appointment) {
          try {
            // Convert Firebase Timestamp to DateTime
            final appointmentDate = appointment.date is Timestamp
                ? (appointment.date as Timestamp).toDate()
                : appointment.date;

            // Parse `appointment.time` if it's a string
            final timeParts = appointment.time.split(' ');
            final period = timeParts[1]; // AM or PM
            final time = timeParts[0].split(':'); // Split hours and minutes
            final hours = int.tryParse(time[0]) ?? 0;
            final minutes = int.tryParse(time[1]) ?? 0;

            // Adjust hours for AM/PM
            final adjustedHours = period == 'PM' && hours != 12
                ? hours + 12
                : (period == 'AM' && hours == 12 ? 0 : hours);

            // Combine date and parsed time
            final appointmentDateTime = DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
              adjustedHours,
              minutes,
            );

            // Check if the appointment is completed
            return appointmentDateTime.isBefore(now);
          } catch (e) {
            return false;
          }
        }).toList();

        if (completedAppointments.isEmpty) {
          return Center(child: Text('no_completed_appointments'.tr));
        }

        return ListView.builder(
          itemCount: completedAppointments.length,
          itemBuilder: (context, index) {
            return AppointmentCard(
              isShowCancel: false,
              onButtonTap: () {
                Get.toNamed(
                  '/edit_appointment',
                  arguments: {
                    'appointment':
                        completedAppointments[index], // Pass the appointment
                    'specialist': completedAppointments[index]
                        .stylist, // Pass the specialist data

                    'specialistUid': completedAppointments[index].specialistUid,
                  },
                );
              },
              appointment: completedAppointments[index],
              switchController: switchController,
            );
          },
        );
      },
    );
  }

  StreamBuilder<List<Appointment>> cancelledAppointmentsWidget(
      String currentUserUid) {
    return StreamBuilder<List<Appointment>>(
      stream: Get.find<AppointmentProvider>().streamCancelledAppointments(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(
              child:
                  Text('error'.trParams({'error': snapshot.error.toString()})));
        }

        // Get all cancelled appointments
        final cancelledAppointments = snapshot.data ?? [];

        // Filter cancelled appointments for the current user
        final userCancelledAppointments =
            cancelledAppointments.where((appointment) {
          return appointment.userUid == currentUserUid;
        }).toList();

        if (userCancelledAppointments.isEmpty) {
          return Center(child: Text('no_cancelled_appointments'.tr));
        }

        return ListView.builder(
          itemCount: userCancelledAppointments.length,
          itemBuilder: (context, index) {
            return AppointmentCard(
              isShowCancel: false,
              onButtonTap: () {
                Get.toNamed(
                  '/edit_appointment',
                  arguments: {
                    'appointment': userCancelledAppointments[
                        index], // Pass the appointment
                    'specialist': userCancelledAppointments[index]
                        .stylist, // Pass the specialist data
                    'specialistUid':
                        userCancelledAppointments[index].specialistUid,
                  },
                );
              },
              appointment: userCancelledAppointments[index],
              switchController: switchController,
            );
          },
        );
      },
    );
  }

  // This widget renders the appointment list
  Widget buildAppointmentList({
    required List<Appointment> appointments,
    required SwitchController switchController,
  }) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(
          isShowCancel: true,
          onButtonTap: () {
            appointProvider
                .deleteAppointmentAndMoveToCancel(appointments[index]);
          },
          appointment: appointments[index],
          switchController: switchController,
        );
      },
    );
  }
}
