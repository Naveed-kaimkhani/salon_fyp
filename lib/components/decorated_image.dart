import 'package:flutter/material.dart';

class DecoratedImage extends StatelessWidget {
  const DecoratedImage({
    super.key,
    required this.image,
    this.radius,
    this.height = 90,
    this.width = 95,
  });
  final double? width;
  final double? radius;
  final String image;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
