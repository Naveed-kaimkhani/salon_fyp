import 'package:get/get.dart';
import 'package:hair_salon/models/service/services_model.dart';
import 'package:hair_salon/repository/services_repo/manage_service_repo.dart';

class ManageServiceProvider extends GetxController {
  // Observable list of services
  var serviceList = <ServicesModel>[].obs;
  var isLoading = false.obs;

  final ManageServiceRepo _serviceRepo;

  // Constructor to inject the repository
  ManageServiceProvider({required ManageServiceRepo serviceRepo})
      : _serviceRepo = serviceRepo;

  // Fetch services data using the repository
  Future<void> fetchServicesData() async {
    try {
      isLoading.value = true;
      final fetchedServicesList = await _serviceRepo.fetchServicesList();

      if (fetchedServicesList.isEmpty) {
      } else {}

      serviceList.value = fetchedServicesList;
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_fetch_services'.trParams({'error': e.toString()}));
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new service using the repository
  Future<void> addService(ServicesModel service) async {
    try {
      ServicesModel model = await _serviceRepo.addService(service);
      serviceList.add(model);
      
      Get.snackbar('success'.tr, 'service_added_successfully'.tr);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_add_service'.trParams({'error': e.toString()}));
    }
  }

// Remove a service using the repository
  Future<void> removeService(String serviceId) async {
    try {
      // Call the repository function to delete the service from the backend
      await _serviceRepo.removeService(serviceId);

      // Remove the service locally from the serviceList
      serviceList.removeWhere((service) => service.uid == serviceId);
    } catch (e) {
      // Handle any errors and show a failure message
      Get.snackbar('error'.tr,
          'failed_to_remove_service'.trParams({'error': e.toString()}));
    }
  }

  @override
  void onInit() {
    // Fetch services data when the provider is initialized
    fetchServicesData();
    super.onInit();
  }
}
