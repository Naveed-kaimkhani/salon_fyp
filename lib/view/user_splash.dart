import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSplashScreen extends StatefulWidget {
  const UserSplashScreen({super.key});

  @override
  State<UserSplashScreen> createState() => _UserSplashScreenState();
}

class _UserSplashScreenState extends State<UserSplashScreen> {
  // late Future<bool> isAdminAuthenticated;
  late Future<bool> isUserAuthenticated;
  // late Future<bool> isApproved;

  @override
  void initState() {
    super.initState();
    // isAdminAuthenticated = _isAdminAuthenticated();
    isUserAuthenticated = _isUserAuthenticated();
    // isApproved = _isApproved();
    Future.delayed(const Duration(seconds: 3), () async {
      // bool adminAuth = await isAdminAuthenticated;
      bool userAuth = await isUserAuthenticated;
      // bool approved = await isApproved;
      // log("Admin Authenticated: $adminAuth");
      log("User Authenticated: $userAuth");

      if (userAuth) {
        Get.offAndToNamed(RouteName.userHomeScreen);
      } else {
        Get.offAllNamed(RouteName.userSignInScreen);
      }
    });
  }

  Future<bool> _isUserAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: Future.wait([isUserAuthenticated])
            .then((results) => results[0] || results[1]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // bool isAdmin = snapshot.data ?? false;
            return SizedBox.expand(
              child: Image.asset(
                AppImages.customerSplashImg,
                fit: BoxFit.fill,
              ),
            );
          }
        },
      ),
    );
  }
}
