import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import '../language/lang_keys.dart';
import '../errors/exceptions.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Auth Error: ${e.code}");
      switch (e.code) {
        case 'weak-password': throw CustomException(message: LangKeys.weakPassword);
        case 'email-already-in-use': throw CustomException(message: LangKeys.emailAlreadyInUse);
        case 'network-request-failed': throw CustomException(message: LangKeys.networkRequestFailed);
        default: throw CustomException(message: LangKeys.unexpectedError);
      }
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Auth Error: ${e.code}");
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential': throw CustomException(message: LangKeys.invalidCredential);
        case 'network-request-failed': throw CustomException(message: LangKeys.networkRequestFailed);
        default: throw CustomException(message: LangKeys.unexpectedError);
      }
    }
  }

  // 🔥 إصلاح إرسال إيميل إعادة التعيين
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      log("Reset Password Error: ${e.code}");
      switch (e.code) {
        case 'user-not-found': throw CustomException(message: LangKeys.userNotFound);
        case 'invalid-email': throw CustomException(message: LangKeys.invalidEmail);
        case 'network-request-failed': throw CustomException(message: LangKeys.networkRequestFailed);
        default: throw CustomException(message: LangKeys.passwordResetError);
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      log("Update Password Error: ${e.code}");
      switch (e.code) {
        case 'weak-password': throw CustomException(message: LangKeys.weakPassword);
        case 'requires-recent-login': throw CustomException(message: LangKeys.requiresRecentLogin);
        default: throw CustomException(message: LangKeys.updatePasswordError);
      }
    }
  }

  Future<void> reauthenticate({required String email, required String password}) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
      await _auth.currentUser?.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      log("Reauth Error: ${e.code}");
      throw CustomException(message: LangKeys.currentPasswordIncorrect);
    }
  }

  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
  }
}
