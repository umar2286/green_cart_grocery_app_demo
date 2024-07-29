import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/user/user_store.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  static const String id = 'category';

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category>
    with SingleTickerProviderStateMixin {
  late FocusNode? searchCatFocusNode;
  final TextEditingController searchController = TextEditingController();

  final List<String> imageUrls = [
    'images/category/images11.jpeg',
    'images/category/images12.jpg',
    'images/category/images13.jpg',
    'images/category/images14.jpg',
    'images/category/images15.jpg',
    'images/category/images16.jpg',
    'images/category/images17.jpg',
    'images/category/images18.jpg',
    'images/category/images19.jpg',
    'images/category/images20.jpg',
    'images/category/images21.jpg',
  ];

  final List<String> category = [
    'Meat',
    'Sea Food',
    'Fruits',
    'Vegitables',
    'Grains',
    'Bakery',
    'Softdrinks',
    'dairy',
    'Dryfruits',
    'Frozen',
  ];

  List<String> filteredCategories = [];
  List<String> filteredImages = [];

  @override
  void initState() {
    super.initState();
    searchCatFocusNode = FocusNode();
    filteredCategories = List.from(category);
    filteredImages = List.from(imageUrls);
  }

  @override
  void dispose() {
    searchCatFocusNode?.dispose();
    searchController.dispose();
    super.dispose();
  }

  void filterCategories(String query) {
    List<String> tempCategories = [];
    List<String> tempImages = [];

    for (int i = 0; i < category.length; i++) {
      if (category[i].toLowerCase().contains(query.toLowerCase())) {
        tempCategories.add(category[i]);
        tempImages.add(imageUrls[i]);
      }
    }

    setState(() {
      filteredCategories = tempCategories;
      filteredImages = tempImages;
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
                    'Category',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'MadimiOne-Regular'),
                  ),
                ),
              ),
              TextFormField(
                focusNode: searchCatFocusNode,
                controller: searchController,
                onChanged: (query) {
                  filterCategories(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: searchCatFocusNode?.hasFocus ?? false
                        ? Colors.grey
                        : const Color.fromARGB(255, 51, 162, 54),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: searchCatFocusNode?.hasFocus ?? false
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
              SizedBox(
                height: 590,
                width: 370,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      return AddCategory(
                        title: 'AA',
                        image: filteredImages[index],
                        catName: filteredCategories[index],
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

class AddCategory extends StatelessWidget {
  final String catName;
  final String image;

  const AddCategory(
      {super.key,
      required this.catName,
      required this.image,
      required String title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: TextButton(
        child: Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.fromARGB(255, 41, 104, 43), Colors.grey]),
              borderRadius: BorderRadius.circular(20)),
          width: 160,
          height: 170,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  width: 150,
                  height: 120,
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    catName,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'MadimiOne-Regular'),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        onPressed: () {
          Get.to(Store());
        },
      ),
    );
  }
}
