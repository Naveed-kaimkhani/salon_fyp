
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/repository/services_repo/manage_service_repoImpl.dart';
import 'package:hair_salon/view_model/controller/manage_services_provider.dart';
import 'package:hair_salon/view_model/controller/treatment_card_controller.dart';


class TreatmentSelection extends StatelessWidget {
 final StaffModel staff;
  final TreatmentCardController treatmentController = Get.find(); // Get the controller
  final ManageServiceProvider serviceProvider = Get.put(
    ManageServiceProvider(serviceRepo: ManageServiceRepoImpl()),
  );

   TreatmentSelection({super.key, required this.staff});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelText(
              text: "select_treatment".tr,
              weight: FontWeight.w600,
              fontSize: AppFontSize.xmedium,
            ),
            TextButton(
            
              onPressed: () {
                Get.toNamed(
                  RouteName.selectTreatmentScreen,
                 arguments: staff, // Passing the selected specialist to the next screen
                  );
              },
              child: LabelText(
                text: "see_all".tr,
                fontSize: AppFontSize.xsmall,
                weight: FontWeight.w400,
                textColor: AppColors.blue,
              ),
            ),
          ],
        ),
        const Gap(10),
        Obx(() {
          if (treatmentController.selectedTreatment.value.isEmpty) {
              final filteredServices = serviceProvider.serviceList
              .where((service) => staff.listOfServices.contains(service.uid))
              .toList();
              if (filteredServices.isEmpty) {
                return Center(child: Text("no_services_available_for_this_specialist".tr));
              }
            treatmentController.initializeDefaultTreatment(
         
              filteredServices[0].uid,
              filteredServices[0].name,
              filteredServices[0].duration,
              filteredServices[0].price,
              filteredServices[0].imageUrl,
              filteredServices[0].gender,
            
              
            );
          }

          return TreatmentCard(
            uid: treatmentController.uid.value,
            treatmentFor:treatmentController.treatmentFor.value ,
            service: treatmentController.selectedTreatment.value,
            duration: treatmentController.selectedDuration.value,
            price: treatmentController.selectedPrice.value,
            image: treatmentController.selectedImageUrl.value,
            isShowPrice: true,
          );
        }),
      ],
    );
  }
}
