import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text/common/widgets/common_textField.dart';
import 'package:text/image_uploading/image_uploading_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _RegistrationSCreenState();
}

class _RegistrationSCreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in with Firebase using the Google Auth credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Do something with the userCredential, like navigating to a new screen
    } catch (error) {
      print('Error during Google sign-in: $error');
    }
  }

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
            SizedBox(
              height: 10.h,
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'or sign up with',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6F6F6F),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  GestureDetector(
                    onTap: _handleGoogleSignIn,
                    child: Container(
                      height: 42.h,
                      width: 86.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.r),
                        ),
                      ),
                      child: Image.asset('assets/png/google-icon.png'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('User logged in: ${userCredential.user!.email}');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ImageUploadingScreen(),
        ),
      );
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
