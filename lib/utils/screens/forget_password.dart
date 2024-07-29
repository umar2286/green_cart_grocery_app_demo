import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String id = 'forgot_password_screen';

  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent.'),
          duration: Duration(seconds: 2),
        ),
      );
      // Navigate back to the login screen
      Navigator.pop(context);
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  FocusNode? emailFocusNode;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    emailFocusNode = FocusNode();
    controller = AnimationController(
        vsync: this,
        upperBound: 100,
        duration: const Duration(milliseconds: 800));
    controller?.forward();
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    emailFocusNode!.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        '      Forgot Password',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontFamily: 'MadimiOne-Regular',
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              textAlign: TextAlign.center,
              'Enter your email address to receive a password reset link.',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              focusNode: emailFocusNode,
              controller: _emailController,
              onTap: () {
                setState(() {
                  emailFocusNode!.requestFocus();
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your valid email',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: emailFocusNode!.hasFocus
                      ? Colors.grey
                      : const Color.fromARGB(255, 51, 162, 54),
                ),
                prefixIcon: const Icon(Icons.mail),
                prefixIconColor: emailFocusNode!.hasFocus
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
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.all(14)),
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 51, 162, 54),
                  ),
                  elevation: MaterialStatePropertyAll(20),
                ),
                child: const Text(
                  'Send Password Reset Email',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
