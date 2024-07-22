
import 'package:flutter/material.dart';
 import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:specor/home.dart';
import 'package:specor/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat1.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
        designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: false,
    builder: (context, Widget? child) {
      return MaterialApp(debugShowCheckedModeBanner: false,

          home: Login()
      );
    }); }
}


