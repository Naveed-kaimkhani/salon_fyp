import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/appointments/appoinment.dart';
import 'package:hair_salon/repository/appointments_repo/firebase_appoint_repo.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class TimeSelection extends StatefulWidget {
  TimeSelection({
    super.key,
    required this.scrollController,
    required this.specialistUid,
    required this.specialistName,
  });

  final ScrollController scrollController;
  final String specialistUid;
  final String specialistName;

  @override
  State<TimeSelection> createState() => _TimeSelectionState();
}

class _TimeSelectionState extends State<TimeSelection> {
  final TimeSelectionController controller = Get.put(TimeSelectionController());
  final DateSelectionController dateSelectionController =
      Get.find<DateSelectionController>();
  final FirebaseAuthRepository authService = FirebaseAuthRepository();

  // Generate time slots based on the selected date
  List<String> _generateTimeSlots(DateTime selectedDate) {
    List<String> timeSlots = [];
    DateTime now = DateTime.now();

    DateTime initialTime;
    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      initialTime = now.minute >= 30
          ? DateTime(now.year, now.month, now.day, now.hour + 1, 0)
          : DateTime(now.year, now.month, now.day, now.hour, 30);
    } else {
      initialTime = DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 0, 0);
    }

    DateTime endOfDay = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59);

    while (initialTime.isBefore(endOfDay)) {
      timeSlots.add(formatTime(initialTime));

      // timeSlots.add(extractTime24Hr(initialTime));

      initialTime = initialTime.add(const Duration(minutes: 30));
    }

    return timeSlots;
  }

  String formatTime(DateTime time) {
    return "${time.hour % 12 == 0 ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  void initState() {
    super.initState();

    // Set today's date as the default selected date
    final today = DateTime.now();
    dateSelectionController.updateSelectedDate(today);

    // Generate initial time slots for today
    final initialTimeSlots = _generateTimeSlots(today);
    controller.updateAvailableTimes(initialTimeSlots);
  }

  @override
  Widget build(BuildContext context) {
    dateSelectionController.selectedDate.listen((selectedDate) {
      final times = _generateTimeSlots(selectedDate);
      controller.updateAvailableTimes(times);
    });

    final firebaseAppointmentRepo = Get.find<FirebaseAppointmentRepository>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelText(
              text: 'select_time'.tr,
              weight: FontWeight.w600,
              fontSize: AppFontSize.xmedium,
            ),
            InkWell(
              onTap: () => _showBottomSheet(context, firebaseAppointmentRepo),
              child: LabelText(
                text: 'join_waiting_list'.tr,
                fontSize: AppFontSize.xsmall,
                weight: FontWeight.w400,
                textColor: AppColors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: Obx(() {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.availableTimes.length,
              itemBuilder: (context, index) {
                final time = controller.availableTimes[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Obx(() => ChoiceChip(
                        label: Text(Utills.convertTo24Hour(time)),
                        selected: controller.selectedTime.value == time,
                        onSelected: (isSelected) {
                          if (isSelected) {
                            controller.updateSelectedTime(time);
                            if (widget.scrollController.hasClients) {
                              widget.scrollController.animateTo(
                                widget
                                    .scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            }
                          }
                        },
                        selectedColor: AppColors.purple,
                        backgroundColor: AppColors.white,
                        labelStyle: TextStyle(
                          color: controller.selectedTime.value == time
                              ? AppColors.white
                              : AppColors.purple,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context,
      FirebaseAppointmentRepository firebaseAppointmentRepo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LabelText(
                  text: 'waiting_list'.tr,
                  fontSize: AppFontSize.medium,
                  weight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('waitinglist')
                        .where('specialistUid', isEqualTo: widget.specialistUid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text('no_users_in_waiting_list'.tr));
                      }

                      final waitingList = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: waitingList.length,
                        itemBuilder: (context, index) {
                          final user = waitingList[index].data();
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.purple,
                              child: Text(
                                _getUserInitials(user["userName"] ?? "Unknown"),
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(user["userName"] ?? "Unknown"),
                            subtitle:
                                Text("Time: ${user["time"] ?? "Not Set"}"),
                          );
                        },
                      );
                    },
                  ),
                ),
                CustomGradientButton(
                  isLoading: false.obs,
                  text: 'add_to_list'.tr,
                  onTap: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    final userDetails = await authService.fetchUserDetails();
                    if (currentUser != null && userDetails != null) {
                      final existingAppointmentQuery = await FirebaseFirestore
                          .instance
                          .collection('appointments')
                          .where('specialistUid',
                              isEqualTo: widget.specialistUid)
                          .where('userUid', isEqualTo: currentUser.uid)
                          .where('time',
                              isEqualTo: controller.selectedTime.value)
                          .get();

                      if (existingAppointmentQuery.docs.isNotEmpty) {
                        Get.snackbar(
                          'info'.tr,
                          'already_have_appointment'.tr,
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }

                      final existingUserQuery = await FirebaseFirestore.instance
                          .collection('waitinglist')
                          .where('specialistUid',
                              isEqualTo: widget.specialistUid)
                          .where('userUid', isEqualTo: currentUser.uid)
                          .where('time',
                              isEqualTo: controller.selectedTime.value)
                          .get();

                      if (existingUserQuery.docs.isNotEmpty) {
                        Get.snackbar(
                          'info'.tr,
                          'already_in_waiting_list'.tr,
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }
                      if (controller.selectedTime.value.isEmpty) {
                        Get.snackbar("error".tr, "please_select_time".tr);
                        return;
      }

                      final appointment = Appointment(
                        id: '',
                        date: dateSelectionController.selectedDate.value,
                        time: controller.selectedTime.value,
                        stylist: widget.specialistName,
                        specialistUid: widget.specialistUid,
                        userUid: currentUser.uid,
                        duration: Get.find<TreatmentCardController>()
                            .selectedDuration
                            .value,
                        charges: Get.find<TreatmentCardController>()
                            .selectedPrice
                            .value
                            .toDouble(),
                        appointmentFor: Get.find<TreatmentCardController>()
                            .selectedTreatment
                            .value,
                        isUpComing: true,
                        isWaiting: true,
                        gender: userDetails['gender'] ?? "Unknown",
                        birthday: userDetails['birthday'] ?? "Unknown",
                        phoneNumber: userDetails['phone'] ?? "Unknown",
                        notificationTime: DateTime.now(),
                        serviceImageUrl: Get.find<TreatmentCardController>()
                            .selectedImageUrl
                            .value,
                        recurring: {
                          "isRecurring":
                              Get.find<RecurringAppointmentController>()
                                  .isRecurring
                                  .value,
                          "frequency":
                              Get.find<RecurringAppointmentController>()
                                  .selectedFrequency
                                  .value,
                        },
                      );

                      await firebaseAppointmentRepo.addToWaitingList(
                          appointment,
                          createdAt: DateTime.now());

                      Navigator.pop(context);
                    } else {
                      Get.snackbar(
                        'error'.tr,
                        'error_fetching_user_details'.tr,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String _getUserInitials(String name) {
    List<String> nameParts = name.split(" ");
    String initials = "";
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0].toUpperCase();
    }
    if (nameParts.length > 1) {
      initials += nameParts[1][0].toUpperCase();
    }
    return initials;
  }
}
