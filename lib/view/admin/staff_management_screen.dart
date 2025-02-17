import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/specialist_card_for_details.dart';
import 'package:hair_salon/constants/routes_names.dart';
import 'package:hair_salon/view/admin/admin.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final staffProvider = Get.find<StaffController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: "staff_management".tr,
        isTrailingAddButton: true,
        onAddButtonTap: () {
          Get.toNamed(RouteName.addStaffMemberScreen);
        },
      ),
      body: Obx(() {
        if (staffProvider.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: staffProvider.staffList.length,
            itemBuilder: (BuildContext context, index) {
              final staff = staffProvider.staffList[index];
              return SpecialistCardComponentForDetails(
                imagePath: staff.photoURL,
                name: staff.displayName,
                startTime: staff.startTime,
                endTime: staff.endTime,
                specialty: staff.role,
                listOfDays: staff.days,
                listOfServices: staff.listOfServices,
                isDetailsButton: true,
                buttonOnTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StaffProfileScreen(staff: staff)),
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }
}
