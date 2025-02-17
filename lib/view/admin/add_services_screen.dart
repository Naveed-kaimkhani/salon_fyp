import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/service/services_model.dart';
import 'package:hair_salon/repository/services_repo/manage_service_repo.dart';
import 'package:hair_salon/utils/utills.dart';
import 'package:hair_salon/view_model/controller/manage_services_provider.dart';
import 'package:uuid/uuid.dart';

class AddServiceScreen extends StatefulWidget {
  final bool
      isEditService; // Flag to determine if we're editing a service or adding a new one

  // Constructor with the flag
  AddServiceScreen({Key? key, this.isEditService = false}) : super(key: key);

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final servicesController = Get.find<ManageServiceProvider>();

  final ManageServiceRepo _manageServiceRepo = Get.find<ManageServiceRepo>();
  final String uid = Uuid().v4(); // Generate a unique identifier

  late TextEditingController nameController, priceController;
  bool isEditServices =
      false; // This will be controlled by the widget's constructor
  String? selectedDuration = "30";
  String? selectedGender = "Men";
  Uint8List? _serviceImage; // Update the variable name for the service image

  @override
  void initState() {
    super.initState();
    isEditServices =
        widget.isEditService; // Set the flag based on the constructor value
    nameController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    priceController.dispose();
  }

  _submitForm() async {
    if (nameController.text.isEmpty) {
      Get.snackbar("error".tr, "please_add_service_name".tr);
      return;
    }

    if (priceController.text.isEmpty) {
      Get.snackbar("error".tr, "please_add_service_charges".tr);
      return;
    }

    if (selectedDuration == null) {
      Get.snackbar("error".tr, "please_select_duration".tr);
      return;
    }

    if (selectedGender == null) {
      Get.snackbar("error".tr, "please_select_gender".tr);
      return;
    }

    if (_serviceImage == null) {
      Get.snackbar("error".tr, "please_upload_service_image".tr);
      return;
    }

    try {
      servicesController.isLoading.value = true;

      // Collect form data
      final serviceName = nameController.text;
      final serviceDuration = selectedDuration;
      final serviceFor = selectedGender;
      final servicePrice = double.tryParse(priceController.text) ?? 0.0;

      // Upload service image
      final imageUrl = await _manageServiceRepo.uploadServiceImage(
        imageFile: _serviceImage!,
        uid: uid,
      );

      // Create a new ServicesModel
      ServicesModel serviceModel = ServicesModel(
        name: serviceName,
        duration: '$serviceDuration minutes',
        gender: serviceFor ?? "",
        price: servicePrice,
        imageUrl: imageUrl,
        uid: '',
      );

      // Add service
      await servicesController.addService(serviceModel);
      servicesController.isLoading.value = false;
      // Get.back();
    } catch (e) {
      servicesController.isLoading.value = false;
      Get.snackbar("error".tr, "something_went_wrong".tr + ": $e");
    }
  }

  Widget uploadServiceImage(Uint8List? image) {
    return GestureDetector(
      onTap: () async {
        Uint8List? _image = await Utills.pickImage();
        if (_image != null) {
          setState(() {
            _serviceImage = _image;
          });
        }
      },
      child: image == null
          ? DottedBorder(
              color: AppColors.purple,
              strokeWidth: 2,
              dashPattern: const [10, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              child: SizedBox(
                height: 120,
                width: 120,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.purple,
                        size: 40,
                      ),
                      const Gap(8),
                      LabelText(
                        text: "upload_image_here".tr,
                        fontSize: AppFontSize.xxsmall,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: LabelText(
                          text: "browse".tr,
                          textColor: AppColors.purple,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.purple,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(image),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: isEditServices ? "edit_service".tr : "add_new_service".tr,
        isLeadingNeed: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LabelText(
                      text: "service_image_upload".tr,
                      fontSize: AppFontSize.xmedium,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Gap(20),
                  isEditServices
                      ? Column(
                          children: [
                            Stack(
                              children: [
                                DecoratedImage(
                                  image: AppImages.treatment_1,
                                  height: 100,
                                  width: 100,
                                ),
                                Positioned(
                                  bottom: -5,
                                  right: -5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.white),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                          AppSvgIcons.editBlackIcon),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(10),
                            LabelText(
                              text: "hair_cut".tr,
                              weight: FontWeight.w600,
                              fontSize: AppFontSize.xmedium,
                            )
                          ],
                        )
                      : uploadServiceImage(
                          _serviceImage), // Ensure you're passing the correct variable
                  const Gap(10),
                  CustomTextField(
                    label: "service_name".tr,
                    hint: "hair_cut".tr,
                    controller: nameController,
                  ),
                  const Gap(10),

                  CustomTextField(
                    label: "Duration in minutes",
                    hint: "Enter duration in minutes",
                    controller: TextEditingController(text: selectedDuration),
                    keyboardType:
                        TextInputType.number, // Set input type to numbers
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Restrict input to digits only
                    onChanged: (value) {
                      // Update the selectedDuration state when input changes

                      selectedDuration = value;
                      print(selectedDuration);
                      // setState(() {
                      // });
                    },
                  ),

                  const Gap(10),
                  CustomDropdown(
                    label: "for".tr,
                    items: const ["Men", "Women", "Both"],
                    hintText: "men".tr,
                    defaultValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                      });
                    },
                  ),
                  const Gap(10),
                  CustomTextField(
                    label: "price".tr,
                    hint: "\$50",
                    controller: priceController,
                  ),
                  const Gap(20),
                  CustomGradientButton(
                    text: "add_service".tr,
                    onTap: () async {
                      await _submitForm();
                      Navigator.pop(context);
                    },
                    isLoading: servicesController.isLoading,
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
