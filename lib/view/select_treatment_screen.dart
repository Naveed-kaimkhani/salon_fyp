// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hair_salon/components/components.dart';
// import 'package:hair_salon/view_model/controller/manage_services_provider.dart';
// import 'package:hair_salon/view_model/controller/treatment_card_controller.dart';

// class SelectTreatmentScreen extends StatelessWidget {
//   final String staffId;
//    ManageServiceProvider serviceProvider = Get.find();
//    TreatmentCardController treatmentController = Get.find();

//    SelectTreatmentScreen({super.key, required this.staffId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "select_treatment".tr,
//         isLeadingNeed: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
//         child: Obx(() {
//           if (serviceProvider.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (serviceProvider.serviceList.isEmpty) {
//             return Center(child: Text('no_services_available'.tr));
//           }
//           //filter services here

//           return ListView.builder(
//             itemCount: serviceProvider.serviceList.length,
//             itemBuilder: (context, index) {
//               final service = serviceProvider.serviceList[index];

//               return GestureDetector(
//                 onTap: () {
//                   // Update the selected treatment in the controller
//                   treatmentController.selectTreatment(
//                     service.uid,
//                     service.name,
//                     service.duration,
//                     service.price,
//                     service.imageUrl,
//                     service.gender,

//                   );

//                   // Navigate back
//                   Get.back();
//                 },
//                 child: TreatmentCard(
//                   uid: service.uid,
//                   treatmentFor: service.gender,
//                   service: service.name,
//                   duration: service.duration,
//                   price: service.price,
//                   image: service.imageUrl,
//                   isShowPrice: true,
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/view_model/controller/manage_services_provider.dart';
import 'package:hair_salon/view_model/controller/treatment_card_controller.dart';

class SelectTreatmentScreen extends StatelessWidget {
  
  final Rx<StaffModel?> selectedSpecialist =
      Rx<StaffModel?>(Get.arguments as StaffModel?);
  final ManageServiceProvider serviceProvider = Get.find();
  final TreatmentCardController treatmentController = Get.find();

  // SelectTreatmentScreen({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "select_treatment".tr,
        isLeadingNeed: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Obx(() {
          if (serviceProvider.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (serviceProvider.serviceList.isEmpty) {
            return Center(child: Text('no_services_available'.tr));
          }

// Filter services based on the IDs in the specialist's list
          final filteredServices = serviceProvider.serviceList
              .where((service) => selectedSpecialist.value!.listOfServices.contains(service.uid))
              .toList();
          if (filteredServices.isEmpty) {
            return Center(child: Text('no_services_available_for_this_specialist'.tr));
          }

          return ListView.builder(
            itemCount: filteredServices.length,
            itemBuilder: (context, index) {
              final service = filteredServices[index];

              return GestureDetector(
                onTap: () {
                  // Update the selected treatment in the controller
                  treatmentController.selectTreatment(
                    service.uid,
                    service.name,
                    service.duration,
                    service.price,
                    service.imageUrl,
                    service.gender,
                  );

                  // Navigate back
                  Get.back();
                },
                child: TreatmentCard(
                  uid: service.uid,
                  treatmentFor: service.gender,
                  service: service.name,
                  duration: service.duration,
                  price: service.price,
                  image: service.imageUrl,
                  isShowPrice: true,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
