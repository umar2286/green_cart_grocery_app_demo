import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:green_cart_1/vendor/vendor_home.dart';
import 'package:green_cart_1/vendor/vendor_order.dart';
import 'package:green_cart_1/vendor/vendor_profile.dart';

class VendorBottomNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}

class VendorBottomNavigationScreen extends StatelessWidget {
  static const String id = 'vendor_bottom_navigation';

  final VendorBottomNavigationController _controller =
      Get.put(VendorBottomNavigationController());

  VendorBottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => IndexedStack(
            index: _controller.selectedIndex.value,
            children: const [
              VendorHome(),
              VendorOrder(),
              VendorProfile(),
            ],
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            unselectedItemColor: const Color.fromARGB(255, 165, 166, 166),
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.timer_outlined),
                label: 'Order',
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
