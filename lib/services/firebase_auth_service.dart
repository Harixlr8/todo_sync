import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
Future<User?> createUser(String email, String password, String displayName) async {
  try {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.user?.updateDisplayName(displayName);

    // Instead of reload + _auth.currentUser, return result.user
    return result.user;
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  }
}

}
