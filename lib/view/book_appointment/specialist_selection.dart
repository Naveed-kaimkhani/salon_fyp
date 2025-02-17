// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:hair_salon/components/components.dart';
// import 'package:hair_salon/constants/constants.dart';
// import 'package:hair_salon/models/staff/staff_model.dart';
// import 'package:hair_salon/view_model/controller/staff_controller.dart';
// import 'package:shimmer/shimmer.dart';

// class SpecialistSelection extends StatelessWidget {
//   final StaffModel? selectedSpecialist;
//   final Function(StaffModel) onSelectSpecialist;

//   const SpecialistSelection({
//     super.key,
//     required this.selectedSpecialist,
//     required this.onSelectSpecialist,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final StaffController staffProvider =
//         Get.find<StaffController>(); // Get the provider

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         LabelText(
//           text: 'choose_your_specialist'.tr,
//           weight: FontWeight.w600,
//           fontSize: AppFontSize.xmedium,
//         ),
//         const Gap(10),
//         Obx(() {
//           if (staffProvider.isLoading.value) {
//             return const CircularProgressIndicator
//                 .adaptive(); // Show a loading indicator
//           } else if (staffProvider.staffList.isEmpty) {
//             return Text("no_specialists_available".tr);
//           } else {
//            List<StaffModel> filterStaff = staffProvider.staffList.where((staff) {
//   // Check if the staff member has days and services
//   if (staff.days.isEmpty || staff.listOfServices.isEmpty) {
//     return false;
//   }

//   // Check if startTime or endTime is empty
//   if (staff.startTime.isEmpty || staff.endTime.isEmpty) {
//     return false;
//   }

//   try {
//     final now = DateTime.now();

//     // Extract hours and minutes from startTime and endTime
//     final startParts = staff.startTime.split(' '); // Split "1:25 PM" into ["1:25", "PM"]
//     final endParts = staff.endTime.split(' ');

//     final startHourMinute =
//         startParts[0].split(':'); // Split "1:25" into ["1", "25"]
//     final endHourMinute = endParts[0].split(':');

//     int startHour = int.parse(startHourMinute[0]);
//     final int startMinute = int.parse(startHourMinute[1]);
//     int endHour = int.parse(endHourMinute[0]);
//     final int endMinute = int.parse(endHourMinute[1]);

//     // Adjust hours for PM times
//     if (startParts[1] == 'PM' && startHour != 12) {
//       startHour += 12;
//     } else if (startParts[1] == 'AM' && startHour == 12) {
//       startHour = 0;
//     }

//     if (endParts[1] == 'PM' && endHour != 12) {
//       endHour += 12;
//     } else if (endParts[1] == 'AM' && endHour == 12) {
//       endHour = 0;
//     }

//     // Combine parsed times with today's date
//     final startTimeToday =
//         DateTime(now.year, now.month, now.day, startHour, startMinute);
//     var endTimeToday =
//         DateTime(now.year, now.month, now.day, endHour, endMinute);

//     // If endTime is earlier than startTime, it means it is after midnight (next day)
//     if (endTimeToday.isBefore(startTimeToday)) {
//       endTimeToday = endTimeToday.add(const Duration(days: 1));
//     }

//     // Check if the current time is within the range
//     return now.isAfter(startTimeToday) && now.isBefore(endTimeToday);
//   } catch (e) {
//     // debugPrint("Error parsing time for staff ${staff.name}: $e");
//     return false; // Default to unavailable if there's an error
//   }
// }).toList();
//             return SizedBox(
//               height: 151,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount:filterStaff.length,
//                 itemBuilder: (context, index) {
//                   final staff = filterStaff[index];
//                   bool isSelected =
//                       selectedSpecialist?.uid == staff.uid; // Check if selected

//                   return GestureDetector(
//                     onTap: () => onSelectSpecialist(
//                         staff,
//                         ), // Notify parent of the selection
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 12),
//                       child: Column(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                 color: isSelected
//                                     ? Colors.green
//                                     : AppColors
//                                         .lightGrey, // Green border if selected
//                               ),
//                               color: isSelected
//                                   ? Colors.green.withOpacity(0.1)
//                                   : Colors
//                                       .transparent, // Optional green background
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: [
//                                   CachedNetworkImage(
//                                     imageUrl: staff.photoURL,
//                                     placeholder: (context, url) =>
//                                         Shimmer.fromColors(
//                                       baseColor: Colors.grey[300]!,
//                                       highlightColor: Colors.grey[100]!,
//                                       child: Container(
//                                         width: 95,
//                                         height: 90,
//                                         color: Colors.grey[300],
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) =>
//                                         const Icon(Icons.error), // Error icon
//                                     imageBuilder: (context, imageProvider) =>
//                                         Container(
//                                       width: 80,
//                                       height: 80,
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   const Gap(5),
//                                   LabelText(
//                                     text: staff.displayName,
//                                     weight: FontWeight.w600,
//                                     fontSize: AppFontSize.small,
//                                   ),
//                                   LabelText(
//                                     text: staff.role.tr,
//                                     weight: FontWeight.w400,
//                                     fontSize: AppFontSize.xsmall,
//                                     textColor: AppColors.mediumGrey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         }),
//       ],
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/view_model/controller/staff_controller.dart';
import 'package:shimmer/shimmer.dart';

class SpecialistSelection extends StatelessWidget {
  final StaffModel? selectedSpecialist;
  final Function(StaffModel) onSelectSpecialist;

  const SpecialistSelection({
    super.key,
    required this.selectedSpecialist,
    required this.onSelectSpecialist,
  });

  @override
  Widget build(BuildContext context) {
    final StaffController staffProvider = Get.find<StaffController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          text: 'choose_your_specialist'.tr,
          weight: FontWeight.w600,
          fontSize: AppFontSize.xmedium,
        ),
        const Gap(10),
        Obx(() {
          if (staffProvider.isLoading.value) {
            return const CircularProgressIndicator.adaptive();
          } else if (staffProvider.staffList.isEmpty) {
            return Text("no_specialists_available".tr);
          } else {
            final List<StaffModel> filterStaff = _filterAvailableStaff(staffProvider.staffList);

            return SizedBox(
              height: 151,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filterStaff.length,
                itemBuilder: (context, index) {
                  final staff = filterStaff[index];
                  final bool isSelected = selectedSpecialist?.uid == staff.uid;

                  return GestureDetector(
                    onTap: () => onSelectSpecialist(staff),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          _buildStaffCard(staff, isSelected),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        }),
      ],
    );
  }

  List<StaffModel> _filterAvailableStaff(List<StaffModel> staffList) {
    return staffList.where((staff) {
      if (staff.days.isEmpty || staff.listOfServices.isEmpty) return false;
      if (staff.startTime.isEmpty || staff.endTime.isEmpty) return false;

      try {
        final now = DateTime.now();

        final startTime = _parseTime(staff.startTime, now);
        var endTime = _parseTime(staff.endTime, now);

        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }

        return now.isAfter(startTime) && now.isBefore(endTime);
      } catch (_) {
        return false;
      }
    }).toList();
  }

  DateTime _parseTime(String time, DateTime referenceDate) {
    final parts = time.split(' ');
    final hourMinute = parts[0].split(':');

    int hour = int.parse(hourMinute[0]);
    final int minute = int.parse(hourMinute[1]);

    if (parts[1] == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1] == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(referenceDate.year, referenceDate.month, referenceDate.day, hour, minute);
  }

  Widget _buildStaffCard(StaffModel staff, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? Colors.green : AppColors.lightGrey,
        ),
        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: staff.photoURL,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 95,
                  height: 90,
                  color: Colors.grey[300],
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Gap(5),
            LabelText(
              text: staff.displayName,
              weight: FontWeight.w600,
              fontSize: AppFontSize.small,
            ),
            LabelText(
              text: staff.role.tr,
              weight: FontWeight.w400,
              fontSize: AppFontSize.xsmall,
              textColor: AppColors.mediumGrey,
            ),
          ],
        ),
      ),
    );
  }
}
