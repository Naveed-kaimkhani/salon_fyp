import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/treatment_card.dart';
import 'package:hair_salon/models/service/services_model.dart';
import 'package:hair_salon/repository/services_repo/manage_service_repo.dart';

class AssignedServicesWidget extends StatelessWidget {
  const AssignedServicesWidget({
    super.key,
    required ManageServiceRepo servicesController,
    required this.listOfServices,
  }) : _servicesController = servicesController;

  final ManageServiceRepo _servicesController;
  final List<String> listOfServices;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ServicesModel>>(
      future: _servicesController.fetchAssignedServices(listOfServices),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '${'error'.tr}: ${snapshot.error}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'no_assigned_services'.tr,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        // If services are fetched successfully
        final services = snapshot.data!;
        return Column(
          children: services.map((service) {
            return TreatmentCard(
              uid: service.uid,
              price: service.price,
              treatmentFor: service.gender,
              service: service.name,
              duration: service.duration,
              image: service.imageUrl,
            );
          }).toList(),
        );
      },
    );
  }
}
