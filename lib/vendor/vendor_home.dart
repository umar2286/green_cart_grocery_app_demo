import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:green_cart_1/utils/database/firebase_datafetch.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});
  static const id = 'vendor_home';

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  FocusNode? searchStoreFocusNode;

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
    setState(() {
      _allProducts.addAll(productData);
      _dryFruitProducts.addAll(dryFruitData);
      _frozenProducts.addAll(frozenData);
      _products.addAll(_allProducts); // Show all products initially
    });
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Vendor Store',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'MadimiOne-Regular',
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 51, 162, 54), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(23.0)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DataFetch(
                  onDataFetched: onDataFetched), // Add DataFetch widget here
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ChangeCategory(
                      catName: categories[index],
                      onCategorySelected: updateProducts,
                    );
                  },
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

class AddProduct extends StatefulWidget {
  final String title;
  final int weight;
  final String unit;
  final String image;
  final int price;

  const AddProduct({
    Key? key,
    required this.title,
    required this.unit,
    required this.weight,
    required this.image,
    required this.price,
  }) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    final bool isBase64Image = widget.image.startsWith('data:image/');
    final imageBytes =
        isBase64Image ? base64Decode(widget.image.split(',')[1]) : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 70, 135, 72), Colors.grey],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        width: double.infinity,
        height: 120,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: isBase64Image
                  ? Image.memory(imageBytes!,
                      width: 120, height: 120, fit: BoxFit.cover)
                  : Image.asset(widget.image,
                      width: 120, height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'MadimiOne-Regular',
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
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
                        ),
                        Text(
                          widget.unit,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Rs. ${widget.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'MadimiOne-Regular',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
