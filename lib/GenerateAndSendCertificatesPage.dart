import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Config.dart';
import 'OverlayImageWithTextFixed.dart';
import 'dart:ui' as ui;
import 'package:googleapis/gmail/v1.dart';
import 'CustomUI/GradientContainer.dart';
import 'ScreenWithGlassAppBar.dart';
import 'EndScreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//TODO: If a recipient address is not correct, the entire application stops, and this error is returned where the snackbar is:
// After sending RCPT TO:<xyz@gmail.com >, response did not start with any of: [2].
// Response from server: < 553 5.1.3 The recipient address <xyz@gmail.com > is not a valid
// < 553 5.1.3 RFC-5321 address. 186sm5666964pfe.212 - gsmtp
// Actual issue: Email had a trailing space. Trim before collecting.

class GenerateAndSendCertificatesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GenerateAndSendCertificatesPageState();
  }
}

class GenerateAndSendCertificatesPageState
    extends State<GenerateAndSendCertificatesPage> {
  Stack certificateStack = Stack();
  GlobalKey imageKey = GlobalKey();
  GlobalKey tempImageKey = GlobalKey();
  GlobalKey tempResizeKeyOne = GlobalKey();
  GlobalKey tempResizeKeyTwo = GlobalKey();
  // SmtpServer smtpServer;
  // PersistentConnection connection;

  int currentIndex = 0;
  int listLength = 0;

  String getBase64Email({String source}) {
    List<int> bytes = utf8.encode(source);
    String base64String = base64UrlEncode(bytes);
    return base64String;
  }

  sendEmail({
    String from: 'me',
    String to: 'someemail@gmail.com',
    String subject: 'Some subject',
    String contentType: 'text/plain',
    String charset: 'utf-8',
    String contentTransferEncoding: 'base64url',
    String emailContent: 'Hello',
    List<int> attachmentPngBytes,
    String attachmentName: "example.png",
  }) async {
    Message message = new Message();
    message.raw = getBase64Email(
      source: [
        'Content-Type: multipart/mixed; boundary="certs_mail_divider"\r\n',
        'MIME-Version: 1.0\r\n',
        'From: $from\r\n',
        'To: $to\r\n',
        'Subject: $subject\r\n\r\n',
        '--certs_mail_divider\r\n',
        'Content-Type: $contentType; charset=$charset\r\n',
        'MIME-Version: 1.0\r\n',
        'Content-Transfer-Encoding: $contentTransferEncoding\r\n\r\n',
        '$emailContent\r\n\r\n',
        '--certs_mail_divider\r\n',
        'Content-Type: image/png\r\n',
        'MIME-Version: 1.0\r\n',
        'Content-Transfer-Encoding: base64\r\n',
        'Content-Disposition: attachment; filename="$attachmentName"\r\n\r\n',
        base64Encode(attachmentPngBytes),
        '\r\n\r\n',
        '--certs_mail_divider--'
      ].join(""),
    );
    await Config.gmailApi.users.messages.send(message, from);
  }

  @override
  void initState() {
    super.initState();
    listLength = Config.namesList.value.length;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> convertAndSaveImage() async {
    if (!this.mounted) return;
    await WidgetsBinding.instance.endOfFrame;
    if (!this.mounted) return;
    print("Starting $currentIndex");
    if (!(currentIndex < listLength)) {
      if (this.mounted) {
        if (currentIndex < listLength - 1) {
          setState(() {
            currentIndex += 1;
          });
        }
      }
      return;
    }
    if (imageKey == null) {
      if (this.mounted) {
        if (currentIndex < listLength - 1) {
          setState(() {
            currentIndex += 1;
          });
        }
      }
      return;
    }
    if (imageKey.currentContext == null) {
      if (this.mounted) {
        if (currentIndex < listLength - 1) {
          setState(() {
            currentIndex += 1;
          });
        }
      }
      return;
    }

    RenderRepaintBoundary boundary = imageKey.currentContext.findRenderObject();
    if (boundary == null) {
      return;
    }
    final image = await boundary.toImage(
        pixelRatio: Config.imageHeight / boundary.size.height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes = byteData.buffer.asUint8List();
    String subject = Config.subject
        .replaceAll('{{name}}', Config.namesList.value[currentIndex]);
    subject =
        subject.replaceAll('{{NAME}}', Config.namesList.value[currentIndex]);
    // subject =
    //     subject.replaceAll('{{position}}', Config.positionsList[currentIndex]);
    // subject =
    //     subject.replaceAll('{{POSITION}}', Config.positionsList[currentIndex]);
    String body = (Config.bodyIsHTML ? Config.bodyHTML : Config.bodyPlain)
        .replaceAll('{{name}}', Config.namesList.value[currentIndex]);
    body = body.replaceAll('{{NAME}}', Config.namesList.value[currentIndex]);
    // body = body.replaceAll('{{position}}', Config.positionsList[currentIndex]);
    // body = body.replaceAll('{{POSITION}}', Config.positionsList[currentIndex]);

    if (!this.mounted) return;

    // TODO: Exception handling for the sendEmail function
    await sendEmail(
      from: "me",
      to: Config.emailsList.value[currentIndex],
      subject: subject,
      contentType: Config.bodyIsHTML ? "text/html" : "text/plain",
      emailContent: body,
      attachmentPngBytes: imageBytes,
      attachmentName: "${Config.namesList.value[currentIndex]}.png",
    );

    // try {
    //   // await connection.
    //   await send(message, smtpServer);
    // } on MailerException catch (e) {
    //   if (e.toString() == "Incorrect username / password / credentials") {
    //     await ScaffoldMessenger.of(context)
    //         .showSnackBar(
    //           SnackBar(
    //             content: Text(
    //                 "Incorrect username/password (check your credentials, and check the footnote on the previous page)",
    //                 style: TextStyle(color: Colors.white)),
    //             duration: Duration(seconds: 3),
    //             backgroundColor: Color.fromRGBO(139, 0, 0, 1),
    //           ),
    //         )
    //         .closed;
    //   } else {
    //     print(e.toString());
    //     for (var p in e.problems) {
    //       print('Problem: ${p.code}: ${p.msg}');
    //     }
    //     await ScaffoldMessenger.of(context)
    //         .showSnackBar(
    //           SnackBar(
    //             content: Text(
    //                 "Please check your internet connection\nOr check the links on the previous page"),
    //           ),
    //         )
    //         .closed;
    //   }
    //   if (this.mounted) {
    //     Navigator.of(context).pop();
    //   }
    // }
    if (this.mounted) {
      if (currentIndex < listLength - 1) {
        setState(() {
          currentIndex += 1;
        });
      } else if (currentIndex == listLength - 1) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EndScreen(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      convertAndSaveImage();
    });
    return Scaffold(
      body: GradientContainer(
        colors: [Colors.purple, Colors.blue],
        child: ScreenWithGlassAppBar(
          appBarChild: Text(
            "Sending certificates",
            textScaleFactor: 1.5.sp,
          ),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.landscape
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IntrinsicWidth(
                          child: Padding(
                            padding: EdgeInsets.all(10.r),
                            child: Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: RepaintBoundary(
                                  key: imageKey,
                                  child: OverlayImageWithTextFixed(
                                    keyOne: tempResizeKeyOne,
                                    keyTwo: tempResizeKeyTwo,
                                    image: Config.imageFile,
                                    textName:
                                        Config.namesList.value[currentIndex],
                                    fontSizeName: Config.fontSizeName.value,
                                    colorName: Config.fontColorName.value,
                                    // textPosition: Config.positionsList[currentIndex],
                                    // fontSizePosition: Config.fontSizePosition,
                                    // colorPosition: Config.fontColorPosition,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            height: 1.sh,
                            padding:
                                EdgeInsets.fromLTRB(20.0.r, 5.r, 20.r, 5.r),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Text(
                                      "#",
                                      textScaleFactor: 1.25.sp,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    title: Text(
                                      "Names",
                                      textScaleFactor: 1.25.sp,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Emails",
                                      textScaleFactor: 1.25.sp,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Text(
                                      "Sending ${currentIndex + 1}/$listLength",
                                      textScaleFactor: 1.25.sp,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: Config.namesList.value.length,
                                    itemBuilder: (builder, index) {
                                      return ListTile(
                                        leading: Text(
                                          (index + 1).toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.25.sp,
                                        ),
                                        title: Text(
                                          Config.namesList.value[index],
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.25.sp,
                                        ),
                                        subtitle: Text(
                                          Config.emailsList.value[index],
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor: 1.25.sp,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: RepaintBoundary(
                                key: imageKey,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: OverlayImageWithTextFixed(
                                    keyOne: tempResizeKeyOne,
                                    keyTwo: tempResizeKeyTwo,
                                    image: Config.imageFile,
                                    textName:
                                        Config.namesList.value[currentIndex],
                                    fontSizeName: Config.fontSizeName.value,
                                    colorName: Config.fontColorName.value,
                                    // textPosition: Config.positionsList[currentIndex],
                                    // fontSizePosition: Config.fontSizePosition,
                                    // colorPosition: Config.fontColorPosition,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 1.sw,
                            height: 1.sh,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0.r, 5.r, 20.r, 5.r),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Text(
                                        "#",
                                        textScaleFactor: 1.25.sp,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      title: Text(
                                        "Names",
                                        textScaleFactor: 1.25.sp,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "Emails",
                                        textScaleFactor: 1.25.sp,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Text(
                                        "Sending ${currentIndex + 1}/$listLength",
                                        textScaleFactor: 1.25.sp,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: Config.namesList.value.length,
                                      itemBuilder: (builder, index) {
                                        return ListTile(
                                          leading: Text(
                                            (index + 1).toString(),
                                            overflow: TextOverflow.ellipsis,
                                            textScaleFactor: 1.sp,
                                          ),
                                          title: Text(
                                            Config.namesList.value[index],
                                            overflow: TextOverflow.ellipsis,
                                            textScaleFactor: 1.sp,
                                          ),
                                          subtitle: Text(
                                            Config.emailsList.value[index],
                                            overflow: TextOverflow.ellipsis,
                                            textScaleFactor: 0.75.sp,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
