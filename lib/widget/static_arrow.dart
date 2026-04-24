import 'package:flutter/material.dart';

class StaticArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double iconSize;
  final double paddingSize;

  const StaticArrow({
    super.key,
    required this.icon,
    required this.onTap,
    required this.iconSize,
    required this.paddingSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(paddingSize),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black38,
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }
}