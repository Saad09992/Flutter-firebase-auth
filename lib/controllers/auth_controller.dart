// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth_app/utils/routes/routes_name.dart';
import 'package:firebase_auth_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<User?> _user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  User? get currentUser => _user.value;
  bool get isAuthenticated => _user.value != null;

  @override
  void onInit() {
    super.onInit();
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user.value = user;
      _handleAuthStateChange(user);
    });

    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final storedToken = await _storage.read(key: 'auth_token');
      if (storedToken != null) {
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser != null) {
          final idToken = await currentUser.getIdToken();
          if (idToken == storedToken) {
            _user.value = currentUser;
          } else {
            await _storage.delete(key: 'auth_token');
          }
        }
      }
    } catch (e) {
      print("Error checking auth status: $e");
    }
  }

  Future<void> _handleAuthStateChange(User? user) async {
    if (user != null) {
      try {
        final idToken = await user.getIdToken();
        await _storage.write(key: 'auth_token', value: idToken);
        await _storage.write(key: 'user_id', value: user.uid);
        if (user.email != null) {
          await _storage.write(key: 'user_email', value: user.email);
        }
      } catch (e) {
        print("Error storing auth data: $e");
      }
    } else {
      await _clearAuthData();
    }
  }

  Future<void> _clearAuthData() async {
    try {
      await _storage.delete(key: 'auth_token');
      await _storage.delete(key: 'user_id');
      await _storage.delete(key: 'user_email');
    } catch (e) {
      print("Error clearing auth data: $e");
    }
  }

  Future<bool> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      isLoading.value = true;
      final res = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (res.user != null) {
        Utils.successMessage("Successfully logged in", context);
        Navigator.pushNamed(context, RoutesName.home);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred during sign in";

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email";
          break;
        case 'wrong-password':
          errorMessage = "Wrong password provided";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'user-disabled':
          errorMessage = "This user account has been disabled";
          break;
        case 'too-many-requests':
          errorMessage = "Too many attempts. Please try again later";
          break;
        case 'operation-not-allowed':
          errorMessage = "Email/password sign in is not enabled";
          break;
        case 'network-request-failed':
          errorMessage = "Network error. Please check your connection";
          break;
        default:
          errorMessage = "Error: ${e.message}";
      }

      // Utils.errorMessage(errorMessage, context);
      return false;
    } catch (e) {
      Utils.errorMessage("An unexpected error occurred", context);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUpWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      isLoading.value = true;
      final res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (res.user != null) {
        Utils.successMessage("Account created successfully", context);
        Get.offAllNamed(RoutesName.home);
        return true;
      }
      Get.offAllNamed(RoutesName.home);

      return false;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred during sign up";

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already registered";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address";
          break;
        case 'operation-not-allowed':
          errorMessage = "Email/password sign up is not enabled";
          break;
        case 'weak-password':
          errorMessage = "The password is too weak";
          break;
        default:
          errorMessage = "Error: ${e.message}";
      }

      Utils.errorMessage(errorMessage, context);
      return false;
    } catch (e) {
      Utils.errorMessage("An unexpected error occurred", context);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      // Check if the user is signed in with Google
      final googleUser = await _googleSignIn.signInSilently();
      if (googleUser != null) {
        await _googleSignIn.signOut();
      }

      await _firebaseAuth.signOut();
      await _clearAuthData();
      Utils.successMessage("Successfully logged out", context);
      // Navigator.pushNamed(context, RoutesName.signin);
      Get.offAllNamed(RoutesName.signin);
    } catch (e) {
      Utils.errorMessage("Error signing out", context);
    }
  }

  Future<void> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential cred = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken, idToken: googleAuth!.idToken);

    UserCredential userCreds =
        await FirebaseAuth.instance.signInWithCredential(cred);
    print(userCreds.user.toString());
    Get.offAllNamed(RoutesName.home);
  }
}
