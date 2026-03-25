import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final String image;

  const ImageSlider({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: double.infinity,
      color: Colors.grey[200],
      child: Image.network(
        image,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.image),
      ),
    );
  }
}
