import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/user/user_bottom_navigation.dart';
import 'package:green_cart_1/utils/validators/login_validator.dart';

class LogInController extends GetxController {
  static LogInController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Loading state
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  // Function to handle Login
  Future<void> onLogIn() async {
    // Set loading state to true
    isLoading.value = true;
    hasError.value = true;

    // Validate all fields
    String? emailError = ValidatorLogIn.validateEmail(email.text);
    String? passwordError = ValidatorLogIn.validatePassword(password.text);

    // Check if any validation errors exist
    if (emailError != null || passwordError != null) {
      Fluttertoast.showToast(
        msg: 'Email or password is incorrect',
      );
      // Set loading state to false
      isLoading.value = false;
      return; // Exit function without logging in
    }

    try {
      // Sign in with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        // Email not verified, prevent login
        Fluttertoast.showToast(
            msg: 'Please verify your email before logging in.');
        // Sign out the user
        await FirebaseAuth.instance.signOut();
        return;
      }

      // Email is verified, proceed with login
      Fluttertoast.showToast(msg: 'Logged in successfully');
      Get.offAllNamed(BottomNavigationScreen.id);
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions
      if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
          msg: 'Invalid email address',
        );
      } else if (e.code == 'user-disabled') {
        Fluttertoast.showToast(
          msg: 'Your account is disabled',
        );
      } else if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'Account not found',
        );
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: 'Incorrect password',
        );
      } else if (e.code == 'too-many-requests') {
        Fluttertoast.showToast(
          msg: 'Too many request. Please try again later.',
        );
      } else {
        Fluttertoast.showToast(msg: 'Error: ${e.message}');
      }
    } catch (e) {
      // Handle other errors
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }
  }
}
