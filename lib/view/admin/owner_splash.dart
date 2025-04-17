import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/app_images.dart';
import 'package:hair_salon/constants/routes_names.dart'; // Make sure your route names are defined here

class OwnerSplash extends StatefulWidget {
  const OwnerSplash({Key? key}) : super(key: key);

  @override
  State<OwnerSplash> createState() => _OwnerSplashState();
}

class _OwnerSplashState extends State<OwnerSplash> {
  @override
  void initState() {
    super.initState();
      print("✅ OwnerSplash loaded");

    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    print("check status function");
    await Future.delayed(
        const Duration(seconds: 2)); // Optional delay for splash effect

    User? user = FirebaseAuth.instance.currentUser;
    print(user ?? "user is not logged in");
    // log(user!.uid ?? "");
    if (user == null) {
      // Not logged in
      print("not logged in");
      Get.offAllNamed(RouteName.loginSalon);
    } else {
      // Logged in - check approval status
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('salons')
          .doc(user.uid)
          .get();

      bool isApproved =
          snapshot.exists ? (snapshot['isApproved'] ?? false) : false;

      if (isApproved) {
        Get.offAllNamed(RouteName.adminBottomNavBar);
      } else {
        Get.offAllNamed(RouteName.pendingApprovalScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
      // print("👤 User: ${user?.uid ?? 'null'}");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          AppImages.logo,
          width: 220,
        ), // Or your logo/animation
      // child: Text("Testtt"),
      ),

    );
  }
}
