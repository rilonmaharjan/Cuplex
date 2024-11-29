import 'dart:async';

import 'package:cuplex/views/home_tab_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _spinAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _bounceAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );

    _spinAnimation = Tween<double>(begin: 0, end: 2 * 3.14159) 
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 100), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 200 * (1 - _bounceAnimation.value)),
                    child: Transform.rotate(
                      angle: _spinAnimation.value, 
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Transform.scale(
                          scale: 1.4.sp,
                          child: Image.asset(
                            "assets/images/logo.jpg", 
                            width: 160.w,
                            height: 160.h,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
