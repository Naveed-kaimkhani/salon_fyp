import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hair_salon/components/components.dart';
import 'package:hair_salon/constants/index.dart';
import 'package:hair_salon/repository/auth_api/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminLogInScreen extends StatefulWidget {
  final AuthRepository authRepository;
  AdminLogInScreen({super.key, required this.authRepository});

  @override
  State<AdminLogInScreen> createState() => _AdminLogInScreenState();
}

class _AdminLogInScreenState extends State<AdminLogInScreen> {
  late TextEditingController emailController, passwordController;
  late FocusNode emailFocusNode,
      passwordFocusNode; // Focus nodes for each field
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'please_enter_email'.tr;
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return 'please_enter_valid_email'.tr;
    }
    return null;
  }

  Future<void> _loginWithEmailPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    isLoading.value = true;

    if (email.isEmpty || password.isEmpty) {
      isLoading.value = false;
      Get.snackbar("error".tr, 'enter_email_and_password'.tr);
      return;
    }

    final user = await widget.authRepository
        .loginWithEmailPass(email, password, context);
    isLoading.value = false;

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAdminAuthenticated', true);
      Get.offAllNamed(RouteName.adminBottomNavBar);
    } else {
      isLoading.value = false;
    }
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
              const Gap(30),
              Center(
                child: Image.asset(
                  AppImages.logo,
                  width: Get.width * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(50),
              LabelText(
                text: "welcome".tr,
                textColor: AppColors.purple,
                fontSize: AppFontSize.xlarge,
                weight: FontWeight.w600,
              ),
              const Gap(20),
              CustomTextField(
                label: "enter_email".tr,
                hint: "idanhair@mail.com",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                nextFocusNode: passwordFocusNode,
                currentFocusNode: emailFocusNode,
                validator: emailValidator,
              ),
              const Gap(15),
              CustomTextField(
                label: "enter_password".tr,
                hint: "password".tr,
                controller: passwordController,
                isPasswordField: true,
                keyboardType: TextInputType.visiblePassword,
                currentFocusNode: passwordFocusNode, // Focus for password
              ),
              const Gap(50),
              CustomGradientButton(
                text: "continue".tr,
                onTap: _loginWithEmailPassword,
                isLoading: isLoading,
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
