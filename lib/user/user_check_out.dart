import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/repository/user_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_cart_1/user/user_cart.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});
  static const String id = 'checkout';

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final UserController _userController = Get.put(UserController());
  final CartController cartController = Get.put(CartController());
  late String userName = '';

  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cardExpiryController = TextEditingController();
  final TextEditingController cardCVCController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('User Info').get();
    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs.first.data();
      _userController.setUserName(userData['name']);
      setState(() {
        userName = userData['name'];
      });
    }
  }

  int get totalPrice {
    int total = 0;
    for (var item in cartController.cartItems) {
      total += item.price;
    }
    return total;
  }

  final List<Map<String, String>> paymentMethods = [
    {
      'name': 'Credit Card (MasterCard)',
      'image': 'images/payment/mastercard.png',
    },
    {
      'name': 'Credit Card (Visa)',
      'image': 'images/payment/visacard.png',
    },
    {
      'name': 'Credit Card (SadaPay)',
      'image': 'images/payment/sadapay.png',
    },
    {
      'name': 'Cash on Delivery',
      'image': 'images/payment/cachondelivery.png',
    },
  ];

  final RxString selectedPaymentMethod = 'Credit Card (MasterCard)'.obs;

  bool get isFormValid {
    if (selectedPaymentMethod.value == 'Credit Card (MasterCard)' ||
        selectedPaymentMethod.value == 'Credit Card (Visa)' ||
        selectedPaymentMethod.value == 'Credit Card (SadaPay)') {
      return cardNameController.text.isNotEmpty &&
          cardExpiryController.text.isNotEmpty &&
          cardCVCController.text.isNotEmpty;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 80.0),
                    child: Center(
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'MadimiOne-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Your delivery details',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'MadimiOne-Regular',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('User Info')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final data = snapshot.data!;
                  final List<UserInfo> users = data.docs.map((doc) {
                    final userData = doc.data() as Map<String, dynamic>;
                    return UserInfo(userData['name'], userData['phone']);
                  }).toList();

                  final UserInfo user =
                      users.isNotEmpty ? users[0] : UserInfo('', '');
                  userName = user.name;
                  return Column(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'MadimiOne-Regular',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          user.phoneNumber,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: 'MadimiOne-Regular',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w100,
                            fontFamily: 'MadimiOne-Regular',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            'Total Price: Rs $totalPrice',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'MadimiOne-Regular',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 160),
                        child: const Text(
                          'PAYMENT METHOD',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'MadimiOne-Regular',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => DropdownButton<String>(
                          value: selectedPaymentMethod.value,
                          items: paymentMethods.map((method) {
                            return DropdownMenuItem<String>(
                              value: method['name']!,
                              child: Row(
                                children: [
                                  Image.asset(
                                    method['image']!,
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    method['name']!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'MadimiOne-Regular',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedPaymentMethod.value = newValue;
                              setState(() {});
                            }
                          },
                          isExpanded: true,
                        ),
                      ),
                      Obx(() {
                        if (selectedPaymentMethod.value ==
                                'Credit Card (MasterCard)' ||
                            selectedPaymentMethod.value ==
                                'Credit Card (Visa)' ||
                            selectedPaymentMethod.value ==
                                'Credit Card (SadaPay)') {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              TextField(
                                controller: cardNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Card Name',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) => setState(() {}),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: cardExpiryController,
                                decoration: const InputDecoration(
                                  labelText: 'Expiry Date (MM/YY)',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) => setState(() {}),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: cardCVCController,
                                decoration: const InputDecoration(
                                  labelText: 'CVC',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => setState(() {}),
                              ),
                              const SizedBox(height: 30),
                            ],
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 121, 117, 117),
                            elevation: 20,
                          ),
                          onPressed: isFormValid
                              ? () {
                                  placeOrder();
                                }
                              : null,
                          child: const Text(
                            'Place Order',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'MadimiOne-Regular',
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void placeOrder() {
    // Perform order placement logic here
    Get.snackbar(
      'Your Order has been placed',
      'You have selected ${selectedPaymentMethod.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
    cartController.clearCart(); // Clear the cart
    Navigator.pop(context); // Navigate back to the cart screen
  }
}

class UserInfo {
  final String name;
  final String phoneNumber;

  UserInfo(this.name, this.phoneNumber);
}
