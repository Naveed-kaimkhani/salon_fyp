import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/treatment_card_V2.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/manage_services_provider.dart';

class ManageServicesScreen extends StatelessWidget {
  ManageServicesScreen({super.key});

  final ManageServiceProvider serviceProvider =
      Get.find<ManageServiceProvider>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "manage_services".tr,
        isTrailingAddButton: true,
        onAddButtonTap: () {
          Get.toNamed(RouteName.addServicesScreen);
        },
      ),
      body: Obx(() {
        // Display loading indicator while data is being fetched
        if (serviceProvider.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        // Handle empty service list
        if (serviceProvider.serviceList.isEmpty) {
          return Center(
            child: Text(
              "no_services_available".tr,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // Display the list of services dynamically
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: serviceProvider.serviceList.map((service) {
                return TreatmentCardV2(
                  uid: service.uid,
                  treatmentFor: service.gender,
                  service: service.name,
                  duration: service.duration,
                  price: service.price,
                  image: service.imageUrl, // Placeholder image
                  isShowEditButton: true,
                  isShowPrice: true,
                  isShowButton: true,
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
