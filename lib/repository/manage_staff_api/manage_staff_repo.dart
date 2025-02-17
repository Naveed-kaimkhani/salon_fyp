
import 'dart:typed_data';
import 'package:hair_salon/models/staff/staff_model.dart';

abstract class StaffServicesRepository {
  Future<List<StaffModel>> fetchStaffList();
  Future<StaffModel> addStaffMember(StaffModel staff);
  Future<String> uploadProfileImage({required Uint8List? imageFile, required String uid}) ;
  
  Future<String> uploadSalonDocs({required Uint8List? imageFile, required String uid,
  required String documentType,}) ;
  Future<void> updateStaffMember(String uid, Map<String, dynamic> updatedFields);
  Future<void> removeStaffMember(String uid);
   Future<void> updateStaffServices({
    required String staffUid,
    required List<String> services,
  });

}