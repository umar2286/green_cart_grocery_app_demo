import 'package:flutter/material.dart';
import 'package:green_cart_1/utils/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  static const String id = 'onboarding_view';

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = OnboardingItems();
  final pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[700],
      bottomSheet: Container(
        color: Colors.lightGreen[700],
        child: isLastPage
            ? getStarted(context)
            : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //Skip Button
                TextButton(
                  onPressed: () {
                    pageController.animateToPage(controller.items.length - 1,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn);
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                        color: Color.fromARGB(255, 94, 93, 93),
                        fontWeight: FontWeight.w800,
                        fontSize: 18),
                  ),
                ),

                //Indicator
                SmoothPageIndicator(
                  controller: pageController,
                  count: controller.items.length,
                  effect: const WormEffect(
                    activeDotColor: Color.fromARGB(255, 94, 93, 93),
                  ),
                  onDotClicked: (index) => pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn),
                ),

                //Next Button
                TextButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                          color: Color.fromARGB(255, 94, 93, 93),
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    )),
              ]),
      ),
      body: PageView.builder(
          onPageChanged: (index) =>
              setState(() => isLastPage = controller.items.length - 1 == index),
          itemCount: controller.items.length,
          controller: pageController,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      controller.items[index].image ?? 'images/green.png'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    controller.items[index].title ?? "Loading",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    controller.items[index].description ?? "Loading",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }),
    );
  }

//Get Started Button
  Widget getStarted(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey[700], borderRadius: BorderRadius.circular(12)),
        width: MediaQuery.of(context).size.width * .9,
        height: 55,
        child: TextButton(
            onPressed: () async {
              final press = await SharedPreferences.getInstance();
              press.setBool('onBoarding', true);

              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: Text(
              'Get started',
              style: TextStyle(
                  color: Colors.lightGreen[700],
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            )));
  }
}

class OnboardingInfo {
  final String? title;
  final String? description;
  final String? image;

  OnboardingInfo(
      {@required this.title, @required this.description, @required this.image});
}

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: 'Search',
        description:
            'You can easily search all the fruits and vegitables available on shops ',
        image: 'images/Search.png'),
    OnboardingInfo(
        title: 'Buy',
        description:
            'You can easily search all the fruits and vegitables available on shops ',
        image: 'images/Buy.png'),
    OnboardingInfo(
        title: 'Delivery',
        description:
            'You can easily search all the fruits and vegitables available on shops ',
        image: 'images/Delivery.png'),
  ];
}
