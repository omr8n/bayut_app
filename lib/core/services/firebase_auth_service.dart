import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
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
        case 'weak-password': throw CustomException(message: 'الرقم السري ضعيف جداً.');
        case 'email-already-in-use': throw CustomException(message: 'لقد قمت بالتسجيل مسبقاً. الرجاء تسجيل الدخول.');
        case 'network-request-failed': throw CustomException(message: 'تأكد من اتصالك بالانترنت.');
        default: throw CustomException(message: 'حدث خطأ، حاول مرة أخرى.');
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
        case 'invalid-credential': throw CustomException(message: 'البريد أو كلمة المرور غير صحيحة.');
        case 'network-request-failed': throw CustomException(message: 'تأكد من اتصالك بالانترنت.');
        default: throw CustomException(message: 'حدث خطأ، حاول مرة أخرى.');
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
        case 'user-not-found': throw CustomException(message: 'هذا البريد غير مسجل لدينا.');
        case 'invalid-email': throw CustomException(message: 'البريد الإلكتروني غير صحيح.');
        case 'network-request-failed': throw CustomException(message: 'تأكد من اتصالك بالانترنت.');
        default: throw CustomException(message: 'حدث خطأ، حاول مرة أخرى لاحقاً.');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
  }
}
