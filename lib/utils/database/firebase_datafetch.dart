import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataFetch extends StatefulWidget {
  final Function(List<Map<String, dynamic>>, List<Map<String, dynamic>>,
      List<Map<String, dynamic>>) onDataFetched;

  const DataFetch({super.key, required this.onDataFetched});

  @override
  // ignore: library_private_types_in_public_api
  _DataFetchState createState() => _DataFetchState();
}

class _DataFetchState extends State<DataFetch> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    var firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qm = await firestoreInstance.collection('Products').get();
    QuerySnapshot qn = await firestoreInstance.collection('DryFruits').get();
    QuerySnapshot qo = await firestoreInstance.collection('Frozen').get();

    List<Map<String, dynamic>> tempProductData = [];
    List<Map<String, dynamic>> tempDryFruitData = [];
    List<Map<String, dynamic>> tempFrozenData = [];

    for (var doc in qm.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            tempProductData.add(item as Map<String, dynamic>);
          }
        }
      });
    }

    for (var doc in qn.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            tempDryFruitData.add(item as Map<String, dynamic>);
          }
        }
      });
    }

    for (var doc in qo.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            tempFrozenData.add(item as Map<String, dynamic>);
          }
        }
      });
    }

    widget.onDataFetched(tempProductData, tempDryFruitData, tempFrozenData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // This widget doesn't need to display anything
  }
}

//
class StoreDataFetch extends StatefulWidget {
  const StoreDataFetch({super.key, required this.onStoreDataFetched});

  final Function(List<Map<String, dynamic>>) onStoreDataFetched;
  @override
  State<StoreDataFetch> createState() => _StoreDataFetchState();
}

class _StoreDataFetchState extends State<StoreDataFetch> {
  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  Future<void> fetchStores() async {
    var firestoreInstance = FirebaseFirestore.instance;
    QuerySnapshot qr = await firestoreInstance.collection('Stores').get();

    List<Map<String, dynamic>> tempStoresData = [];
    for (var doc in qr.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is List) {
          for (var item in value) {
            tempStoresData.add(item as Map<String, dynamic>);
          }
        }
      });
    }
    widget.onStoreDataFetched(tempStoresData);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
