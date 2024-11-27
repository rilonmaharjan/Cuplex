import 'package:cuplex/constant/constant.dart';
import 'package:cuplex/widget/custom_cached_network.dart';
import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Use an AspectRatio or SizedBox to constrain the image
            DisplayNetworkImage(
              imageUrl: "$posterUrl$image",
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: Colors.orange,
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
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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