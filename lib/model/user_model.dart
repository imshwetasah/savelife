import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String firstName;
  final String lastName;
  final String city;
  final String email;
  final String phone;
  final String gender;
  final String bloodGroup;

  const UserModel({
    this.uid,
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.email,
    required this.phone,
    required this.gender,
    required this.bloodGroup,
  });

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      uid: document.id,
      firstName: data["first name"],
      lastName: data["last name"],
      city: data["city"],
      email: data["email"],
      phone: data["phone"],
      gender: data["gender"],
      bloodGroup: data["blood group"],
    );
  }
}
