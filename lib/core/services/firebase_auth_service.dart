import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // 🔥 استيراد المكتبة
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
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Auth Error: ${e.code}");
      switch (e.code) {
        case 'weak-password':
          throw CustomException(message: 'الرقم السري ضعيف جداً.');
        case 'email-already-in-use':
          throw CustomException(
            message: 'لقد قمت بالتسجيل مسبقاً. الرجاء تسجيل الدخول.',
          );
        case 'network-request-failed':
          throw CustomException(message: 'تأكد من اتصالك بالانترنت.');
        default:
          throw CustomException(message: 'حدث خطأ، حاول مرة أخرى.');
      }
    }
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Auth Error: ${e.code}");
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          throw CustomException(message: 'البريد أو كلمة المرور غير صحيحة.');
        case 'network-request-failed':
          throw CustomException(message: 'تأكد من اتصالك بالانترنت.');
        default:
          throw CustomException(message: 'حدث خطأ، حاول مرة أخرى.');
      }
    }
  }

  // 🔥 دالة تسجيل الدخول بواسطة جوجل

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  // final GoogleSignIn signIn = GoogleSignIn.instance;
  //   unawaited(
  //     signIn.initialize(clientId: clientId, serverClientId: serverClientId).then((
  //       _,
  //     ) {
  //       signIn.authenticationEvents
  //           .listen(_handleAuthenticationEvent)
  //           .onError(_handleAuthenticationError);

  //       /// This example always uses the stream-based approach to determining
  //       /// which UI state to show, rather than using the future returned here,
  //       /// if any, to conditionally skip directly to the signed-in state.
  //       signIn.attemptLightweightAuthentication();
  //     }),
  //   );
  // }

  Future<void> signOut() async {
    //  await GoogleSignIn().signOut(); // الخروج من جوجل أيضاً
    await _auth.signOut();
  }

  Future<void> deleteUser() async {
    await _auth.currentUser?.delete();
  }
}
