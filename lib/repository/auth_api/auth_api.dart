import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hair_salon/models/salon/salon_model.dart';

abstract class AuthRepository {
  Future<User?> loginWithEmailPass(String email, String password, context);
  Future<void> sendVerificationCode(String phoneNumber,BuildContext context);
  Future<void> verifyCode(String smsCode, String phoneNumber);
  Future<void> createUserProfile({
    required String name,
    required String phone,
    required String birthday,
    required String gender,
  });
   Future<void> createSalonProfile({
    
    required Salon salon,
  });
  User? getCurrentUser();
  Future<void> saveUserSession(String uid, String phoneNumber);
  Future<bool> isUserAuthenticated();
  Future<void> clearUserSession();
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<void> updateUserData(Map<String, dynamic> updatedData);
  // New methods for backend data handling
  Future<void> deleteUserData(String userId);
  Future<void> handleDeleteAccount(String phoneNumber, String otp);
}
