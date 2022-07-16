import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (data.name != 'test') {
        return 'User not exists';
      }
      if (data.password != '123') {
        return 'Password does not match';
      }
      return null;
    });
  }

  Future<String?> signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (name != 'test') {
        return 'User not exists';
      }
      return null;
    });
  }

  Future<String?> signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future loginWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    GoogleAuthProvider authProvider = GoogleAuthProvider();
    try {
      final UserCredential userCredential =
          await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (e) {
      print(e);
    }
  }

  Future logoutGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      GoogleSignIn().signOut();
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
