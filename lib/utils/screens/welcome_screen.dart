import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:green_cart_1/utils/screens/login_screen.dart';
import 'package:green_cart_1/utils/screens/signup_Screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  static const colorizeColors = [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 214, 234, 214),
    Color.fromARGB(255, 209, 231, 184),
    Color.fromARGB(255, 181, 223, 133),
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, upperBound: 170, duration: const Duration(seconds: 1));
    controller?.forward();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'images/green.png',
                          height: controller?.value,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 51, 162, 54)),
                    elevation: MaterialStatePropertyAll(20)),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                child: AnimatedTextKit(animatedTexts: [
                  ColorizeAnimatedText('Sign In',
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'MadimiOne-Regular',
                      ),
                      colors: colorizeColors),
                ]),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 113, 167, 52)),
                    elevation: MaterialStatePropertyAll(20)),
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.id);
                },
                child: AnimatedTextKit(animatedTexts: [
                  ColorizeAnimatedText('Sign Up',
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'MadimiOne-Regular',
                      ),
                      colors: colorizeColors),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
