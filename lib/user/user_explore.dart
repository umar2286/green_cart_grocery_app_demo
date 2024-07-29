import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/repository/profile_pic.dart';
import 'package:green_cart_1/repository/user_controller.dart';
import 'package:green_cart_1/user/user_profile.dart';
import 'package:green_cart_1/user/user_store.dart';
import 'package:green_cart_1/utils/database/firebase_datafetch.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  static const String id = 'explore';

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with SingleTickerProviderStateMixin {
  late FocusNode? searchFocusNode;
  final UserController _userController = Get.find<UserController>();

  final List<Map<String, dynamic>> _stores = [];
  final List<Map<String, dynamic>> _allStores = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchFocusNode?.dispose();
    super.dispose();
  }

  void onStoreDataFetched(
    List<Map<String, dynamic>> storeData,
  ) {
    setState(() {
      _allStores.addAll(storeData);
      _stores.addAll(_allStores); // Show all products initially
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'images/adds/image1.jpg',
      'images/adds/image2.jpg',
      'images/adds/image9.jpg',
      'images/adds/images3.jpeg',
      'images/adds/images4.jpeg',
      'images/adds/images5.jpeg',
      'images/adds/images6.jpeg',
      'images/adds/images7.jpeg',
      'images/adds/images8.jpeg',
    ];

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Obx(
                            () => Text(
                              'Hi, ${_userController.getUserName()}',
                              style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'MadimiOne-Regular'),
                            ),
                          ),
                          const Text(
                            'Location',
                            style: TextStyle(
                                color: Color.fromARGB(255, 167, 187, 173),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'MadimiOne-Regular'),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Profile.id);
                        },
                        child: FutureBuilder<String?>(
                          future: StoreData()
                              .getProfileImageURL(), // Retrieve image URL
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator(
                                color: Colors.green,
                              ); // Show loading indicator while waiting for data
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              // Display the downloaded image
                              return Center(
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                    snapshot.data!,
                                  ),
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromARGB(255, 167, 187, 173),
                                  radius: 30,
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: searchFocusNode?.hasFocus ?? false
                        ? Colors.grey
                        : const Color.fromARGB(255, 51, 162, 54),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: searchFocusNode?.hasFocus ?? false
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
                height: 20,
              ),
              StoreDataFetch(onStoreDataFetched: onStoreDataFetched),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                child: Row(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 360,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            return AddTiles(
                              title: imageUrls[index],
                            );
                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Near by stores',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black87,
                    fontFamily: 'MadimiOne-Regular',
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 360,
                width: 360,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _stores.length,
                    itemBuilder: (context, index) {
                      var store = _stores[index];
                      return AddStores(
                        image: store['image'] ?? 'images/adds/image1.jpg',
                        title: store['name'] ?? 'No Name',
                        distance: store['distance'] ?? 0,
                        address: store['address'] ?? 'Empty',
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTiles extends StatelessWidget {
  final String title;
  const AddTiles({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.amber, borderRadius: BorderRadius.circular(20)),
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              title,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class AddStores extends StatefulWidget {
  final String title;
  final String image;
  final String address;
  final int distance;

  const AddStores({
    super.key,
    required this.title,
    required this.image,
    required this.distance,
    required this.address,
  });

  @override
  State<AddStores> createState() => _AddStoresState();
}

class _AddStoresState extends State<AddStores> {
  bool isPressed = false;

  void toggleStar() {
    setState(() {
      isPressed = !isPressed;
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
        child: GestureDetector(
          onTap: () {
            Get.toNamed(
              Store.id,
              parameters: {
                'title': widget.title,
                'image': widget.image,
                'address': widget.address,
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color.fromARGB(255, 41, 104, 43), Colors.grey]),
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20)),
            width: 360,
            height: 120,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
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
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                              fontSize: 22, fontFamily: 'MadimiOne-Regular'),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${widget.distance} km',
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'MadimiOne-Regular',
                            color: Colors.white60),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: IconButton(
                    icon: Icon(
                      isPressed ? Icons.star : Icons.star_border,
                      color: const Color.fromARGB(255, 215, 198, 39),
                    ),
                    onPressed: () {
                      toggleStar();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
