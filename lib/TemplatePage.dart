import 'package:certs/CustomUI/GlassButtons.dart';
import 'package:certs/CustomUI/GlassCard.dart';
import 'package:certs/ScreenWithGlassAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'ImportAttendeesPage.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'Config.dart';
import 'ResizableWidgetWithImage.dart';
import 'CustomUI/GradientContainer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// TODO: Make UI responsive to orientation changes

class TemplatePage extends StatefulWidget {
  TemplatePage({this.templateImage});
  final templateImage;
  @override
  State<TemplatePage> createState() {
    return TemplatePageState();
  }
}

class TemplatePageState extends State<TemplatePage> {
  // GlobalKey imageKey = GlobalKey();
  GlobalKey resizeableContainerKeyOne = GlobalKey();
  GlobalKey resizeableContainerKeyTwo = GlobalKey();
  double fontSizeName = Config.fontSizeName.value;
  Color currentColorName = Config.fontColorName.value;
  // double fontSizePosition = 20;
  // Color currentColorPosition = Colors.black;
  // GlobalKey tempImageKey = GlobalKey();
  GlobalKey tempResizeKey = GlobalKey();
  GlobalKey imageKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    Config.fontSizeName.addListener(() {
      setState(() {
        fontSizeName = Config.fontSizeName.value;
      });
    });
    Config.fontColorName.addListener(() {
      setState(() {
        currentColorName = Config.fontColorName.value;
      });
    });
    // imageKey = GlobalKey();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        colors: [Colors.purple, Colors.blue],
        child: ScreenWithGlassAppBar(
          appBarChild: Text(
            "Position the name",
            textScaleFactor: 1.5.sp,
          ),
          child: OrientationBuilder(builder: (context, orientation) {
            return orientation == Orientation.landscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: CertWidget(
                          currentColorName: currentColorName,
                          fontSizeName: fontSizeName,
                          imageKey: imageKey,
                          resizeableContainerKeyOne: resizeableContainerKeyOne,
                          templateImage: widget.templateImage,
                          tempResizeKey: tempResizeKey,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: ConfigWidget(
                          currentColorName: currentColorName,
                          fontSizeName: fontSizeName,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: CertWidget(
                          currentColorName: currentColorName,
                          fontSizeName: fontSizeName,
                          imageKey: imageKey,
                          resizeableContainerKeyOne: resizeableContainerKeyOne,
                          templateImage: widget.templateImage,
                          tempResizeKey: tempResizeKey,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ConfigWidget(
                          currentColorName: currentColorName,
                          fontSizeName: fontSizeName,
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
      floatingActionButton: GlassTextButton(
        text: "Done",
        borderRadius: 10.0.r,
        paddingAll: 30.0.r,
        onPressed: () async {
          RenderRepaintBoundary boundary =
              imageKey.currentContext.findRenderObject();
          Config.boundaryHeight = boundary.size.height;
          Config.boundaryWidth = boundary.size.width;
          // getWindowInfo().then((window) {
          //   Size size = Size(window.frame.width, window.frame.height);
          //   setWindowMinSize(size);
          //   setWindowMaxSize(size);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ImportAttendeesPage(),
            ),
          );
          // });
        },
      ),
    );
  }
}

class CertWidget extends StatelessWidget {
  CertWidget({
    @required this.imageKey,
    @required this.templateImage,
    @required this.tempResizeKey,
    @required this.resizeableContainerKeyOne,
    @required this.currentColorName,
    @required this.fontSizeName,
  });
  final imageKey;
  final templateImage;
  final tempResizeKey;
  final resizeableContainerKeyOne;
  final currentColorName;
  final fontSizeName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child:
          // Stack(
          //   children: [
          //     Image.file(
          //       widget.templateImage,
          //     ),
          //     Positioned(
          //       child:
          Center(
        child: RepaintBoundary(
          key: imageKey,
          child: ResizebleWidgetsWithImage(
            image: templateImage,
            key: tempResizeKey,
            containerKeyOne: resizeableContainerKeyOne,
            // containerKeyTwo: resizeableContainerKeyTwo,
            childName: Text(
              "Arapurayil Zachariah Abraham",
              style: TextStyle(
                color: currentColorName,
                fontSize: fontSizeName,
              ),
            ),
            // childPosition: Text(
            //   "Vice-Chairperson, IEEE SRM SB",
            //   style: TextStyle(
            //     color: currentColorPosition,
            //     fontSize: fontSizePosition,
            //   ),
            // ),
          ),
        ),
      ),
    );
    //     ),
    //   ],
    // ),
    // ),
  }
}

class ConfigWidget extends StatefulWidget {
  ConfigWidget({
    @required this.fontSizeName,
    @required this.currentColorName,
  });
  final fontSizeName;
  final currentColorName;
  @override
  State<StatefulWidget> createState() {
    return ConfigWidgetState();
  }
}

class ConfigWidgetState extends State<ConfigWidget> {
  var fontSizeName;
  var currentColorName;

  @override
  void initState() {
    super.initState();
    fontSizeName = widget.fontSizeName;
    currentColorName = widget.currentColorName;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0.r),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GlassCard(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: Text(
                      "Font size (name): ${fontSizeName * 2 ~/ 1 / 2}",
                      textScaleFactor: 1.5.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.5),
                      min: 10,
                      max: 72,
                      value: fontSizeName,
                      onChanged: (value) {
                        setState(() {
                          fontSizeName = value;
                          Config.fontSizeName.value = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0.r),
                    child: Text(
                      "Font color (name): (${currentColorName.red}, ${currentColorName.green}, ${currentColorName.blue})",
                      textScaleFactor: 1.5.sp,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0.sp),
                    child: ColorPicker(
                      pickerColor: currentColorName,
                      // displayThumbColor: true,
                      onColorChanged: (newColor) {
                        setState(() {
                          currentColorName = newColor;
                          Config.fontColorName.value = newColor;
                        });
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Text(
                  //     "Font size (position): ${fontSizePosition * 2 ~/ 1 / 2}",
                  //     textScaleFactor: 1.5,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Slider(
                  //     activeColor: Colors.white,
                  //     inactiveColor: Colors.white.withOpacity(0.5),
                  //     min: 10,
                  //     max: 72,
                  //     value: fontSizePosition,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         fontSizePosition = value;
                  //         Config.fontSizePosition = value;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: Text(
                  //     "Font color (position): (${currentColorPosition.red}, ${currentColorPosition.green}, ${currentColorPosition.blue})",
                  //     textScaleFactor: 1.5,
                  //   ),
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.all(10.0),
                  //   child: ColorPicker(
                  //     pickerColor: currentColorPosition,
                  //     onColorChanged: (newColor) {
                  //       setState(() {
                  //         currentColorPosition = newColor;
                  //         Config.fontColorPosition = newColor;
                  //       });
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
