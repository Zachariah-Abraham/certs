import 'Config.dart';
import 'package:flutter/material.dart';
import 'CustomUI/GradientContainer.dart';
import 'ScreenWithGlassAppBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Config.googleAuthClient.close();
    return Scaffold(
      body: GradientContainer(
        colors: [Colors.purple, Colors.blue],
        child: ScreenWithGlassAppBar(
          appBarChild: Container(),
          appBarPaddingAll: 0.0,
          appBarBorderRadius: 0.0,
          child: Center(
            child: Text(
              "All done!",
              textScaleFactor: 5.0.sp,
            ),
          ),
        ),
      ),
    );
  }
}
