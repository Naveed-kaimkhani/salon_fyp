import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ImageManagementController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Observable variables for state
  var isLoading = false.obs;
  var coverImageUrl = ''.obs;
  var galleryImageUrls = <String>[].obs;

  // Upload image to Firebase Storage
  Future<String?> uploadImageToFirebase(
      Uint8List imageData, String folder) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef =
          _storage.ref().child("$folder/$fileName.jpg");

      final UploadTask uploadTask = storageRef.putData(imageData);
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log("Error uploading image to Firebase: $e");
      return null;
    }
  }

  // Add cover image
  Future<void> addCoverImage(Uint8List imageData) async {
    try {
      isLoading.value = true;

      // Delete all existing images in the coverPhoto folder
      final ListResult result = await _storage.ref('coverPhoto/').listAll();
      for (var item in result.items) {
        await item.delete();
      }

      // Upload the new cover image
      final String? downloadUrl =
          await uploadImageToFirebase(imageData, "coverPhoto");
      if (downloadUrl != null) {
        coverImageUrl.value = downloadUrl;
      }
    } catch (e) {
      log("Error adding cover image: $e");
      showError("Failed to upload cover image.");
    } finally {
      isLoading.value = false;
    }
  }

  // Add gallery image
  Future<void> addGalleryImage(Uint8List imageData) async {
    try {
      isLoading.value = true;
      final String? downloadUrl =
          await uploadImageToFirebase(imageData, "galleryImages");
      if (downloadUrl != null) {
        galleryImageUrls.add(downloadUrl);
      }
    } catch (e) {
      log("Error adding gallery image: $e");
      showError("Failed to upload gallery image.");
    } finally {
      isLoading.value = false;
    }
  }

  // Delete image from Firebase
  Future<void> deleteImage(String imageUrl, {bool isCoverImage = false}) async {
    try {
      final Reference storageRef = _storage.refFromURL(imageUrl);
      await storageRef.delete();
      if (isCoverImage) {
        coverImageUrl.value = '';
      } else {
        galleryImageUrls.remove(imageUrl);
      }
    } catch (e) {
      log("Error deleting image: $e");
      showError("Failed to delete image.");
    }
  }

  // Save changes (if needed for additional processing)
  void saveChanges() {
    log("Cover Image: ${coverImageUrl.value}");
    log("Gallery Images: $galleryImageUrls");
  }

  // Error notification
  void showError(String message) {
    Get.snackbar(
      "error".tr,
      message,
      snackPosition: SnackPosition.TOP,
    );
  }
}
