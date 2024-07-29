import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/authentication/signup_controller.dart';
import 'package:green_cart_1/repository/user_repository.dart';
import 'package:green_cart_1/utils/screens/login_screen.dart';
import 'package:green_cart_1/utils/validators/signup_validation.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String id = 'registration_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {}
  }

  late FocusNode nameFocusNode;
  late FocusNode emailFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confirmPasswordFocusNode;
  AnimationController? controller;

  static const colorizeColors = [
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.green,
    Color.fromARGB(255, 29, 135, 84),
  ];

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
    controller = AnimationController(
        vsync: this,
        upperBound: 100,
        duration: const Duration(milliseconds: 800));
    controller?.forward();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    controller?.dispose();
    super.dispose();
  }

  // Initialize Firebase Auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Initialize Firestore Collection Reference
  final CollectionReference collRef =
      FirebaseFirestore.instance.collection('User Info');

  // Initialize User Repository if needed
  final UserRepository userRepo = UserRepository();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
        SignUpController(auth: auth, userRepo: userRepo, collRef: collRef));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 100),
                      child: AnimatedTextKit(animatedTexts: [
                        ColorizeAnimatedText('SignUp',
                            textAlign: TextAlign.center,
                            textStyle: const TextStyle(
                              fontSize: 90,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'POORICH',
                            ),
                            colors: colorizeColors),
                      ]),
                    ),
                  ),
                  TextFormField(
                    controller: controller.name,
                    validator: (value) =>
                        ValidatorSignUp.validateEmptyText(value),
                    focusNode: nameFocusNode,
                    onTap: () {
                      setState(() {
                        nameFocusNode.requestFocus();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter your name',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: nameFocusNode.hasFocus
                            ? Colors.grey
                            : const Color.fromARGB(255, 10, 106, 13),
                      ),
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor: nameFocusNode.hasFocus
                          ? Colors.grey
                          : const Color.fromARGB(255, 10, 106, 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 10, 106, 13),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(23.0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: emailFocusNode,
                    controller: controller.email,
                    validator: (value) => ValidatorSignUp.validateEmail(value),
                    onTap: () {
                      setState(() {
                        emailFocusNode.requestFocus();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: emailFocusNode.hasFocus
                            ? Colors.grey
                            : const Color.fromARGB(255, 31, 122, 34),
                      ),
                      prefixIcon: const Icon(Icons.mail),
                      prefixIconColor: emailFocusNode.hasFocus
                          ? Colors.grey
                          : const Color.fromARGB(255, 31, 122, 34),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 31, 122, 34),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(23.0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: phoneFocusNode,
                    controller: controller.phoneNumber,
                    validator: (value) =>
                        ValidatorSignUp.validatePhoneNumber(value),
                    onTap: () {
                      setState(() {
                        phoneFocusNode.requestFocus();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: phoneFocusNode.hasFocus
                            ? Colors.grey
                            : const Color.fromARGB(255, 51, 162, 54),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      prefixIconColor: phoneFocusNode.hasFocus
                          ? Colors.grey
                          : const Color.fromARGB(255, 51, 162, 54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 51, 162, 54),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(23.0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    focusNode: passwordFocusNode,
                    controller: controller.password,
                    validator: (value) =>
                        ValidatorSignUp.validatePassword(value),
                    obscuringCharacter: '•',
                    obscureText:
                        !passwordVisible, // Invert visibility to match initial state
                    onTap: () {
                      setState(() {
                        passwordFocusNode.requestFocus();
                      });
                    },
                    onChanged: (value) {
                      // Show or hide confirm password field based on password field text input
                      setState(() {
                        passwordVisible = value
                            .isNotEmpty; // Show confirm password field if password is not empty
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: passwordFocusNode.hasFocus
                            ? Colors.grey
                            : const Color.fromARGB(255, 113, 167, 52),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            passwordVisible =
                                !passwordVisible; // Toggle password visibility
                          });
                        },
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor: passwordFocusNode.hasFocus
                          ? Colors.grey
                          : const Color.fromARGB(255, 113, 167, 52),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.black87,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 113, 167, 52),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(23.0)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    // Show Confirm Password field only when password is entered
                    visible: passwordVisible,
                    child: TextFormField(
                      focusNode: confirmPasswordFocusNode,
                      validator: (value) =>
                          ValidatorSignUp.validateConfirmPassword(
                              controller.password.text, value),
                      controller: controller.confirmPassword,
                      obscuringCharacter: '•',
                      obscureText:
                          !passwordVisible, // Use the same visibility as password field
                      onTap: () {
                        setState(() {
                          confirmPasswordFocusNode.requestFocus();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: confirmPasswordFocusNode.hasFocus
                              ? Colors.grey
                              : Colors.lightGreen,
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        prefixIconColor: confirmPasswordFocusNode.hasFocus
                            ? Colors.grey
                            : Colors.lightGreen,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.black87,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightGreen,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(23.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 113, 167, 52)),
                          elevation: MaterialStatePropertyAll(20)),
                      onPressed: () async {
                        _submitForm();
                        // Validate the form
                        if (_formKey.currentState!.validate()) {
                          // If form is valid, attempt to sign up
                          setState(() {
                            controller.isLoading.value =
                                true; // Set loading state to true
                          });
                          await controller
                              .onSignUp(); // Call the create account function
                          setState(() {
                            controller.isLoading.value =
                                false; // Set loading state to false after sign up attempt
                          });

                          // Navigate to login screen if sign up is successful
                          if (!controller.hasError.value) {
                            Get.offAllNamed(LoginScreen.id);
                          }
                        }
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Visibility(
                            visible: !controller.isLoading.value,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isLoading.value,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
