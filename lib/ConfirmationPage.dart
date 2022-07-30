import 'package:certs/GenerateAndSendCertificatesPage.dart';
import 'package:certs/CustomUI/GlassButtons.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/gmail/v1.dart';
import 'Config.dart';
import 'CustomUI/GradientContainer.dart';
import 'OverlayImageWithTextFixed.dart';
import 'ScreenWithGlassAppBar.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConfirmationPageState();
  }
}

class ConfirmationPageState extends State<ConfirmationPage> {
  GlobalKey imageKey = GlobalKey();
  GlobalKey tempResizeKeyOne = GlobalKey();
  GlobalKey tempResizeKeyTwo = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GlassTextButton(
          text: "Done",
          borderRadius: 10.0.r,
          paddingAll: 30.0.r,
          onPressed: () async {
            try {
              var id = ClientId(dotenv.env["CLIENT_ID"], null);
              var scopes = ["https://www.googleapis.com/auth/gmail.send"];

              // Initialize the browser oauth2 flow functionality.
              BrowserOAuth2Flow flow =
                  await createImplicitBrowserFlow(id, scopes);
              Config.googleAuthClient = await flow.clientViaUserConsent();
              flow.close();
              Config.gmailApi = new GmailApi(Config.googleAuthClient);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GenerateAndSendCertificatesPage(),
                ),
              );
            } catch (e) {
              print(e);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please grant the required permissions"),
                ),
              );
            }
          }),
      body: GradientContainer(
        colors: [Colors.purple, Colors.blue],
        child: ScreenWithGlassAppBar(
          appBarChild: Text(
            "Confirm",
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
                                    textName: "Recipient Name",
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
                              child: Text(
                                "This is what the certificates will look like. If it looks good, press \"Done\", otherwise press the back button on the top left corner to make changes. When you press \"Done\", you will be required to sign in to your GMail account and grant permissions to send emails.",
                                textScaleFactor: 2.sp,
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
                                    textName: "Recipient Name",
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
                            height: 0.5.sh,
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(20.0.r, 5.r, 20.r, 5.r),
                              child: SingleChildScrollView(
                                child: Text(
                                  "This is what the certificates will look like. If it looks good, press \"Done\", otherwise press the back button on the top left corner to make changes. When you press \"Done\", you will be required to sign in to your GMail account and grant permissions to send emails.",
                                  textScaleFactor: 2.sp,
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
