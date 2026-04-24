import 'package:flutter/material.dart';

class CategoryCardWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final int index;

  const CategoryCardWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.index,
  });

  // Tumhara color palette maine is widget ke andar daal diya hai
  static final List<Color> _colorPalette = [
    Colors.red.shade200, Colors.blue.shade200, Colors.green.shade200,
    Colors.orange.shade200, Colors.purple.shade200, Colors.teal.shade200,
    Colors.pink.shade200, Colors.indigo.shade200, Colors.cyan.shade400,
    Colors.deepOrange.shade400, Colors.amber.shade200, Colors.lightBlue.shade200,
    Colors.lightGreen.shade200, Colors.brown.shade400, Colors.blueGrey.shade400,
    Colors.deepPurple.shade400,
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap, // 🚀 Jo bhi function pass karoge, wo yahan chalega
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: _colorPalette[index % _colorPalette.length],
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}