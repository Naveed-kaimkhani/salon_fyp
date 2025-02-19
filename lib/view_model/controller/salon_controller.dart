// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hair_salon/models/salon/salon_model.dart';

// class SalonProvider with ChangeNotifier {
//   RxList pendingSalons = [].obs;
//   RxList approvedSalons = [].obs;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   SalonProvider() {
//     fetchSalons(); // Fetch data when provider is initialized
//   }

//   // Fetch salons from Firestore
//   Future<void> fetchSalons() async {
//     try {
//       QuerySnapshot snapshot =
//           await _firestore.collection('salons').get();

//       List<Salon> allSalons = snapshot.docs.map((doc) {
//         return Salon.fromJson(doc.data() as Map<String, dynamic>)
//             ;
//       }).toList();

//       pendingSalons = allSalons.where((s) => s.isApproved==false).toList();
//       approvedSalons = allSalons.where((s) => s.isApproved==true).toList();

//       notifyListeners();
//     } catch (e) {
//       print("Error fetching salons: $e");
//     }
//   }

//   // Approve a salon
//   Future<void> approveSalon(String salonId) async {
//     try {
//       await _firestore.collection('salons').doc(salonId).update({
//         'isApproved': true,
//       });

//       fetchSalons(); // Refresh data after update
//     } catch (e) {
//       print("Error updating salon: $e");
//     }
//   }
// }
