import 'package:cuplex/widget/custom_shimmer.dart';
import 'package:flutter/material.dart';


class DisplayNetworkImage extends StatefulWidget {
  const DisplayNetworkImage({
    Key? key,
    required this.imageUrl,
    this.height, 
    this.width, 
    this.fit,
    this.fromPage, this.isFromCarousel, 
  }): super(key: key);
      
  final bool? isFromCarousel;
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? fromPage;

  @override
  State<DisplayNetworkImage> createState() => _DisplayNetworkImageState();
}

class _DisplayNetworkImageState extends State<DisplayNetworkImage> {

  @override
  Widget build(BuildContext context) {
    return widget.imageUrl == "null" || widget.imageUrl.isEmpty || widget.imageUrl == ''
    ? placeHolder()
    :  Image.network(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit ?? BoxFit.cover,
        headers: const { "Connection": "Keep-Alive"},
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress == null
            ? child
            : widget.isFromCarousel == true
            ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              width: widget.width,
              height: widget.height,
            ) 
            : CustomShimmer(
              radius: 6,
              height: widget.height,
              width: widget.width,
            );
        }, 
        errorBuilder: (context, error, stackTrace) => placeHolder(),
      );
  }

  placeHolder() {
    return widget.isFromCarousel == true
    ? Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.withOpacity(.3),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      width: widget.width,
      height: widget.height,
    ) 
    : Opacity(
      opacity: 1,
      child: Image.asset(
        "assets/images/logo.jpg",
        width: widget.width,
        height: widget.height,
        fit: widget.fit ??  BoxFit.cover,
      ),
    );
  }


}