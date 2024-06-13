import 'package:flutter/material.dart';
import 'menuiconpainter.dart';
class MenuIcon extends StatelessWidget {
  final Color color;
  final double size;

  const MenuIcon({
    Key? key,
    this.color = Colors.black,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MenuIconPainter(color: color),
      size: Size(size, size * 4 + 3 * 4.0),
    );
  }
}