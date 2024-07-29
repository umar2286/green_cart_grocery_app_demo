import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/user/user_category.dart';
import 'package:green_cart_1/user/user_check_out.dart';
import 'package:green_cart_1/user/user_store.dart';

// Import your AddProduct class and CartController

class CartController extends GetxController {
  final RxList<AddProduct> cartItems = <AddProduct>[].obs;
// var cartItems = <CartItem>[].obs;

  List<String> get productNames {
    return cartItems.map((item) => item.title).toList();
  }

  void clearCart() {
    cartItems.clear();
  }

  void addItem(AddProduct item) {
    cartItems.add(item);
  }

  void removeItem(AddProduct item) {
    cartItems.remove(item);
  }

  bool get isCartEmpty => cartItems.isEmpty;
}

class Cart extends StatefulWidget {
  const Cart({super.key});

  static const String id = 'cart';

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartController cartController = Get.put(CartController());

  int get totalPrice {
    int total = 0;
    for (var item in cartController.cartItems) {
      total += item.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Cart',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'MadimiOne-Regular',
                  ),
                ),
              ),
            ),
            if (cartController.isCartEmpty)
              const SizedBox(
                height: 300,
                child: Center(
                  child: Text(
                    'Cart is empty 🥲 Click to add something',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MadimiOne-Regular',
                      fontWeight: FontWeight.w800,
                      fontSize: 19,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  final bool isBase64Image =
                      item.image.startsWith('data:image/');
                  final imageBytes = isBase64Image
                      ? base64Decode(item.image.split(',')[1])
                      : null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: isBase64Image
                            ? Image.memory(
                                imageBytes!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                item.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                      ),
                      title: Text(item.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Weight: ${item.weight} gms'),
                          Text('Price: Rs ${item.price}'),
                          // Add more details here if needed
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (item.weight > 0) {
                                  item.weight -=
                                      100; // Decrease weight by 100 grams
                                  item.price -= (item.price.toInt() ~/
                                      10); // Decrease price accordingly
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                item.weight +=
                                    100; // Increase weight by 100 grams
                                item.price += (item.price.toInt() ~/
                                    10); // Increase price accordingly
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              cartController.removeItem(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (!cartController.isCartEmpty) const SizedBox(height: 30),
            if (!cartController.isCartEmpty)
              Center(
                child: Text(
                  'Total Price: Rs $totalPrice',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: Obx(
                () => cartController.isCartEmpty
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 51, 162, 54),
                          elevation: 20,
                        ),
                        onPressed: () {
                          Get.toNamed(Category.id);
                        },
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'MadimiOne-Regular',
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 121, 117, 117),
                          elevation: 20,
                        ),
                        onPressed: () {
                          Get.toNamed(CheckOut.id, arguments: {
                            "totalPrice": totalPrice,
                            "productNames": cartController.productNames
                          });
                        },
                        child: const Text(
                          'Check Out',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontFamily: 'MadimiOne-Regular',
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class AddProduct1 {
  final String title; // Add this field
  int price;
  int weight;
  final String image;

  AddProduct1({
    required this.title,
    required this.price,
    required this.weight,
    required this.image,
  });
}
