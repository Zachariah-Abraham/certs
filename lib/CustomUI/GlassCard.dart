import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassCard extends StatelessWidget {
  GlassCard(
      {double borderRadius,
      this.color: Colors.white,
      @required this.child,
      double paddingAll})
      : borderRadius = borderRadius ?? 10.r,
        paddingAll = paddingAll ?? 40.r;

  final double paddingAll;
  final double borderRadius;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(paddingAll),
        child: child,
      ),
    ).asGlass(
        tintColor: color,
        clipBorderRadius: BorderRadius.circular(borderRadius));
  }
}
