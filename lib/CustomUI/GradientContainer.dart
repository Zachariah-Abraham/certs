import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  GradientContainer({@required this.colors, @required this.child});

  final List<Color> colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
