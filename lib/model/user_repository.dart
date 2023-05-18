import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savelife/constants/image_strings.dart';
import 'package:savelife/model/user_model.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("donors").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

    return userData;
  }

  Future<List<UserModel>> getDonorDetails(String email) async {
    final snapshot = await _db
        .collection("Donors")
        .where("blood group", isEqualTo: bloodGroup)
        .get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();

    return userData;
  }
}
