import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hair_salon/models/service/services_model.dart';
import 'package:hair_salon/repository/services_repo/manage_service_repo.dart';

class ManageServiceRepoImpl extends ManageServiceRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Reference _storageReference = FirebaseStorage.instance.ref();

  @override
  Future<List<ServicesModel>> fetchServicesList() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('services').get();

      return snapshot.docs.map((doc) {
        return ServicesModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('error'.tr,
          'error_fetching_services_list'.trParams({'error': e.toString()}));
      rethrow;
    }
  }

  @override
  Future<ServicesModel> addService(ServicesModel service) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('services').add(service.toJson());

      String uid = docRef.id;

      await docRef.update({'uid': uid});

      Get.snackbar('success'.tr, 'service_added_successfully'.tr);
      return service.copyWith(uid: uid);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_add_service'.trParams({'error': e.toString()}));
      rethrow;
    }
  }

  @override
  Future<void> removeService(String serviceId) async {
    try {
      await _firestore.collection('services').doc(serviceId).delete();

      Get.snackbar('success'.tr, 'service_removed_successfully'.tr);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_remove_service'.trParams({'error': e.toString()}));
      rethrow;
    }
  }

  @override
  Future<String> uploadServiceImage({
    required Uint8List? imageFile,
    required String uid,
  }) async {
    await _storageReference
        .child('services_images')
        .child(uid)
        .putData(imageFile!);
    return await _storageReference
        .child('services_images/$uid')
        .getDownloadURL();
  }

  @override
  Future<List<ServicesModel>> fetchAssignedServices(
      List<String> serviceUIDs) async {
    try {
      final serviceCollection =
          FirebaseFirestore.instance.collection('services');
      final serviceSnapshots = await Future.wait(
        serviceUIDs.map((uid) => serviceCollection.doc(uid).get()),
      );

      return serviceSnapshots
          .where((doc) => doc.exists)
          .map((doc) =>
              ServicesModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch services: $e");
    }
  }
}
