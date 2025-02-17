import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/view/admin/admin.dart';
import 'package:hair_salon/view_model/controller/controller.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final staffProvider = Get.find<StaffController>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: "staff_members".tr,
        isShowDrawer: true,
        scaffoldKey: _scaffoldKey,
      ),
      drawer: CustomDrawer(),
      body: Obx(() {
        // Display a loading indicator while data is being fetched
        if (staffProvider.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        // Handle empty staff list
        if (staffProvider.staffList.isEmpty) {
          return Center(
            child: Text(
              "no_staff_members_available".tr,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Display the list of staff members
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: staffProvider.staffList.map((StaffModel staff) {
                return SpecialistCardComponent(
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllAppointmentsScreen(
                                uid: staff.uid,
                              )),
                    );
                  },
                  isShowButton: false,
                  imagePath: staff.photoURL,
                  name: staff.displayName,
                  specialty: staff.role,
                  startTime: staff.startTime,
                  endTime: staff.endTime,
                  listOfDays: staff.days,
                  listOfServices: staff.listOfServices,
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
