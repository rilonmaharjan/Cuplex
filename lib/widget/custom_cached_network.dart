import 'package:cuplex/widget/custom_shimmer.dart';
import 'package:flutter/material.dart';


class DisplayNetworkImage extends StatefulWidget {
  const DisplayNetworkImage({
    Key? key,
    required this.imageUrl,
    this.height, 
    this.width, 
    this.fit,
    this.fromPage
  }): super(key: key);
      
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
            : CustomShimmer(
              height: widget.height,
              width: widget.width,
            );
        }, 
        errorBuilder: (context, error, stackTrace) => placeHolder(),
      );
  }

  placeHolder() {
    return Opacity(
      opacity: 1,
      child: Container(color: Colors.grey,)
    );
  }


}