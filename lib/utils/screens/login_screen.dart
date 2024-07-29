import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/authentication/login_controller.dart';
import 'package:green_cart_1/user/user_bottom_navigation.dart';
import 'package:green_cart_1/utils/screens/forget_password.dart';
import 'package:green_cart_1/utils/screens/signup_Screen.dart';
import 'package:green_cart_1/utils/validators/login_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool passwordVisible = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {}
  }

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
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
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
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
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LogInController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                        horizontal: 30, vertical: 50.0),
                    child: AnimatedTextKit(animatedTexts: [
                      ColorizeAnimatedText('SignIn',
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
                  focusNode: emailFocusNode,
                  controller: controller.email,
                  validator: (value) => ValidatorLogIn.validateEmail(value),
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
                          : const Color.fromARGB(255, 51, 162, 54),
                    ),
                    prefixIcon: const Icon(Icons.mail),
                    prefixIconColor: emailFocusNode.hasFocus
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
                  height: 30,
                ),
                TextFormField(
                  focusNode: passwordFocusNode,
                  controller: controller.password,
                  validator: (value) => ValidatorLogIn.validatePassword(value),
                  obscuringCharacter: '•',
                  obscureText: passwordVisible,
                  onTap: () {
                    setState(() {
                      passwordFocusNode.requestFocus();
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
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ForgotPasswordScreen.id);
                      },
                      child: const Text(
                        'Forget password?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color.fromARGB(255, 51, 162, 54),
                          fontFamily: 'MadimiOne-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New to Green Cart?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontFamily: 'MadimiOne-Regular',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: const Text(
                        'SignUp',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 51, 162, 54),
                          fontFamily: 'MadimiOne-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 51, 162, 54),
                      ),
                      elevation: MaterialStatePropertyAll(20),
                    ),
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
                            .onLogIn(); // Call the create account function
                        setState(() {
                          controller.isLoading.value =
                              false; // Set loading state to false after sign up attempt
                        });

                        // Navigate to login screen if sign up is successful
                        if (!controller.hasError.value) {
                          Get.offAllNamed(BottomNavigationScreen.id);
                        }
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Visibility(
                          visible: !controller.isLoading.value,
                          child: const Text(
                            'Sign In',
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
    );
  }
}
