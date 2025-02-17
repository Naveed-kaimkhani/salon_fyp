import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/treatment_card_V2.dart';
import 'package:hair_salon/constants/index.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/manage_services_provider.dart';

class EditAssignedServicesScreen extends StatefulWidget {
  final List<String> selectedServices;

  EditAssignedServicesScreen({
    super.key,
    required this.selectedServices,
  });

  @override
  State<EditAssignedServicesScreen> createState() =>
      _EditAssignedServicesScreenState();
}

class _EditAssignedServicesScreenState
    extends State<EditAssignedServicesScreen> {
  // Access the service provider controller using Get.find()
  final serviceProvider = Get.find<ManageServiceProvider>();

  // Create a mutable copy of the selected services
  late List<String> localSelectedServices;

  @override
  void initState() {
    super.initState();
    // Initialize the local copy
    localSelectedServices = List<String>.from(widget.selectedServices);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'assign_services'.tr,
        isLeadingNeed: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),

              // Observing the service list from provider
              Obx(() {
                var serviceList = serviceProvider.serviceList;

                if (serviceProvider.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }

                if (serviceList.isEmpty) {
                  return Center(
                    child: Text(
                      'no_services_available'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return Column(
                  children: serviceList.map((service) {
                    final isSelected =
                        localSelectedServices.contains(service.uid);

                    return GestureDetector(
                      behavior: HitTestBehavior
                          .opaque, // Ensure the entire area is tappable
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            localSelectedServices.remove(service.uid);
                          } else {
                            localSelectedServices.add(service.uid);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.purple
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: TreatmentCardV2(
                          uid: service.uid,
                          price: service.price,
                          treatmentFor: service.gender,
                          service: service.name,
                          duration: service.duration,
                          image: service.imageUrl,
                          isShowChackBoxAtTrailing: true,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),

              const Gap(20),

              CustomGradientButton(
                text: 'save'.tr,
                onTap: () {
                  if (localSelectedServices.isEmpty) {
                    Get.snackbar(
                        'error'.tr, 'please_select_at_least_one_service'.tr);
                  } else {
                    // Pass the updated list back
                        Navigator.pop(context, localSelectedServices);

                  }
                },
                isLoading: false.obs,
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}

