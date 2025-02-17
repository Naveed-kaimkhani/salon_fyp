import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/treatment_card_V2.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/view_model/controller/manage_services_provider.dart';
import 'package:hair_salon/view_model/controller/staff_controller.dart';

class AssignServicesScreen extends StatelessWidget {
  final String staffName;

  AssignServicesScreen({super.key, required this.staffName});

  // Access the service provider controller using Get.find()
  final serviceProvider = Get.find<ManageServiceProvider>();
  final staffController = Get.find<StaffController>();

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
              LabelText(
                text: 'assign_services_to'.trParams({'staffName': staffName}),
                fontSize: AppFontSize.xmedium,
                weight: FontWeight.w600,
              ),
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
                        staffController.assignedServices.contains(service.uid);

                    return GestureDetector(
                      behavior: HitTestBehavior
                          .opaque, // Ensure the entire area is tappable
                      onTap: () {
                        if (isSelected) {
                          staffController.assignedServices.remove(service.uid);
                        } else {
                          staffController.assignedServices.add(service.uid);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          // color: isSelected ? Colors.blue.shade50 : Colors.white,
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
                  if (staffController.assignedServices.isEmpty) {
                    Get.snackbar(
                        'error'.tr, 'please_select_at_least_one_service'.tr);
                  } else {
                    // Pass selected services back
                    Get.back(result: staffController.assignedServices);
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
