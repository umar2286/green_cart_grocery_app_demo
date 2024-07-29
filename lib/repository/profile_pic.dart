import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> saveData({required Uint8List file}) async {
    String resp = 'Some error has occord';
    try {
      String imageURL = await uploadImageToStorage('profileImage', file);
      await _firestore
          .collection('Profile Picture')
          .add({'imageURL': imageURL});
      resp = 'Success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  Future<String?> getProfileImageURL() async {
    // Retrieve the profile image URL from Firestore
    QuerySnapshot querySnapshot = await _firestore
        .collection('Profile Picture')
        .limit(1)
        .get(); // Assuming there's only one document containing the image URL
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['imageURL'];
    } else {
      return null; // Return null if no image URL found
    }
  }
}

class VendorStoreData {
  Future<String> uploadVendorImageToStorage(
      String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> saveVendorData({required Uint8List file}) async {
    String resp = 'Some error has occord';
    try {
      String imageURL =
          await uploadVendorImageToStorage('vendorImageURL', file);
      await _firestore
          .collection('Vendor Profile')
          .add({'vendorImageURL': imageURL});
      resp = 'Success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  Future<String?> getVendorProfileImageURL() async {
    // Retrieve the profile image URL from Firestore
    QuerySnapshot querySnapshot = await _firestore
        .collection('Vendor Profile')
        .limit(1)
        .get(); // Assuming there's only one document containing the image URL
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['vendorImageURL'];
    } else {
      return null; // Return null if no image URL found
    }
  }
}
