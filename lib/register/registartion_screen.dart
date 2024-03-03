import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:text/common/widgets/common_textField.dart';
import 'package:text/login/login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            Center(
              child: Text(
                'Create your account',
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
            SizedBox(height: 20.h),
            CommonTextFiled(
              hintText: 'Email',
              controller: _emailController,
            ),
            SizedBox(height: 5.h),
            CommonTextFiled(
              hintText: 'Password',
              controller: _passwordController,
            ),
            ElevatedButton(
              onPressed: () async {
                await _register();
                _emailController.clear();
                _passwordController.clear();
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('User registered: ${userCredential.user!.email}');
      // Navigate to the login screen after successful registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Error during registration: $e');
      // Handle registration errors (e.g., display error message)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
