import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  Auth._();
  static final _instance = Auth._();
  static Auth get i => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  signUpAnon() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      rethrow;
    }
  }

  signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Stream<User?> get authState => _auth.authStateChanges();
}
