import 'package:flutter/material.dart';

class OrderImages extends StatelessWidget {
  final List images;

  const OrderImages({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return _img("https://picsum.photos/80");
    }

    final displayImages = images.take(3).toList();

    return Row(
      children: [
        ...displayImages.map((img) => _img(img)).toList(),

        /// nếu >3 thì hiện +n
        if (images.length > 3) _more(images.length - 3),
      ],
    );
  }

  Widget _img(String url) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(url, width: 50, height: 50, fit: BoxFit.cover),
      ),
    );
  }

  Widget _more(int count) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "+$count",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
