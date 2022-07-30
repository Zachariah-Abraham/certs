import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Config {
  static ValueNotifier<Color> fontColorName = ValueNotifier(Color(0xFFFF6400));
  static ValueNotifier<double> fontSizeName = ValueNotifier(28.r);
  static String accessToken = "";
  static AuthClient googleAuthClient;
  static GoogleSignInAccount googleUser;
  static GmailApi gmailApi;
  static double imageHeight;
  static double imageWidth;
  static double boundaryHeight;
  static double boundaryWidth;
  // static Color fontColorPosition = Colors.black;
  // static double fontSizePosition = 20.0;
  static Uint8List imageFile;
  static String subject;
  static String bodyPlain;
  static String bodyHTML;
  static ValueNotifier<List<String>> namesList = ValueNotifier([]);
  static ValueNotifier<List<String>> emailsList = ValueNotifier([]);
  // static List<String> positionsList;
  static double heightOne;
  static double widthOne;
  static double topOne;
  static double leftOne;
  // static double heightTwo;
  // static double widthTwo;
  // static double topTwo;
  // static double leftTwo;
  static bool bodyIsHTML = false;
}
