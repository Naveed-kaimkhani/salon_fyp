import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/full_screen.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/staff/staff_model.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';
import 'package:hair_salon/view/all_staff_screen.dart';
import 'package:hair_salon/view_model/controller/controller.dart';
import 'package:shimmer/shimmer.dart';

class UserHomeScreen extends StatelessWidget {
  UserHomeScreen({super.key});

  // Controllers for state management
  final FirebaseAuthRepository authService = FirebaseAuthRepository();
  final RxString userInitials = "U".obs;
  final RxString? coverImageUrl = ''.obs;
  final RxList<String> galleryImages = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    // Fetch user initials and images at screen load
    fetchAndSetUserInitials();
    fetchImagesFromStorage();

    return Scaffold(
      appBar: CustomAppBar(
        userName: userInitials,
        greetingTxt: "Good Morning",
        circularAvetartxt: userInitials,
        isHomeScreen: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildShopDecorationImageSection(),
              const Gap(10),
              _galleryImagesWidget(),
              _buildSpecialistSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Obx _galleryImagesWidget() {
    return Obx(() => SizedBox(
          height: 130,
          width: double.infinity,
          child: galleryImages.isEmpty
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: galleryImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildShopGalleryImage(galleryImages[index]),
                    );
                  },
                ),
        ));
  }

  // Fetch and update user initials
  void fetchAndSetUserInitials() async {
    final userDetails = await authService.fetchUserDetails();

    if (userDetails != null && userDetails['name'] != null) {
      userInitials.value = _calculateInitials(userDetails['name']);
    } else {
      userInitials.value = "U"; // Default initial if name is not available
    }
  }

  // Fetch and update images from Firebase Storage
  void fetchImagesFromStorage() async {
    try {
      final ListResult coverImageResult =
          await FirebaseStorage.instance.ref('coverPhoto/').listAll();
      if (coverImageResult.items.isNotEmpty) {
        final String coverUrl =
            await coverImageResult.items.first.getDownloadURL();
        coverImageUrl!.value = coverUrl;
        _precacheImage(coverUrl);
      }

      final ListResult galleryImageResult =
          await FirebaseStorage.instance.ref('galleryImages/').listAll();
      final List<String> galleryUrls = [];

      final List<Future<void>> fetchImageFutures = [];
      for (var item in galleryImageResult.items) {
        final Future<void> future = item.getDownloadURL().then((imageUrl) {
          galleryUrls.add(imageUrl);
          _precacheImage(imageUrl);
        });

        fetchImageFutures.add(future);
      }

      await Future.wait(fetchImageFutures);
      galleryImages.assignAll(galleryUrls); // Update galleryImages reactively
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch images: $e");
    }
  }

  void _precacheImage(String imageUrl) {
    CachedNetworkImageProvider(imageUrl)
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((_, __) {}),
        );
  }

  String _calculateInitials(String name) {
    final nameParts = name.split(" ");
    if (nameParts.length > 1) {
      return "${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}"
          .toUpperCase();
    } else {
      return nameParts[0][0].toUpperCase();
    }
  }

  Widget _buildShopDecorationImageSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.lightGrey,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => coverImageUrl != null && coverImageUrl!.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        Get.context!,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imagePath: coverImageUrl!.value),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: coverImageUrl!.value,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[300],
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
            const Gap(10),
            CustomGradientButton(
              height: 40,
              text: "book_now".tr,
              onTap: () {
                Get.to(() => AllStaffScreen());
              },
              isLoading: false.obs,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopGalleryImage(String image) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FullScreenImage(imagePath: image));
      },
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.lightGrey,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: CachedNetworkImage(
              imageUrl: image,
              height: 110,
              width: 110,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  height: 110,
                  width: 110,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistSection(BuildContext context) {
    final StaffController staffProvider = Get.find<StaffController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelText(
              text: 'our_specialist'.tr,
              weight: FontWeight.w600,
              fontSize: AppFontSize.medium,
            ),
          ],
        ),
        Obx(() {
          if (staffProvider.isLoading.value) {
            return Center(child: const CircularProgressIndicator.adaptive());
          } else if (staffProvider.staffList.isEmpty) {
            return Text("no_specialists_available".tr);
          } else {
            return _buildSpecialistList(staffProvider.staffList);
          }
        }),
      ],
    );
  }

  Widget _buildSpecialistList(List<StaffModel> staffList) {
    return Column(
      children: staffList.map((staff) {
        return SpecialistCardComponent(
          imagePath: staff.photoURL,
          name: staff.displayName,
          specialty: staff.role,
          startTime: staff.startTime,
          endTime: staff.endTime,
          listOfDays: staff.days,
          listOfServices: staff.listOfServices,
          buttonOnTap: () {
            Get.toNamed(
              RouteName.bookAppointmentScreen,
              arguments:
                  staff, // Passing the selected specialist to the next screen
            );
          },
        );
      }).toList(),
    );
  }
}
