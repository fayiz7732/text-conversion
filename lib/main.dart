import 'package:flutter/material.dart';
import 'package:text/firebase_options.dart';
import 'package:text/register/registartion_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: const Size(360, 690),
      builder: (ctx, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
          
            useMaterial3: false,
          ),
          home: const RegistrationScreen()),
    );
  }
}
