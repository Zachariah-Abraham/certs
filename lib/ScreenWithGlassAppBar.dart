import 'package:certs/CustomUI/GlassButtons.dart';
import 'package:flutter/material.dart';
import 'CustomUI/GlassCard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenWithGlassAppBar extends StatelessWidget {
  ScreenWithGlassAppBar(
      {@required this.appBarChild,
      @required this.child,
      Widget leadingChild,
      Widget trailingChild,
      double appBarBorderRadius,
      this.appBarColor: Colors.white,
      double appBarPaddingAll})
      : appBarBorderRadius = appBarBorderRadius ?? 10.r,
        appBarPaddingAll = appBarPaddingAll ?? 15.r,
        leadingChild = leadingChild ?? GlassBackButton(),
        trailingChild = trailingChild ?? Container();
  final double appBarBorderRadius;
  final Color appBarColor;
  final Widget appBarChild;
  final double appBarPaddingAll;
  final Widget leadingChild;
  final Widget trailingChild;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leadingChild ?? Container(),
              // Center(
              //   child:
              GlassCard(
                borderRadius: appBarBorderRadius,
                color: appBarColor,
                paddingAll: appBarPaddingAll,
                child: appBarChild,
              ),

              // ),
              trailingChild ?? Container(),
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   child: leadingChild,
              // ),
              // Positioned(
              //   top: 0,
              //   right: 0,
              //   child: trailingChild,
              // )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: child,
        ),
      ],
    );
  }
}
