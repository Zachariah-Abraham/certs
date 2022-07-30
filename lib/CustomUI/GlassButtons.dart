import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassButton extends StatelessWidget {
  GlassButton(
      {double borderRadius,
      @required this.onPressed,
      double paddingAll,
      this.color: Colors.white,
      @required this.child})
      : borderRadius = borderRadius ?? 10.r,
        paddingAll = paddingAll ?? 40.r;

  final double borderRadius;
  final Function onPressed;
  final Widget child;
  final double paddingAll;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.r),
      child: MaterialButton(
        padding: EdgeInsets.all(paddingAll),
        child: child,
        onPressed: onPressed,
      ).asGlass(
        tintColor: color,
        clipBorderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class GlassTextButton extends StatelessWidget {
  GlassTextButton(
      {this.textColor: Colors.white,
      double borderRadius,
      @required this.onPressed,
      double textScale,
      double paddingAll,
      this.color: Colors.white,
      @required this.text})
      : borderRadius = borderRadius ?? 10.r,
        textScale = textScale ?? 1.25.sp,
        paddingAll = paddingAll ?? 40.r;

  final Color textColor;
  final double borderRadius;
  final Function onPressed;
  final double textScale;
  final String text;
  final double paddingAll;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      borderRadius: borderRadius,
      onPressed: onPressed,
      paddingAll: paddingAll,
      color: color,
      child: Text(
        text,
        textScaleFactor: textScale,
        style: TextStyle(color: textColor),
      ),
    );
  }
}

class GlassBackButton extends StatelessWidget {
  GlassBackButton({
    this.iconColor: Colors.white,
    double borderRadius,
    double iconSize,
    double paddingAll,
    this.color: Colors.white,
  })  : borderRadius = borderRadius ?? 10.r,
        iconSize = iconSize ?? 15.r,
        paddingAll = paddingAll ?? 30.r;

  final Color iconColor;
  final double borderRadius;
  final double iconSize;
  final double paddingAll;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      borderRadius: borderRadius,
      onPressed: () => Navigator.of(context).pop(),
      paddingAll: paddingAll,
      color: color,
      child: Icon(
        Icons.arrow_back,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
