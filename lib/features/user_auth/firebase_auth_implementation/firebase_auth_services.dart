import 'package:firebase_auth/firebase_auth.dart';

import '../../../global/common/toast.dart';


class FirebaseAuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {

    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      // Update user profile with username
      await credential.user?.updateDisplayName(username);
      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }

    }
    return null;

  }

  // Method to get the currently signed-in user's username
  Future<String?> getUsername() async {
    try {
      User? user = _auth.currentUser;
      // You need to implement a way to fetch the username associated with the user here.
      // For example, if you store the username in the user's profile, you can return it like this:
      // return user?.displayName;
      // Replace 'displayName' with the field where you store the username in the user's profile.
      // If the username is not stored in the profile, you need to fetch it from your database or any other source.
      return user
          ?.displayName; // This assumes username is stored in displayName field.
    } catch (e) {
      print('Error fetching username: $e');
      return null;
    }
  }

}
