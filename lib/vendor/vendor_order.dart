import 'package:flutter/material.dart';

class VendorOrder extends StatefulWidget {
  const VendorOrder({super.key});
  static const String id = 'vendor_order';
  @override
  State<VendorOrder> createState() => _VendorOrderState();
}

class _VendorOrderState extends State<VendorOrder> {
  @override
  Widget build(BuildContext context) {
    // Receive arguments
    final Map? args = ModalRoute.of(context)?.settings.arguments as Map?;

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
                    'Order',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'MadimiOne-Regular'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Total Price: Rs ${args?['totalPrice'] ?? 'Unknown'}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Product Names: ${args?['productNames'] ?? 'Unknown'}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
