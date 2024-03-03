import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:text/common/widgets/common_textField.dart';
import 'package:text/image_uploading/image_uploading_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _RegistrationSCreenState();
}

class _RegistrationSCreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            // Center(
            //   child: Text(
            //     'Create your account',
            //     style: TextStyle(fontSize: 18.sp),
            //   ),
            // ),
            SizedBox(height: 20.h),
            CommonTextFiled(
              hintText: 'Email',
              controller: _emailController,
            ),
            SizedBox(
              height: 5.h,
            ),
            CommonTextFiled(
              hintText: 'password',
              controller: _passwordController,
            ),
            ElevatedButton(
              onPressed: () {
                _login();
                _emailController.text = '';
                _passwordController.text = '';
              },
              child: Text('login'),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('User logged in: ${userCredential.user!.email}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageUploadingScreen()),
      );
    } catch (e) {
      print('Error during login: $e');
      // Handle login errors (e.g., display error message)
    }
  }
}
