import 'package:flutter/material.dart';
import 'dart:math' as math;

class WindDirection extends StatelessWidget {
  final int angle;

  WindDirection({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle * math.pi / 180,
      child: Icon(
        Icons.arrow_upward,
        color: Colors.black,
      ),
    );
  }
}
