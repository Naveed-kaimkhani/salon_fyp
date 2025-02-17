import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/components/custom_drop_downV2.dart';
import 'package:hair_salon/view_model/controller/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController dobController;

  final ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();

    // Initialize controllers with initial values
    nameController = TextEditingController(text: profileController.name.value);
    dobController =
        TextEditingController(text: profileController.dateOfBirth.value);

    // Listen to name changes and update TextEditingController without resetting cursor
    ever(profileController.name, (value) {
      if (nameController.text != value) {
        nameController.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
    });

    // Listen to dateOfBirth changes and update TextEditingController without resetting cursor
    ever(profileController.dateOfBirth, (value) {
      if (dobController.text != value) {
        dobController.value = TextEditingValue(
          text: value,
          selection: TextSelection.collapsed(offset: value.length),
        );
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    profileController.fetchUserData();

    return Scaffold(
      appBar: CustomAppBar(
        title: "edit_profile".tr,
        isLeadingNeed: true,
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // User Profile Component
                UserProfileComponent(
                  circularAvetartxt: profileController.name.value.isEmpty
                      ? 'n_a'.tr
                      : profileController.name.value[0].toUpperCase(),
                  userName: profileController.name.value,
                  number: '', // Pass phone number if needed
                  isShowButton: false,
                ),
                const Gap(20),

                // Full Name Field
                CustomTextField(
                  label: "full_name".tr,
                  hint: "john_devy".tr,
                  controller: nameController,
                  onChanged: (value) {
                    profileController.name.value =
                        value.trim(); // Update Rx variable
                  },
                ),

                const Gap(15),

                // Gender Dropdown
                CustomDropdownV2(
                  label: "gender".tr,
                  hintText: profileController.gender.value,
                  defaultValue: profileController
                      .gender.value, // Dynamically set the selected value
                  items: ['men'.tr, 'female'.tr, 'other'.tr],
                  onChanged: (value) {
                    profileController.gender.value = value ?? "gender".tr;
                  },
                ),

                const Gap(15),

                // Birthday Field
                CustomTextField(
                  label: "birthday".tr,
                  hint: "mm_dd_yyyy".tr,
                  controller: dobController,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month_outlined),
                    onPressed: () async {
                      // Open date picker and assign the selected date
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        // Format the date to mm/dd/yyyy
                        String formattedDate =
                            "${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.year}";

                        // Update the TextEditingController and Rx variable
                        dobController.text = formattedDate;
                        profileController.dateOfBirth.value = formattedDate;
                      }
                    },
                  ),
                ),

                const Gap(50),

                // Save Changes Button
                CustomGradientButton(
                  text: "save".tr,
                  onTap: profileController.updateUserData,
                  isLoading: profileController.isLoading,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
