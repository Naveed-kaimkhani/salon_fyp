import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/routes_names.dart';
import 'package:hair_salon/view_model/controller/staff_controller.dart';

class AllStaffScreen extends StatelessWidget {
  const AllStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'our_specialists'.tr,
        isLeadingNeed: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText(
              text: 'please_choose_specialist'.tr,
              fontSize: 20,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildSpecialistSection(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistSection(BuildContext context) {
    final StaffController staffProvider = Get.find<StaffController>();

    return Obx(() {
      if (staffProvider.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      } else if (staffProvider.staffList.isEmpty) {
        return Center(child: Text('no_specialists_available'.tr));
      } else {
        return ListView.builder(
          itemCount: staffProvider.staffList.length,
          itemBuilder: (context, index) {
            final staff = staffProvider.staffList[index];
            return SpecialistCardComponent(
              imagePath: staff.photoURL,
              name: staff.displayName,
              startTime: staff.startTime,
              endTime: staff.endTime,
              specialty: staff.role,
              listOfDays: staff.days,
              listOfServices: staff.listOfServices,
              buttonOnTap: () {
                Get.toNamed(
                  RouteName.bookAppointmentScreen,
                  arguments: staff,
                );
              },
            );
          },
        );
      }
    });
  }
}
