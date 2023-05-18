import 'package:firebase_auth/firebase_auth.dart';
import 'package:savelife/model/user_repository.dart';

class ProfileController {
  final user = FirebaseAuth.instance.currentUser;
  final userRepo = UserRepository();
  getUserData() {
    final email = user!.email;
    if (email != null) {
      return userRepo.getUserDetails(email);
    }
  }
}
