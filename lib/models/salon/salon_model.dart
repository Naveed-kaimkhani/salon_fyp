import 'package:cloud_firestore/cloud_firestore.dart';

class Salon {
  final String? uid;
  final String? businessName;
  final String? ownerName;
  final String? phoneNumber;
  final String? email;
  final String? businessAddress;
  final String? operatingHours;
  final String? businessLicenseUrl;
  final String? idProofUrl;
  final String? password;
  final String? confirmPassword;
  final DateTime? createdAt ;
  Salon({
     this.uid,
    required this.businessName,
    required this.ownerName,
    required this.phoneNumber,
    required this.email,
     this.businessAddress,
     this.password,
     this.confirmPassword,
     this.operatingHours,
     this.businessLicenseUrl,
     this.idProofUrl,
     this.createdAt,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      uid: json['uid'],
      businessName: json['businessName'],
      ownerName: json['ownerName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      businessAddress: json['businessAddress'],
      operatingHours: json['operatingHours'],
      businessLicenseUrl: json['businessLicenseUrl'],
      idProofUrl: json['idProofUrl'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'businessName': businessName,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'email': email,

      'businessAddress': businessAddress,
      'operatingHours': operatingHours,
      'businessLicenseUrl': businessLicenseUrl,
      'idProofUrl': idProofUrl,
      'createdAt': createdAt,
    };
  }
}
