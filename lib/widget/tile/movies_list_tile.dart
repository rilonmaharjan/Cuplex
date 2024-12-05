import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String year;
  final double rating;
  final String image;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.title,
    required this.year,
    required this.rating,
    required this.image, 
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 0.5,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.grey.withOpacity(.3),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Use an AspectRatio or SizedBox to constrain the image
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: DisplayNetworkImage(
                imageUrl: "$posterUrl$image",
              ),
            ),
            year == "" 
            ? const SizedBox()
            : Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
                decoration: const BoxDecoration(
                  color: Color(0xffecc877),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6)
                  ),
                ),
                child: Text(
                  year,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            rating == 0.0
            ? const SizedBox()
            : Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 2.sp),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    topRight: Radius.circular(6)
                  ),
                ),
                child: Text(
                  rating.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}