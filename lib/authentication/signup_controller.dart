import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/repository/user_repository.dart';
import 'package:green_cart_1/utils/screens/login_screen.dart';
import 'package:green_cart_1/utils/validators/signup_validation.dart';
import 'package:flutter/material.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final address = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final FirebaseAuth auth;
  final UserRepository userRepo;
  final CollectionReference collRef;

  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  SignUpController(
      {required this.auth, required this.userRepo, required this.collRef});

  Future<void> sendEmailVerification(
      String name, String phone, String address) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        collRef.add({
          'name': name,
          'phone': phone,
        });
        Fluttertoast.showToast(msg: 'Verification email sent');
      } else {
        Fluttertoast.showToast(msg: 'User not signed in');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> onSignUp() async {
    isLoading.value = true;
    hasError.value = true;

    String? nameError = ValidatorSignUp.validateEmptyText(name.text);
    String? emailError = ValidatorSignUp.validateEmail(email.text);
    String? phoneError = ValidatorSignUp.validatePhoneNumber(phoneNumber.text);
    String? passwordError = ValidatorSignUp.validatePassword(password.text);
    String? confirmPasswordError = ValidatorSignUp.validateConfirmPassword(
        confirmPassword.text, password.text);

    if (nameError != null ||
        emailError != null ||
        phoneError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      Fluttertoast.showToast(msg: 'Please correct the errors');
      isLoading.value = false;
      return;
    }

    try {
      await auth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);

      await sendEmailVerification(name.text, phoneNumber.text, address.text);

      Fluttertoast.showToast(
        msg: 'Account has been created, Please verify your email.',
      );

      await auth.signOut();

      Get.offAllNamed(LoginScreen.id);
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'weak-password':
          errorMessage = 'Weak Password';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email Already in use';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }
      Fluttertoast.showToast(msg: errorMessage);
      hasError.value = true;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
