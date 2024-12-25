import 'package:cuplex/constant/styles.dart';
import 'package:cuplex/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: Lock orientation for mobile platforms
  if (GetPlatform.isMobile) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 813), // Adjust designSize based on your app's design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          title: 'Cuplex',
          debugShowCheckedModeBanner: false,
          defaultTransition: Transition.rightToLeft,
          theme: buildAppTheme(),
          home: const SplashScreen(),
        );
      },
    );
  }

}
