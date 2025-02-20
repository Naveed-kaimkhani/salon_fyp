import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/routes_names.dart';
import 'package:hair_salon/models/salon/salon_model.dart';
import 'package:hair_salon/repository/auth_api/auth_api.dart';
import 'package:hair_salon/view/admin/admin.dart';
import 'package:hair_salon/view/bottom_navigation_bar_component.dart';
import 'package:hair_salon/view/user_log_in_screen.dart';
import 'package:hair_salon/view/user_signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _verificationId;

  /// Formats the phone number to E.164 standard for Israel
  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      // return '+972${phoneNumber.substring(1)}';
      return '+92${phoneNumber.substring(1)}';
    } else if (!phoneNumber.startsWith('+')) {
      // return '+972$phoneNumber';
      return '+92$phoneNumber';
    }
    return phoneNumber;
  }

  /// Send OTP for phone number authentication
  @override
  Future<void> sendVerificationCode(
      String phoneNumber, BuildContext context) async {
    if (phoneNumber.isEmpty || phoneNumber.length < 10) {
      Get.snackbar('error'.tr, 'phone_empty_or_short'.tr);
      return;
    }

    final formattedPhoneNumber = formatPhoneNumber(phoneNumber);

    try {
      final existingUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: formattedPhoneNumber)
          .get();

      if (existingUser.docs.isNotEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: formattedPhoneNumber,
          timeout: const Duration(minutes: 2),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            saveUserSession(existingUser.docs.first.id, formattedPhoneNumber);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigationBarComponent(),
              ),
              result: (route) => false, // Clear all previous routes
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            Get.snackbar('error'.tr,
                'failed_to_verify_phone'.trParams({'message': e.message!}));
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            Get.snackbar(
                'success'.tr,
                'verification_code_sent'
                    .trParams({'phoneNumber': phoneNumber}));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      } else {
        await _auth.verifyPhoneNumber(
          phoneNumber: formattedPhoneNumber,
          timeout: const Duration(minutes: 2),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            Get.toNamed(RouteName.userSignUpScreen);
          },
          verificationFailed: (FirebaseAuthException e) {
            Get.snackbar('error'.tr,
                'failed_to_verify_phone'.trParams({'message': e.message!}));
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId;
            Get.snackbar(
                'success'.tr,
                'verification_code_sent'
                    .trParams({'phoneNumber': phoneNumber}));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } catch (e) {
      Get.snackbar(
          'error'.tr, 'error_occurred'.trParams({'error': e.toString()}));
    }
  }

  /// Fetch user details from Firestore
  Future<Map<String, dynamic>?> fetchUserDetails() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          return userDoc.data();
        } else {
          Get.snackbar('error'.tr, 'user_details_not_found'.tr);
        }
      } else {
        Get.snackbar('error'.tr, 'no_authenticated_user'.tr);
      }
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_fetch_user_details'.trParams({'error': e.toString()}));
    }
    return null;
  }

  /// Verify the entered OTP
  @override
  Future<void> verifyCode(String smsCode, phoneNumber) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final existingUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (existingUser.exists) {
          log("User already exists, navigating to home screen.");
          await saveUserSession(user.uid, user.phoneNumber!);
          Get.offAllNamed(RouteName.userHomeScreen, arguments: phoneNumber);
        } else {
          log("User does not exist, navigating to sign-up screen.");
          Get.toNamed(RouteName.userSignUpScreen, arguments: phoneNumber);
        }
      }
    } catch (e) {
      Get.snackbar('error'.tr, 'invalid_verification_code'.tr);
    }
  }

  /// Create a user profile in Firestore
  @override
  Future<void> createUserProfile({
    required String name,
    required String phone,
    required String birthday,
    required String gender,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        final Map<String, dynamic> userData = {
          'uid': user.uid,
          'name': name,
          'phone': phone,
          'birthday': birthday,
          'gender': gender,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData);
        Get.snackbar('success'.tr, 'user_profile_created'.tr);
        await saveUserSession(user.uid, phone);
      } else {
        throw Exception('no_authenticated_user'.tr);
      }
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_create_user_profile'.trParams({'error': e.toString()}));
    }
  }

  @override
  Future<void> createSalonProfile({
  
    //accept salon model
    required Salon salon,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('salons')
            .doc(user.uid)
            .set(salon.toJson());
        Get.snackbar('success'.tr,'Salon Profile Created Successfully');
        // await saveUserSession(user.uid, phone);
      } else {
        // throw Exception('no_authenticated_user'.tr);
        Get.snackbar('error', 'No Authenticated User');
      }
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_create_user_profile'.trParams({'error': e.toString()}));
    }
  }

  /// Get the currently logged-in user
  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  Future<User?> login(String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
    Get.snackbar('error', 'invalid Email or Password');
    }
  }

  Future<User?> signUpUser(String email, String password, context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      Get.snackbar('error', error.message!);
    }
    return null;
  }


  /// Save the user session in shared preferences
  @override
  Future<void> saveUserSession(String uid, String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);
    await prefs.setString('uid', uid);
    await prefs.setString('phoneNumber', phoneNumber);
  }
  Future<void> saveApprovalSession(String uid, String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isApproved', true);
  }
  /// Check if the user is authenticated
  @override
  Future<bool> isUserAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated') ?? false;
  }

  /// Clear the user session from shared preferences
  @override
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isAuthenticated');
    await prefs.remove('uid');
    await prefs.remove('phoneNumber');
  }

  /// Sign out the user
  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Clear session
      await clearUserSession();
      Get.offAllNamed(RouteName.splashScreen);
      Get.snackbar('success'.tr, 'signed_out'.tr);
    } catch (e) {
      Get.snackbar(
          'error'.tr, 'failed_to_sign_out'.trParams({'error': e.toString()}));
    }
  }

  /// Delete the user account
  @override
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        final uid = user.uid;

        // Delete user data from Firestore
        await deleteUserData(uid);

        // Delete user from Firebase Authentication
        await user.delete();

        // Clear user session
        await clearUserSession();

        Get.offAllNamed(RouteName.userLoginScreen);
        Get.snackbar('success'.tr, 'account_deleted'.tr);
        log("deleted user firebase auth too");
      } else {
        throw Exception('no_authenticated_user'.tr);
      }
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_delete_account'.trParams({'error': e.toString()}));
    }
  }

  @override
  Future<User?> loginWithEmailPass(
      String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save session data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAdminAuthenticated', true);
      await prefs.setString('adminEmail', email);

      // Navigate to admin dashboard and clear all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AdminBottomNavBar(),
        ),
        (route) => false, // Clear all previous routes
      );

      return userCredential.user;
    } catch (e) {
      // Show error message
      Get.snackbar('error'.tr, 'invalid_email_or_password'.tr);
      return null;
    }
  }

  @override
  Future<User?> SignUpUserWithEmailPass(
      String email, String password, context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save session data in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', true);


      // Navigate to admin dashboard and clear all previous routes
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => UserSignUpScreen(),
        ),
        (route) => false, // Clear all previous routes
      );

      return userCredential.user;
    } catch (e) {
      // Show error message
      // Get.snackbar('error'.tr, 'invalid_email_or_password'.tr);
      Get.snackbar('error'.tr, e.toString());
      return null;
    }
  }

  Future<void> checkAdminSession(context) async {
    final prefs = await SharedPreferences.getInstance();
    final isAdminAuthenticated = prefs.getBool('isAdminAuthenticated') ?? false;

    if (isAdminAuthenticated) {
      // Navigate to the admin dashboard or screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AdminBottomNavBar(), // Admin dashboard
        ),
        (route) => false, // Clear all previous routes
      );
    } else {
      // Navigate to the login screen
      Get.offAll(
          () => UserLogInScreen()); // Replace with your user login widget
    }
  }

  @override
  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updatedData);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_update_user_data'.trParams({'error': e.toString()}));
      throw e;
    }
  }

  @override
  Future<void> deleteUserData(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final batch = firestore.batch();

      final userDocRef = firestore.collection('users').doc(userId);
      batch.delete(userDocRef);

      final appointmentsQuery = await firestore
          .collection('appointments')
          .where('userUid', isEqualTo: userId)
          .get();
      for (var doc in appointmentsQuery.docs) {
        batch.delete(doc.reference);
      }

      final notificationsQuery = await firestore
          .collection('notifications')
          .where('userUid', isEqualTo: userId)
          .get();
      for (var doc in notificationsQuery.docs) {
        batch.delete(doc.reference);
      }

      final waitingListQuery = await firestore
          .collection('waitinglist')
          .where('userUid', isEqualTo: userId)
          .get();
      for (var doc in waitingListQuery.docs) {
        batch.delete(doc.reference);
      }

      final cancelListQuery = await firestore
          .collection('cancel_appointments')
          .where('userUid', isEqualTo: userId)
          .get();
      for (var doc in cancelListQuery.docs) {
        batch.delete(doc.reference);
      }

      // Commit batch operations
      await batch.commit();
      log("deleted user all data on firestore");
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_delete_user_data'.trParams({'error': e.toString()}));
      throw Exception(
          "failed_to_delete_user_data".trParams({'error': e.toString()}));
    }
  }

  Future<void> handleDeleteAccount(String phoneNumber, String otp) async {
    try {
      // Ensure `_verificationId` is set before proceeding
      if (_verificationId.isEmpty) {
        throw Exception('Verification ID is not set. Request OTP again.');
      }

      // Step 1: Create a credential using the OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      final currentUser = await FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('no_authenticated_user'.tr);
      }

      await currentUser.reauthenticateWithCredential(credential);

      final userId = currentUser.uid;
      if (userId.isEmpty) {
        throw Exception('User ID is empty. Cannot proceed with deletion.');
      }

      await deleteUserData(userId);

      await currentUser.delete();

      await clearUserSession();

      Get.snackbar('success'.tr, 'account_deleted_successfully'.tr);
    } catch (e) {
      Get.snackbar('error'.tr,
          'failed_to_delete_account'.trParams({'error': e.toString()}));
      throw Exception(
          "failed_to_delete_account".trParams({'error': e.toString()}));
    }
  }
}
