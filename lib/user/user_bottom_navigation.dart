import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/user/user_calling.dart';
import 'package:green_cart_1/user/user_cart.dart';
import 'package:green_cart_1/user/user_category.dart';
import 'package:green_cart_1/user/user_explore.dart';
import 'package:green_cart_1/user/user_profile.dart';

class BottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class BottomNavigationScreen extends StatelessWidget {
  static const String id = 'bottom_navigation';

  final BottomNavigationController _controller =
      Get.put(BottomNavigationController());

  BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => IndexedStack(
            index: _controller.selectedIndex.value,
            children: const [
              Explore(),
              Category(),
              Calling(),
              Cart(),
              Profile(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            unselectedItemColor: const Color.fromARGB(255, 165, 166, 166),
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                label: 'Category',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.phone_outlined),
                label: 'Call',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ],
            currentIndex: _controller.selectedIndex.value,
            selectedItemColor: Colors.green,
            onTap: _controller.changeIndex,
          )),
    );
  }
}
