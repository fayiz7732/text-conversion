import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:text/common/widgets/common_textField.dart';
import 'package:text/login/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Center(
                child: Text(
                  'Create your account',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  'Name',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6F6F6F),
                    ),
                  ),
                ),
              ),
              CommonTextFiled(
                hintText: 'ex:john smith',
                controller: _nameController,
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  top: 10.h,
                ),
                child: Text(
                  'Email',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6F6F6F),
                    ),
                  ),
                ),
              ),
              CommonTextFiled(
                hintText: 'ex:john.smith@email.com',
                controller: _emailController,
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  top: 10.h,
                ),
                child: Text(
                  'Password',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6F6F6F),
                    ),
                  ),
                ),
              ),
              CommonTextFiled(
                hintText: '************',
                controller: _passwordController,
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: 10.h,
                  top: 10.h,
                ),
                child: Text(
                  'Confirm Password',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6F6F6F),
                    ),
                  ),
                ),
              ),
              CommonTextFiled(
                hintText: '************',
                controller: _confirmPasswordController,
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _register();
                      _emailController.clear();
                      _passwordController.clear();
                      _nameController.clear();
                      _confirmPasswordController.clear();
                    },
                    style: ButtonStyle(
                      // Adjusted the maximumSize constraints to fit within the acceptable range

                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xFF00288F)),
                    ),
                    child: const Text('SignUp'),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Text(
                  'or sign up with',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6F6F6F),
                    ),
                  ),
                ),
              ),
              Container(
                height: 42.h,
                width: 86.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.r),
                  ),
                ),
                child: SvgPicture.asset('assets\png\googlePng.png'),
              ),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
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
        const SnackBar(
          content: Text('Registration failed please try again later '),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
