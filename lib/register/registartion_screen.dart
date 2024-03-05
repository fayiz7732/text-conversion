import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:text/common/widgets/common_textField.dart';
import 'package:text/login/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

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
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  validatePassword(String? value) {
    final passwordValidator = value?.trim();
    if (passwordValidator!.isEmpty) {
      return 'Enter your password';
    }
    if (passwordValidator.length < 8) {
      return 'The password must be greater than or equal to 8';
    }
    if (!RegExp(r'[A-Z]').hasMatch(passwordValidator)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordValidator)) {
      return 'Password must contain at least one special character';
    }
    if (!RegExp(r'[0-9]').hasMatch(passwordValidator)) {
      return 'Password must contain at least one number digit';
    }
    if (passwordValidator.length > 40) {
      return 'password length must not exceed 40';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                const Title(
                  title: 'Name',
                ),
                CommonTextFiled(
                  hintText: 'ex:john smith',
                  controller: _nameController,
                  validator: (value) {
                    final name = value!.trim();
                    if (name.isEmpty) {
                      return "Name is required";
                    }
                    if (name.length < 3) {
                      return "Name must be at least 3 characters";
                    }
                    if (name.length > 30) {
                      return "Name must be less than or equal to 30 characters";
                    }
                    if (name.length < 3) {
                      return "Name must be at least 3 characters";
                    }
                    return null;
                  },
                ),
                const Title(
                  title: 'Email',
                ),
                CommonTextFiled(
                  hintText: 'ex:john.smith@email.com',
                  controller: _emailController,
                  validator: (value) {
                    final email = value!.trim();
                    if (email.isEmpty) {
                      return "Email is required";
                    }
                    if (!EmailValidator.validate(email)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                const Title(
                  title: 'Password',
                ),
                CommonTextFiled(
                  validator: (value) {
                    final password = value!.trim();
                    final passwordError = validatePassword(password);

                    if (passwordError != null) {
                      // _passwordNode.requestFocus();
                    }

                    return passwordError;
                  },
                  hintText: '************',
                  controller: _passwordController,
                ),
                const Title(
                  title: 'Confirm Password',
                ),
                CommonTextFiled(
                  hintText: '************',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    final password = _passwordController.text.trim();
                    final confirmPass = value!.trim();
                    if (confirmPass.isEmpty) {
                      // _confirmPasswordNode.requestFocus();
                      return "Confirm your password";
                    }
                    if (password != confirmPass) {
                      return "The Password doesn't match";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        formKey.currentState!.validate();
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Already have an account? ',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6F6F6F),
                            ),
                          ),
                        ),
                        TextSpan(
                            text: 'Login Now',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 90, 213, 2),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
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

class Title extends StatelessWidget {
  const Title({super.key, required this.title});
  final String? title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.h,
        top: 10.h,
      ),
      child: Text(
        title ?? '',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6F6F6F),
          ),
        ),
      ),
    );
  }
}
