import 'package:flutter/material.dart';
import 'dart:math' as math;

class WindDirection extends StatelessWidget {
  final double angle;
  final double windSpeed;
  final double windGust;

  WindDirection(
      {required this.angle, required this.windSpeed, required this.windGust});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.rotate(
          angle: angle * math.pi / 180,
          child: Icon(
            Icons.arrow_upward,
            size: 15,
            color: Colors.black,
          ),
        ),
        Text(
          '$windSpeed / ($windGust)',
          style: TextStyle(
            fontSize: 10,
          ),
        )
      ],
    );
  }
}
