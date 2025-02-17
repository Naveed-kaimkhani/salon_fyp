import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hair_salon/models/blocked_dates.dart';
import 'package:hair_salon/repository/blocked_dates/blocked_dates_service.dart';

class FirbaseBlockedDatesRepository implements BlockedDatesRepository {
  final CollectionReference _blockedDatesCollection =
      FirebaseFirestore.instance.collection('blocked_dates');

  @override
  Future<BlockedDateModel> addBlockedDate(BlockedDateModel blockedDate) async {
    try {
      DocumentReference docRef =
          await _blockedDatesCollection.add(blockedDate.toJson());

      Map<String, dynamic> updatedBlockedDate = blockedDate.toJson();
      updatedBlockedDate['id'] = docRef.id; // Store the document ID

      await docRef.update(updatedBlockedDate);
      BlockedDateModel blockedDateModel = BlockedDateModel(
        date: blockedDate.date,
        startTime: blockedDate.startTime,
        endTime: blockedDate.endTime,
        id: docRef.id, // Add the document ID here
      );

      Get.snackbar('success'.tr, 'blocked_date_added_successfully'.tr);
      return blockedDateModel;
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_add_blocked_date'.trParams({'error': e.toString()}));
      return BlockedDateModel(
        date: blockedDate.date,
        startTime: blockedDate.startTime,
        endTime: blockedDate.endTime,
        id: "", // Add the document ID here
      );
    }
  }

  // Fetch all blocked dates
  @override
  Future<List<BlockedDateModel>> fetchBlockedDates() async {
    try {
      final querySnapshot = await _blockedDatesCollection.get();
      return querySnapshot.docs.map((doc) {
        return BlockedDateModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch blocked dates: $e");
    }
  }

  // Remove a blocked date by document ID
  @override
  Future<void> deleteBlockedDate(String docId) async {
    try {
      await _blockedDatesCollection.doc(docId).delete();
    } catch (e) {
      throw Exception("Failed to delete blocked date: $e");
    }
  }
}
