import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/repository/manage_staff_api/manage_staff_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/salon/salon_model.dart';
import 'package:hair_salon/repository/auth_api/firebase_auth_repository.dart';
import 'package:hair_salon/utils/utills.dart';

class BussinessDetails extends StatefulWidget {
  const BussinessDetails({super.key});

  @override
  State<BussinessDetails> createState() => _BussinessDetailsState();
}

class _BussinessDetailsState extends State<BussinessDetails> {
  late TextEditingController businessAdressController,
      operatingHoursController,

      confirmPasswordController;

  final FirebaseAuthRepository authService = FirebaseAuthRepository();
 final StaffServicesRepository _staffServices =
      Get.find<StaffServicesRepository>();
  var isCreatingUser = false.obs;
  // Salon salon = Get.arguments;


  Uint8List? businessLicenseImage;
  Uint8List? idProofImage;

  @override
  void initState() {
    super.initState();
    businessAdressController = TextEditingController();
    operatingHoursController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    businessAdressController.dispose();
    operatingHoursController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source, bool isLicense) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        if (isLicense) {
          businessLicenseImage = imageBytes;
        } else {
          idProofImage = imageBytes;
        }
      });
    }
  }
void _login() async{
  
      isCreatingUser = true.obs;
   authService.signUpUser('nav@gmail.com',  '111111', context)
        .then((User? user) async {
      if (user != null) {
try {

   final String businessLicenseUrl= await  _staffServices.uploadSalonDocs(
          imageFile: businessLicenseImage!,
          uid: user.uid,
          documentType: 'business_license',
        );
        

   final String idCardUrl= await  _staffServices.uploadSalonDocs(
          imageFile: businessLicenseImage!,
          uid: user.uid,
          documentType: 'id_card',
        );
      await authService.createSalonProfile(
        // salon: Salon(
        //   // uid: salon.uid,
        //   businessName: salon.businessName,
        //   ownerName: salon.ownerName,
        //   phoneNumber: salon.phoneNumber,
        //   email: salon.email,
        //   businessAddress: businessAdressController.text,
        //   operatingHours: operatingHoursController.text,
        //   businessLicenseUrl: businessLicenseUrl, // Handle upload logic
        //   idProofUrl: idCardUrl, // Handle upload logic
        //   createdAt: DateTime.now(),
        // ),
        salon: Salon(
          // uid: salon.uid,
          businessName: "salon.businessName",
          ownerName: "salon.ownerName",
          phoneNumber: "salon.phoneNumber",
          email: "salon.email",
          businessAddress: businessAdressController.text,
          operatingHours: operatingHoursController.text,
          businessLicenseUrl: businessLicenseUrl, // Handle upload logic
          idProofUrl: idCardUrl, // Handle upload logic
          createdAt: DateTime.now(),
        ),
      );
      
        isCreatingUser = false.obs;
      Get.offAllNamed(RouteName.userHomeScreen);
    } catch (error) {
      
      isCreatingUser = false.obs;
      Get.snackbar('Error', 'Failed to sign up: ${error.toString()}');
    } finally {
      
        isCreatingUser = false.obs;
    }
      } else {
   
      isCreatingUser = false.obs;
      }
    });
  }
  void validateAndSignUp() async {
    if (businessAdressController.text.isEmpty) {
      
      isCreatingUser = false.obs;
      Get.snackbar('Error', 'Business Address cannot be empty');
      
      return;
    }
    if (operatingHoursController.text.isEmpty) {
      
      isCreatingUser = false.obs;
      Get.snackbar('Error', 'Operating Hours cannot be empty');
    
      return;
    }
    if (businessLicenseImage == null) {
      
      isCreatingUser = false.obs;
      Get.snackbar('Error', 'Please upload Business License');
    
      return;
    }
    if (idProofImage == null) {
    
      isCreatingUser = false.obs;
      Get.snackbar('Error', 'Please upload ID Proof');
    
      return;
    }


    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  AppImages.logo,
                  width: 220,
                ),
              ),
              const Gap(50),
              LabelText(
                text: "Add Business Details",
                textColor: AppColors.purple,
                fontSize: AppFontSize.xlarge,
                weight: FontWeight.w600,
              ),
              const Gap(20),
              CustomTextField(
                label: "Business Address",
                hint: "Enter your business address",
                controller: businessAdressController,
              ),
              const Gap(15),
              CustomTextField(
                label: "Operating Hours",
                hint: "e.g., 9 AM - 9 PM",
                controller: operatingHoursController,
              ),
              const Gap(15),
              LabelText(
                text: "Upload Business License",
                textColor: AppColors.black,
                fontSize: AppFontSize.small,
                weight: FontWeight.w500,
              ),
              const Gap(10),
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery, true),
                child: businessLicenseImage == null
                    ? uploadContainer()
                    : Image.memory(businessLicenseImage!,
                        width: double.infinity, height: 100, fit: BoxFit.cover),
              ),
              const Gap(15),
              LabelText(
                text: "Upload ID Proof",
                textColor: AppColors.black,
                fontSize: AppFontSize.small,
                weight: FontWeight.w500,
              ),
              const Gap(10),
              GestureDetector(
                onTap: () => pickImage(ImageSource.gallery, false),
                child: idProofImage == null
                    ? uploadContainer()
                    : Image.memory(idProofImage!,
                        width: double.infinity, height: 100, fit: BoxFit.cover),
              ),
              const Gap(50),
              CustomGradientButton(
                text: "Continue",
                onTap: validateAndSignUp,
                isLoading: isCreatingUser,
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadContainer() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: Icon(Icons.upload, size: 40)),
    );
  }
}
