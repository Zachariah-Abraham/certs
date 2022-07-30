import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'Config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResizebleWidgetsWithImage extends StatefulWidget {
  ResizebleWidgetsWithImage(
      {this.key,
      @required this.childName,
      @required this.image,
      // @required this.childPosition,
      @required this.containerKeyOne,
      // @required this.containerKeyTwo,
      this.height,
      this.width,
      this.top,
      this.left});
  final Key key;
  final Widget childName;
  // final Widget childPosition;
  final Uint8List image;
  final GlobalKey containerKeyOne;
  // final GlobalKey containerKeyTwo;
  final double height;
  final double width;
  final double top;
  final double left;
  @override
  _ResizebleWidgetsWithImageState createState() =>
      _ResizebleWidgetsWithImageState();
}

const ballDiameter = 10.0;

class _ResizebleWidgetsWithImageState extends State<ResizebleWidgetsWithImage> {
  double heightOne;
  double widthOne;

  double topOne;
  double leftOne;

  double initXOne;
  double initYOne;

  // double heightTwo;
  // double widthTwo;

  // double topTwo;
  // double leftTwo;

  // double initXTwo;
  // double initYTwo;

  @override
  initState() {
    super.initState();
    heightOne = widget.height ?? 100.r;
    widthOne = widget.width ?? 400.r;

    topOne = widget.top ?? 0;
    leftOne = widget.left ?? 0;

    // heightTwo = widget.height ?? 100;
    // widthTwo = widget.width ?? 400;

    // topTwo = widget.top ?? 0;
    // leftTwo = widget.left ?? 0;
  }

  _handleDragOne(details) {
    setState(() {
      initXOne = details.globalPosition.dx;
      initYOne = details.globalPosition.dy;
    });
  }

  _handleUpdateOne(details) {
    var dx = details.globalPosition.dx - initXOne;
    var dy = details.globalPosition.dy - initYOne;
    initXOne = details.globalPosition.dx;
    initYOne = details.globalPosition.dy;
    onDragOne(dx, dy);
  }

  void onDragOne(dx, dy) {
    setState(() {
      topOne = topOne + dy;
      leftOne = leftOne + dx;
    });
  }
  // void onDrag(double dx, double dy) {
  //   var newHeight = height + dy;
  //   var newWidth = width + dx;

  //   setState(() {
  //     height = newHeight > 0 ? newHeight : 0;
  //     width = newWidth > 0 ? newWidth : 0;
  //   });
  // }

  // _handleDragTwo(details) {
  //   setState(() {
  //     initXTwo = details.globalPosition.dx;
  //     initYTwo = details.globalPosition.dy;
  //   });
  // }

  // _handleUpdateTwo(details) {
  //   var dx = details.globalPosition.dx - initXTwo;
  //   var dy = details.globalPosition.dy - initYTwo;
  //   initXTwo = details.globalPosition.dx;
  //   initYTwo = details.globalPosition.dy;
  //   onDragTwo(dx, dy);
  // }

  // void onDragTwo(dx, dy) {
  //   setState(() {
  //     topTwo = topTwo + dy;
  //     leftTwo = leftTwo + dx;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Config.topOne = topOne;
    Config.leftOne = leftOne;
    Config.heightOne = heightOne;
    Config.widthOne = widthOne;
    // Config.topTwo = topTwo;
    // Config.leftTwo = leftTwo;
    // Config.heightTwo = heightTwo;
    // Config.widthTwo = widthTwo;
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        Image.memory(
          widget.image,
        ),
        Positioned(
          top: topOne,
          left: leftOne,
          child: GestureDetector(
            onPanStart: _handleDragOne,
            onPanUpdate: _handleUpdateOne,
            child: MouseRegion(
              cursor: SystemMouseCursors.move,
              child: Container(
                key: widget.containerKeyOne,
                height: heightOne,
                width: widthOne,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).accentColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: widget.childName,
              ),
            ),
          ),
        ),
        // top left
        Positioned(
          top: topOne - ballDiameter / 2,
          left: leftOne - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeUpLeftDownRight,
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              var newHeight = heightOne - 2 * mid;
              var newWidth = widthOne - 2 * mid;

              setState(() {
                heightOne = newHeight > 0 ? newHeight : 0;
                widthOne = newWidth > 0 ? newWidth : 0;
                topOne = topOne + mid;
                leftOne = leftOne + mid;
              });
            },
          ),
        ),
        // top middle
        Positioned(
          top: topOne - ballDiameter / 2,
          left: leftOne + widthOne / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeUp,
            onDrag: (dx, dy) {
              var newHeight = heightOne - dy;

              setState(() {
                heightOne = newHeight > 0 ? newHeight : 0;
                topOne = topOne + dy;
              });
            },
          ),
        ),
        // top right
        Positioned(
          top: topOne - ballDiameter / 2,
          left: leftOne + widthOne - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeUpRightDownLeft,
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;

              var newHeight = heightOne + 2 * mid;
              var newWidth = widthOne + 2 * mid;

              setState(() {
                heightOne = newHeight > 0 ? newHeight : 0;
                widthOne = newWidth > 0 ? newWidth : 0;
                topOne = topOne - mid;
                leftOne = leftOne - mid;
              });
            },
          ),
        ),
        // center right
        Positioned(
          top: topOne + heightOne / 2 - ballDiameter / 2,
          left: leftOne + widthOne - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeRight,
            onDrag: (dx, dy) {
              var newWidth = widthOne + dx;

              setState(() {
                widthOne = newWidth > 0 ? newWidth : 0;
              });
            },
          ),
        ),
        // bottom right
        Positioned(
          top: topOne + heightOne - ballDiameter / 2,
          left: leftOne + widthOne - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeUpLeftDownRight,
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              var newHeight = heightOne + 2 * mid;
              var newWidth = widthOne + 2 * mid;

              setState(() {
                heightOne = newHeight > 0 ? newHeight : 0;
                widthOne = newWidth > 0 ? newWidth : 0;
                topOne = topOne - mid;
                leftOne = leftOne - mid;
              });
            },
          ),
        ),
        // bottom center
        Positioned(
          top: topOne + heightOne - ballDiameter / 2,
          left: leftOne + widthOne / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeDown,
            onDrag: (dx, dy) {
              var newHeight = heightOne + dy;

              setState(() {
                heightOne = newHeight > 0 ? newHeight : 0;
              });
            },
          ),
        ),
        // bottom left
        Positioned(
          top: topOne + heightOne - ballDiameter / 2,
          left: leftOne - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeUpRightDownLeft,
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              var newHeight = heightOne + 2 * mid;
              var newWidth = widthOne + 2 * mid;

              setState(() {
                heightOne = newHeight > 0 ? newHeight : 0;
                widthOne = newWidth > 0 ? newWidth : 0;
                topOne = topOne - mid;
                leftOne = leftOne - mid;
              });
            },
          ),
        ),
        //left center
        Positioned(
          top: topOne + heightOne / 2 - ballDiameter / 2,
          left: leftOne - ballDiameter / 2,
          child: ManipulatingBall(
            mouseCursor: SystemMouseCursors.resizeLeft,
            onDrag: (dx, dy) {
              var newWidth = widthOne - dx;

              setState(() {
                widthOne = newWidth > 0 ? newWidth : 0;
                leftOne = leftOne + dx;
              });
            },
          ),
        ),
        /*
        // center center
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              setState(() {
                top = top + dy;
                left = left + dx;
              });
            },
          ),
        ),
      */
        // Positioned(
        //   top: topTwo,
        //   left: leftTwo,
        //   child: GestureDetector(
        //     onPanStart: _handleDragTwo,
        //     onPanUpdate: _handleUpdateTwo,
        //     child: MouseRegion(
        //       cursor: SystemMouseCursors.move,
        //       child: Container(
        //         key: widget.containerKeyTwo,
        //         height: heightTwo,
        //         width: widthTwo,
        //         decoration: BoxDecoration(
        //           border: Border.all(
        //             color: Theme.of(context).accentColor.withOpacity(0.2),
        //             width: 2,
        //           ),
        //         ),
        //         alignment: Alignment.center,
        //         child: widget.childPosition,
        //       ),
        //     ),
        //   ),
        // ),
        // // top left
        // Positioned(
        //   top: topTwo - ballDiameter / 2,
        //   left: leftTwo - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeUpLeftDownRight,
        //     onDrag: (dx, dy) {
        //       var mid = (dx + dy) / 2;
        //       var newHeight = heightTwo - 2 * mid;
        //       var newWidth = widthTwo - 2 * mid;

        //       setState(() {
        //         heightTwo = newHeight > 0 ? newHeight : 0;
        //         widthTwo = newWidth > 0 ? newWidth : 0;
        //         topTwo = topTwo + mid;
        //         leftTwo = leftTwo + mid;
        //       });
        //     },
        //   ),
        // ),
        // // top middle
        // Positioned(
        //   top: topTwo - ballDiameter / 2,
        //   left: leftTwo + widthTwo / 2 - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeUp,
        //     onDrag: (dx, dy) {
        //       var newHeight = heightTwo - dy;

        //       setState(() {
        //         heightTwo = newHeight > 0 ? newHeight : 0;
        //         topTwo = topTwo + dy;
        //       });
        //     },
        //   ),
        // ),
        // // top right
        // Positioned(
        //   top: topTwo - ballDiameter / 2,
        //   left: leftTwo + widthTwo - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeUpRightDownLeft,
        //     onDrag: (dx, dy) {
        //       var mid = (dx + (dy * -1)) / 2;

        //       var newHeight = heightTwo + 2 * mid;
        //       var newWidth = widthTwo + 2 * mid;

        //       setState(() {
        //         heightTwo = newHeight > 0 ? newHeight : 0;
        //         widthTwo = newWidth > 0 ? newWidth : 0;
        //         topTwo = topTwo - mid;
        //         leftTwo = leftTwo - mid;
        //       });
        //     },
        //   ),
        // ),
        // // center right
        // Positioned(
        //   top: topTwo + heightTwo / 2 - ballDiameter / 2,
        //   left: leftTwo + widthTwo - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeRight,
        //     onDrag: (dx, dy) {
        //       var newWidth = widthTwo + dx;

        //       setState(() {
        //         widthTwo = newWidth > 0 ? newWidth : 0;
        //       });
        //     },
        //   ),
        // ),
        // // bottom right
        // Positioned(
        //   top: topTwo + heightTwo - ballDiameter / 2,
        //   left: leftTwo + widthTwo - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeUpLeftDownRight,
        //     onDrag: (dx, dy) {
        //       var mid = (dx + dy) / 2;

        //       var newHeight = heightTwo + 2 * mid;
        //       var newWidth = widthTwo + 2 * mid;

        //       setState(() {
        //         heightTwo = newHeight > 0 ? newHeight : 0;
        //         widthTwo = newWidth > 0 ? newWidth : 0;
        //         topTwo = topTwo - mid;
        //         leftTwo = leftTwo - mid;
        //       });
        //     },
        //   ),
        // ),
        // // bottom center
        // Positioned(
        //   top: topTwo + heightTwo - ballDiameter / 2,
        //   left: leftTwo + widthTwo / 2 - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeDown,
        //     onDrag: (dx, dy) {
        //       var newHeight = heightTwo + dy;

        //       setState(() {
        //         heightTwo = newHeight > 0 ? newHeight : 0;
        //       });
        //     },
        //   ),
        // ),
        // // bottom left
        // Positioned(
        //   top: topTwo + heightTwo - ballDiameter / 2,
        //   left: leftTwo - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeUpRightDownLeft,
        //     onDrag: (dx, dy) {
        //       var mid = ((dx * -1) + dy) / 2;

        //       var newHeight = heightTwo + 2 * mid;
        //       var newWidth = widthTwo + 2 * mid;

        //       setState(() {
        //         heightTwo = newHeight > 0 ? newHeight : 0;
        //         widthTwo = newWidth > 0 ? newWidth : 0;
        //         topTwo = topTwo - mid;
        //         leftTwo = leftTwo - mid;
        //       });
        //     },
        //   ),
        // ),
        // //left center
        // Positioned(
        //   top: topTwo + heightTwo / 2 - ballDiameter / 2,
        //   left: leftTwo - ballDiameter / 2,
        //   child: ManipulatingBall(
        //     mouseCursor: SystemMouseCursors.resizeLeft,
        //     onDrag: (dx, dy) {
        //       var newWidth = widthTwo - dx;

        //       setState(() {
        //         widthTwo = newWidth > 0 ? newWidth : 0;
        //         leftTwo = leftTwo + dx;
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key key, this.onDrag, this.mouseCursor});

  final Function onDrag;
  final SystemMouseCursor mouseCursor;
  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: MouseRegion(
        cursor: widget.mouseCursor,
        child: Container(
          width: ballDiameter,
          height: ballDiameter,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
