import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:green_cart_1/utils/database/firebase_datafetch.dart';

class Calling extends StatefulWidget {
  const Calling({super.key});

  static const String id = 'category';

  @override
  State<Calling> createState() => _CallingState();
}

class _CallingState extends State<Calling> {
  FocusNode? searchCallFocusNode;
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> _stores = [];
  final List<Map<String, dynamic>> _allStores = [];

  @override
  void initState() {
    super.initState();
    searchCallFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchCallFocusNode?.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onStoreDataFetched(List<Map<String, dynamic>> storeData) {
    setState(() {
      _allStores.addAll(storeData);
      _stores.addAll(_allStores); // Show all products initially
    });
  }

  void filterStores(String query) {
    List<Map<String, dynamic>> filteredStores = _allStores
        .where((store) =>
            store['name']?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    setState(() {
      _stores.clear();
      _stores.addAll(filteredStores);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Contact',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'MadimiOne-Regular',
                    ),
                  ),
                ),
              ),
              TextFormField(
                focusNode: searchCallFocusNode,
                controller: searchController,
                onChanged: (query) {
                  filterStores(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: searchCallFocusNode?.hasFocus ?? false
                        ? Colors.grey
                        : const Color.fromARGB(255, 51, 162, 54),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: searchCallFocusNode?.hasFocus ?? false
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
              SizedBox(
                height: 600,
                width: 360,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _stores.length,
                  itemBuilder: (context, index) {
                    var store = _stores[index];
                    return AddCalls(
                      image: store['image'] ?? 'images/adds/image1.jpg',
                      title: store['name'] ?? 'No Name',
                      distance: store['distance'] ?? 0,
                      phone: store['number'] ?? 0,
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

class AddCalls extends StatefulWidget {
  final String title;
  final String image;
  final int distance;
  final int phone;

  const AddCalls({
    super.key,
    required this.title,
    required this.image,
    required this.distance,
    required this.phone,
  });

  @override
  State<AddCalls> createState() => _AddCallsState();
}

class _AddCallsState extends State<AddCalls> {
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
              colors: [Color.fromARGB(255, 41, 104, 43), Colors.grey],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          width: 360,
          height: 100,
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
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    Text(
                      '${widget.phone}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'MadimiOne-Regular',
                        color: Colors.white60,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${widget.distance} km',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'MadimiOne-Regular',
                        color: Colors.white60,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    openExternalApp('${widget.phone}');
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

Future<void> openExternalApp(String phoneNumber) async {
  final uri = Uri(scheme: 'tel', path: phoneNumber);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $phoneNumber');
  }
}
