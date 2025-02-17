import 'package:get/get.dart';
import 'package:hair_salon/models/blocked_dates.dart';
import 'package:hair_salon/repository/blocked_dates/blocked_dates_service.dart';

class BlockedDatesProvider extends GetxController {
  final BlockedDatesRepository blockedDatesRepository;

  // Constructor to inject the repository
  BlockedDatesProvider({required this.blockedDatesRepository});

  // Observable state variables
  var blockedDatesList = <BlockedDateModel>[].obs;
  var isLoading = true.obs;
  var selectedDay = DateTime.now().obs;
  // Action loading for add/delete operations
  var isActionLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBlockedDates();
  }

  // Fetch all blocked dates
  Future<void> fetchBlockedDates() async {
    try {
      isLoading.value = true;
      final dates = await blockedDatesRepository.fetchBlockedDates();
      for (var date in dates) {
        if (!_isDuplicate(date)) {
          blockedDatesList.add(date);
        }
      }
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_fetch_blocked_dates'.trParams({'error': e.toString()}));
    } finally {
      isLoading.value = false;
    }
  }

  // Add a new blocked date
  Future<void> addBlockedDate(BlockedDateModel blockedDate) async {
    try {
      if (_isDuplicate(blockedDate)) {
        Get.snackbar('error'.tr, 'duplicate_blocked_date_error'.tr);
        return;
      }

      isActionLoading.value = true;
      final blockDate =
          await blockedDatesRepository.addBlockedDate(blockedDate);
      blockedDatesList.add(blockDate);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_add_blocked_date'.trParams({'error': e.toString()}));
    } finally {
      isActionLoading.value = false;
    }
  }

  // Delete a blocked date by document ID
  Future<void> deleteBlockedDate(String docId) async {
    try {
      isActionLoading.value = true;
      await blockedDatesRepository.deleteBlockedDate(docId);
      blockedDatesList.removeWhere((date) => date.id == docId);
      Get.snackbar('success'.tr, 'blocked_date_removed_successfully'.tr);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_delete_blocked_date'.trParams({'error': e.toString()}));
    } finally {
      isActionLoading.value = false;
    }
  }

  // Helper method to check for duplicates
  bool _isDuplicate(BlockedDateModel blockedDate) {
    return blockedDatesList.any((date) =>
        date.date == blockedDate.date &&
        date.startTime == blockedDate.startTime &&
        date.endTime == blockedDate.endTime);
  }
}
