import 'dart:developer';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/index.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view_model/controller/image_management_controller.dart';

class ImageManagementScreen extends StatelessWidget {
  final ImageManagementController _controller =
      Get.put(ImageManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "image_management".tr,
        isLeadingNeed: true,
      ),
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Photo Section
                  LabelText(
                    text: "cover_photo".tr,
                    fontSize: AppFontSize.medium,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  _controller.coverImageUrl.isNotEmpty
                      ? Stack(
                          children: [
                            Image.network(
                              _controller.coverImageUrl.value,
                              height: 170,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: _imageActionButton(
                                icon: Icons.delete,
                                onTap: () => _controller.deleteImage(
                                  _controller.coverImageUrl.value,
                                  isCoverImage: true,
                                ),
                              ),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () => pickAndUploadImage(isCoverPhoto: true),
                          child: DottedBorder(
                            color: Colors.purple,
                            strokeWidth: 2,
                            dashPattern: const [10, 4],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            child: Container(
                              height: 170,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    color: Colors.purple,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "upload_cover_image".tr,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),

                  // Gallery Images Section
                  LabelText(
                    text: "gallery_images".tr,
                    fontSize: AppFontSize.medium,
                    weight: FontWeight.w600,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _controller.galleryImageUrls.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () => pickAndUploadImage(),
                            child: DottedBorder(
                              color: Colors.purple,
                              strokeWidth: 2,
                              dashPattern: const [10, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Colors.purple,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "add_image".tr,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              Image.network(
                                _controller.galleryImageUrls[index - 1],
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                              Positioned(
                                right: 8,
                                top: 8,
                                child: _imageActionButton(
                                  icon: Icons.delete,
                                  onTap: () => _controller.deleteImage(
                                    _controller.galleryImageUrls[index - 1],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomGradientButton(
                    text: "save".tr,
                    onTap: () async {
                      await saveChanges();
                    },
                    isLoading: _controller.isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveChanges() async {
    try {
      log("Save Changes Triggered");

      // Validation: Check if there are images to save
      if (_controller.coverImageUrl.value.isEmpty &&
          _controller.galleryImageUrls.isEmpty) {
        // Show error snackbar if no images are selected
        Get.snackbar(
          "error".tr,
          "no_images_to_save".tr, // Add this key to your localization
          snackPosition: SnackPosition.TOP,
        
        );
        return; // Exit the function if no images are selected
      }

      _controller.isLoading.value = true;
      _controller.saveChanges();

      // Show success snackbar
      Get.snackbar(
        "success".tr,
        "images_saved_successfully".tr,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      log("Error saving changes: $e");

      // Show error snackbar
      Get.snackbar(
        "error".tr,
        "failed_to_save_images".tr,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _controller.isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage({bool isCoverPhoto = false}) async {
    try {
      Uint8List? pickedImage = await Utills.pickImage();
      if (pickedImage != null) {
        if (isCoverPhoto) {
          await _controller.addCoverImage(pickedImage);
        } else {
          await _controller.addGalleryImage(pickedImage);
        }
      } else {
        Get.snackbar(
          "no_image".tr,
          "no_image_selected".tr,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      log("Error picking/uploading image: $e");

      Get.snackbar(
        "error".tr,
        "failed_to_upload_image".tr,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Widget _imageActionButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.purple,
          size: 20,
        ),
      ),
    );
  }
}
