import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/authentication/auth_page.dart';
import 'package:green_cart_1/repository/user_controller.dart';
import 'package:green_cart_1/user/user_bottom_navigation.dart';
import 'package:green_cart_1/user/user_category.dart';
import 'package:green_cart_1/user/user_check_out.dart';
import 'package:green_cart_1/user/user_profile.dart';
import 'package:green_cart_1/user/user_store.dart';
import 'package:green_cart_1/utils/database/firebase_options.dart';
import 'package:green_cart_1/utils/screens/forget_password.dart';
import 'package:green_cart_1/utils/screens/login_screen.dart';
import 'package:green_cart_1/utils/screens/onboarding_screen.dart';
import 'package:green_cart_1/utils/screens/signup_Screen.dart';
import 'package:green_cart_1/utils/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:green_cart_1/vendor/vendor_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  ///Widget Binding
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(UserController());
  // Ensure Firebase is initialized only once
  await Firebase.initializeApp(
      name: 'Green Cart 1', options: DefaultFirebaseOptions.currentPlatform);

  final pref = await SharedPreferences.getInstance();
  final onboarding = pref.getBool('onBoarding') ?? false;

  runApp(GreenCart1(onboarding: onboarding));
}

class GreenCart1 extends StatefulWidget {
  final bool onboarding;
  const GreenCart1({super.key, required this.onboarding});

  @override
  State<GreenCart1> createState() => _GreenCart1State();
}

class _GreenCart1State extends State<GreenCart1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.black54),
          ),
        ),
        initialRoute: SplashScreen.id,
        home: const AuthPage(),
        getPages: [
          GetPage(
              name: '/${OnboardingView.id}',
              page: () => const OnboardingView()),
          GetPage(
              name: '/${SplashScreen.id}', page: () => const SplashScreen()),
          GetPage(name: '/${LoginScreen.id}', page: () => const LoginScreen()),
          GetPage(
              name: '/${ForgotPasswordScreen.id}',
              page: () => const ForgotPasswordScreen()),
          GetPage(
              name: '/${SignUpScreen.id}', page: () => const SignUpScreen()),
          GetPage(
            name: '/${BottomNavigationScreen.id}',
            page: () => BottomNavigationScreen(),
          ),
          GetPage(
            name: '/${VendorBottomNavigationScreen.id}',
            page: () => VendorBottomNavigationScreen(),
          ),
          // Define the "category" route
          GetPage(name: '/${Category.id}', page: () => const Category()),
          GetPage(name: '/${Profile.id}', page: () => const Profile()),
          GetPage(name: '/${Store.id}', page: () => const Store()),
          GetPage(name: '/${CheckOut.id}', page: () => const CheckOut()),
        ],
      ),
    );
  }
}
