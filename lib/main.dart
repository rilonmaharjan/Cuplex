import 'package:cuplex/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 813),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: 'Cuplex',
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.rightToLeft,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: const Color.fromARGB(255, 110, 108, 110),
              selectionColor: const Color(0xffecc877).withOpacity(.7),
              selectionHandleColor: const Color.fromARGB(255, 228, 191, 106), 
            ),
          ),
          home: const SplashScreen(),
        );
      }
    );
  }
}
