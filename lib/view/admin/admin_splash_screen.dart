import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSplashScreen extends StatefulWidget {
  const AdminSplashScreen({super.key});

  @override
  State<AdminSplashScreen> createState() => _AdminSplashScreenState();
}

class _AdminSplashScreenState extends State<AdminSplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAdminSession();
  }

  Future<void> _checkAdminSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final isAdmin = prefs.getBool('isAdmin') ?? false;

    if (isAuthenticated && isAdmin) {
      // Navigate to admin home or management screen after a delay
      Future.delayed(
        const Duration(seconds: 3),
        () => Get.offAndToNamed(RouteName.staffManagementScreen),
      );
    } else {
      // Navigate to login screen if session is invalid
      Future.delayed(
        const Duration(seconds: 3),
        () => Get.offAllNamed(RouteName.userLoginScreen),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          AppImages.adminSplashImg,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
