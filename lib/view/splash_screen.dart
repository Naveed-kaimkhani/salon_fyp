import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> isAdminAuthenticated;
  late Future<bool> isUserAuthenticated;

  @override
  void initState() {
    super.initState();
    isAdminAuthenticated = _isAdminAuthenticated();
    isUserAuthenticated = _isUserAuthenticated();

    Future.delayed(const Duration(seconds: 3), () async {
      bool adminAuth = await isAdminAuthenticated;
      bool userAuth = await isUserAuthenticated;

      log("Admin Authenticated: $adminAuth");
      log("User Authenticated: $userAuth");

      if (adminAuth) {
        Get.offAndToNamed(RouteName.adminBottomNavBar);
      } else if (userAuth) {
        Get.offAndToNamed(RouteName.userHomeScreen);
      } else {
        Get.offAllNamed(RouteName.userLoginScreen);
      }
    });
  }

  Future<bool> _isAdminAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAdminAuthenticated') ?? false;
  }

  Future<bool> _isUserAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: Future.wait([isAdminAuthenticated, isUserAuthenticated])
            .then((results) => results[0] || results[1]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            bool isAdmin = snapshot.data ?? false;
            return SizedBox.expand(
              child: Image.asset(
                isAdmin
                    ? AppImages.adminSplashImg
                    : AppImages.customerSplashImg,
                fit: BoxFit.fill,
              ),
            );
          }
        },
      ),
    );
  }
}