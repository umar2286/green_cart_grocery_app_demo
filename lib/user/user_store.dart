import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:green_cart_1/user/user_cart.dart'; // Import the user_cart file which contains the CartController
import 'package:green_cart_1/utils/database/firebase_datafetch.dart'; // Import the firebase_datafetch file

class Store extends StatefulWidget {
  const Store({super.key});
  static const id = 'store';

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  late FocusNode? searchStoreFocusNode;
  late String title;
  late String image;
  late String address;

  final List<Map<String, dynamic>> _products = [];
  final List<Map<String, dynamic>> _allProducts = [];
  final List<Map<String, dynamic>> _dryFruitProducts = [];
  final List<Map<String, dynamic>> _frozenProducts = [];
  final List<String> categories = [
    'Product',
    'Dry Fruit',
    'Frozen',
  ];

  @override
  void initState() {
    super.initState();
    searchStoreFocusNode = FocusNode();
    title = Get.parameters['title'] ?? 'Gourmet Foods';
    image = Get.parameters['image'] ?? 'images/adds/gourmet.jpeg';
    address = Get.parameters['address'] ??
        'Bundu Khan Sweets and Bakers, C7WJ+75Q, opposite zakir tikka, Block D Pia Housing Scheme, Lahore, Punjab 54770, Pakistan';
  }

  @override
  void dispose() {
    searchStoreFocusNode?.dispose();
    super.dispose();
  }

  void onDataFetched(
      List<Map<String, dynamic>> productData,
      List<Map<String, dynamic>> dryFruitData,
      List<Map<String, dynamic>> frozenData) {
    if (mounted) {
      setState(() {
        _allProducts.addAll(productData);
        _dryFruitProducts.addAll(dryFruitData);
        _frozenProducts.addAll(frozenData);
        _products.addAll(_allProducts); // Show all products initially
      });
    }
  }

  void updateProducts(String category) {
    setState(() {
      _products.clear();
      if (category == 'Product') {
        _products.addAll(_allProducts);
      } else if (category == 'Dry Fruit') {
        _products.addAll(_dryFruitProducts);
      } else if (category == 'Frozen') {
        _products.addAll(_frozenProducts);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isBase64Image = image.startsWith('data:image/');
    final imageBytes = isBase64Image ? base64Decode(image.split(',')[1]) : null;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 100.0),
                    child: Text(
                      'Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'MadimiOne-Regular'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: isBase64Image
                        ? Image.memory(imageBytes!,
                            width: 150, height: 150, fit: BoxFit.contain)
                        : Image.asset(image,
                            width: 150, height: 150, fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200, // Adjust this width to prevent overflow
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black87,
                                fontFamily: 'MadimiOne-Regular',
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: 200, // Adjust this width to prevent overflow
                          child: Text(
                            "Address: $address",
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontFamily: 'MadimiOne-Regular',
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                focusNode: searchStoreFocusNode,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: searchStoreFocusNode?.hasFocus ?? false
                        ? Colors.grey
                        : const Color.fromARGB(255, 51, 162, 54),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: searchStoreFocusNode?.hasFocus ?? false
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
                height: 10,
              ),
              DataFetch(
                  onDataFetched: onDataFetched), // Add DataFetch widget here
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 360,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return ChangeCategory(
                              catName: categories[index],
                              onCategorySelected: updateProducts,
                            );
                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 360,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    var product = _products[index];
                    return AddProduct(
                      image: product['image'] ?? 'images/adds/image1.jpg',
                      title: product['name'] ?? 'No Name',
                      price: product['price'] ?? 0,
                      weight: product['weight'] ?? 0,
                      unit: product['unit'] ?? '',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AddProduct extends StatefulWidget {
  String title;
  int weight;
  String unit;
  String image;
  int price;

  AddProduct({
    required this.title,
    required this.unit,
    required this.weight,
    required this.image,
    required this.price,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool isAdded = false;

  void toggleAdded() {
    setState(() {
      isAdded = !isAdded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isBase64Image = widget.image.startsWith('data:image/');
    final imageBytes =
        isBase64Image ? base64Decode(widget.image.split(',')[1]) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 70, 135, 72), Colors.grey],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          width: 360,
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: isBase64Image
                      ? Image.memory(imageBytes!,
                          width: 120, height: 120, fit: BoxFit.cover)
                      : Image.asset(widget.image,
                          width: 120, height: 120, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'MadimiOne-Regular',
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.weight}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.unit,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'MadimiOne-Regular',
                            color: Colors.white54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Rs. ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${widget.price}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontFamily: 'MadimiOne-Regular',
                            color: Color.fromARGB(255, 255, 166, 2),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        CartController cartController = Get.find();
                        cartController.addItem(widget);
                        Get.to(Cart()); // Navigate to the cart screen
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white60,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 100,
                        height: 40,
                        child: const Center(
                          child: Text(
                            'Check Out',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MadimiOne-Regular',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: !isAdded,
                      child: GestureDetector(
                        onTap: () {
                          toggleAdded();
                          CartController cartController = Get.find();
                          cartController.addItem(widget);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 100,
                          height: 40,
                          child: const Center(
                            child: Text(
                              '+ Add',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MadimiOne-Regular',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isAdded,
                      child: GestureDetector(
                        onTap: () {
                          toggleAdded();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 100,
                          height: 40,
                          child: const Center(
                            child: Text(
                              'Added',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'MadimiOne-Regular',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeCategory extends StatelessWidget {
  final String catName;
  final ValueChanged<String> onCategorySelected;

  const ChangeCategory({
    super.key,
    required this.catName,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onCategorySelected(catName),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 40.0, vertical: 5.0), // Adjusted padding
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey, Color.fromARGB(255, 45, 69, 46)],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              catName,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontFamily: 'MadimiOne-Regular',
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
