import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'Config.dart';
import 'package:flutter/rendering.dart';

class OverlayImageWithTextFixed extends StatelessWidget {
  OverlayImageWithTextFixed(
      {@required this.keyOne,
      @required this.keyTwo,
      @required this.textName,
      @required this.fontSizeName,
      @required this.colorName,
      // @required this.textPosition,
      // @required this.colorPosition,
      // @required this.fontSizePosition,
      @required this.image});

  final Key keyOne;
  final Key keyTwo;
  final double fontSizeName;
  final String textName;
  final Color colorName;
  // final double fontSizePosition;
  // final String textPosition;
  // final Color colorPosition;
  final Uint8List image;
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: [
        Image.memory(
          image,
          height: Config.boundaryHeight,
          width: Config.boundaryWidth,
        ),
        Positioned(
          top: Config.topOne,
          left: Config.leftOne,
          child: Container(
            height: Config.heightOne,
            width: Config.widthOne,
            alignment: Alignment.center,
            child: Text(
              textName,
              style: TextStyle(
                fontSize: Config.fontSizeName.value,
                color: Config.fontColorName.value,
              ),
            ),
          ),
        ),
      ],

      // Positioned(
      //   top: Config.topTwo,
      //   left: Config.leftTwo,
      //   child: Container(
      //     height: Config.heightTwo,
      //     width: Config.widthTwo,
      //     alignment: Alignment.center,
      //     child: Text(
      //       textPosition,
      //       style: TextStyle(
      //         fontSize: Config.fontSizePosition,
      //         color: Config.fontColorPosition,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
