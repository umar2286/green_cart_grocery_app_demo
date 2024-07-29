import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:green_cart_1/repository/profile_pic.dart';
import 'package:green_cart_1/repository/user_controller.dart';
import 'package:green_cart_1/user/select_profile_pic.dart';
import 'package:green_cart_1/user/user_bottom_navigation.dart';
import 'package:green_cart_1/utils/screens/login_screen.dart';
import 'package:green_cart_1/vendor/vendor_bottom_navbar.dart';
import 'package:image_picker/image_picker.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: BottomNavScreen(),
    );
  }
}

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(const Profile());
          },
          child: const Text('Go to Profile'),
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  static const String id = 'profile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

void signUserOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    print('User signed out successfully');
    // Show a message on the screen
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
    // Navigate back to the login screen
    Get.offAllNamed(
        LoginScreen.id); // Replace '/login' with your login screen route
  } catch (e) {
    'Error signing out: $e';
  }
}

class _ProfileState extends State<Profile> {
  final UserController _userController = Get.put(UserController());
  late String userName = '';

  Future<void> fetchUserData() async {
    // Fetch the user info and update the controller
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

  List<bool> isSelected = [true, false];

  void _navigateToPage(int index) {
    if (index == 0) {
      Get.to(() => BottomNavigationScreen());
    } else {
      Get.to(() => VendorBottomNavigationScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'MadimiOne-Regular',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FutureBuilder<String?>(
                future: StoreData().getProfileImageURL(), // Retrieve image URL
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                        strokeWidth: 5,
                      ),
                    ); // Show loading indicator while waiting for data
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    // Display the downloaded image
                    return Center(
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                          snapshot.data!,
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 167, 187, 173),
                        radius: 100,
                        child: Icon(
                          Icons.person,
                          size: 180,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                },
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
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final data = snapshot.data!;
                  final List<UserInfo> users = data.docs.map((doc) {
                    final userData = doc.data() as Map<String, dynamic>;
                    return UserInfo(
                      userData['name'],
                      userData['phone'],
                    );
                  }).toList();

                  // Assuming there's only one user for simplicity
                  final UserInfo user =
                      users.isNotEmpty ? users[0] : UserInfo("", "");
                  userName = user.name;
                  return Column(
                    children: [
                      Center(
                        child: Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'MadimiOne-Regular',
                          ),
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
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
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
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'MadimiOne-Regular',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 1,
                indent: 10,
                endIndent: 10,
                color: Colors.black87,
                height: 30,
              ),
              const SizedBox(
                height: 20,
              ),
              ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                  _navigateToPage(index);
                },
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('User'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Vendor'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Buttons(
              //   name: '  Order',
              //   icon: const Icon(
              //     Icons.history_rounded,
              //     color: Colors.green,
              //   ),
              //   function: () {},
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              Buttons(
                name: '  Setting',
                icon: const Icon(
                  Icons.settings_rounded,
                  color: Colors.green,
                ),
                function: () {
                  Get.to(() => const ProfileSetting());
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Buttons(
                name: '  Logout',
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.green,
                ),
                function: () {
                  signUserOut(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting>
    with SingleTickerProviderStateMixin {
  Uint8List? _image;
  bool _isSaveButtonVisible = true;
  late FocusNode nameFocusNode;
  late FocusNode phoneFocusNode;
  late FocusNode addressFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    addressFocusNode = FocusNode();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
      _isSaveButtonVisible =
          true; // Show the save button when an image is selected
    });
  }

  void saveProfile() async {
    Get.back();
    await StoreData().saveData(file: _image!);
    if (mounted) {
      setState(() {
        _isSaveButtonVisible = false; // Hide the save button after saving
      });
    }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconButton(
            onPressed: () {
              Get.back(); // Use GetX navigation to go back
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.green,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'MadimiOne-Regular',
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 167, 187, 173),
                        radius: 100,
                        child: Icon(
                          Icons.person,
                          size: 180,
                          color: Colors.white,
                        ),
                      ),
                Positioned(
                  bottom: 0,
                  left: 140,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            focusNode: nameFocusNode,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: nameFocusNode.hasFocus
                    ? Colors.grey
                    : const Color.fromARGB(255, 51, 162, 54),
              ),
              prefixIcon: const Icon(Icons.person_rounded),
              prefixIconColor: nameFocusNode.hasFocus
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
          TextFormField(
            keyboardType: TextInputType.phone,
            focusNode: phoneFocusNode,
            decoration: InputDecoration(
              labelText: 'Phone',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: phoneFocusNode.hasFocus
                    ? Colors.grey
                    : const Color.fromARGB(255, 51, 162, 54),
              ),
              prefixIcon: const Icon(Icons.phone),
              prefixIconColor: phoneFocusNode.hasFocus
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
          TextFormField(
            keyboardType: TextInputType.streetAddress,
            focusNode: addressFocusNode,
            decoration: InputDecoration(
              labelText: 'Addrress',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: addressFocusNode.hasFocus
                    ? Colors.grey
                    : const Color.fromARGB(255, 51, 162, 54),
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.pin_drop),
                iconSize: 30,
                onPressed: () {
                  // openMap();
                },
              ),
              prefixIconColor: addressFocusNode.hasFocus
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
            height: 60,
          ),
          if (_isSaveButtonVisible) // Show the save button only if it's visible
            Center(
              child: ElevatedButton(
                style: const ButtonStyle(
                  minimumSize: MaterialStatePropertyAll(Size(300, 50)),
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                ),
                onPressed: saveProfile,
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final VoidCallback function;
  final Icon icon;
  final String name;

  const Buttons({
    super.key,
    required this.function,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(20),
      ),
      onPressed: function,
      child: Row(
        children: [
          icon,
          Text(
            name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'MadimiOne-Regular',
            ),
          ),
        ],
      ),
    );
  }
}

class UserInfo {
  final String name;
  final String phoneNumber;

  UserInfo(this.name, this.phoneNumber);
}

class FetchDataFromFirestore {
  Stream<List<UserInfo>> getUserInfoStream() {
    return FirebaseFirestore.instance.collection('User Info').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) {
            final userData = doc.data();
            return UserInfo(userData['name'], userData['phone']);
          }).toList(),
        );
  }
}
