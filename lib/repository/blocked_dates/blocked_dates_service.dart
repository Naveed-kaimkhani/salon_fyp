import 'package:hair_salon/models/blocked_dates.dart';

abstract class BlockedDatesRepository {
  Future<BlockedDateModel> addBlockedDate(BlockedDateModel blockedDate);
  Future<List<BlockedDateModel>> fetchBlockedDates();
  Future<void> deleteBlockedDate(String docId);
}
