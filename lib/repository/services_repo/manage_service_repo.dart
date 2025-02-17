import 'dart:typed_data';

import 'package:hair_salon/models/service/services_model.dart';

abstract class ManageServiceRepo {
  Future<List<ServicesModel>> fetchServicesList();  
  Future<ServicesModel> addService(ServicesModel service) ;     
  Future<void> removeService(String serviceId);
   Future<String> uploadServiceImage({
    required Uint8List? imageFile,
    required String uid,
  });
  Future<List<ServicesModel>> fetchAssignedServices(List<String> serviceUIDs);
}