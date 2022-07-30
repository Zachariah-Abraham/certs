import 'package:certs/ConfirmationPage.dart';
import 'package:certs/CustomUI/GlassButtons.dart';
import 'package:flutter/material.dart';
import 'Config.dart';
import 'CustomUI/GradientContainer.dart';
import 'ScreenWithGlassAppBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailContentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmailContentPageState();
  }
}

class EmailContentPageState extends State<EmailContentPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueKey bodyPlainKey = ValueKey("plain");
  ValueKey bodyHTMLKey = ValueKey("html");
  TextFormField bodyPlainArea;
  TextFormField bodyHTMLArea;
  TextFormField currentBodyTextFormField;
  TextFormField subjectTextFormField;

  @override
  void initState() {
    super.initState();
    subjectTextFormField = TextFormField(
      style: TextStyle(fontSize: 22.sp),
      decoration: InputDecoration(
        hintText: "Thanks for attending! [Certificate for {{name}}]",
        hintStyle: TextStyle(
          fontSize: 22.sp,
          color: Colors.black.withOpacity(0.4),
        ),
        labelText: "Subject",
        labelStyle: TextStyle(fontSize: 18.sp),
        errorStyle: TextStyle(
          fontSize: 16.sp,
        ),
        border: InputBorder.none,
      ),
      validator: (value) {
        return null;
      },
      onSaved: (value) {
        setState(() {
          Config.subject = value;
        });
      },
      onFieldSubmitted: (value) {
        setState(() {
          Config.subject = value;
        });
      },
    );
    bodyPlainArea = TextFormField(
      key: bodyPlainKey,
      minLines: 5,
      maxLines: 10,
      initialValue: Config.bodyPlain,
      style: TextStyle(fontSize: 22.sp),
      decoration: InputDecoration(
        hintText: '''Hey {{name}}, 

We are glad you attended our event and hope you enjoyed! 
Your certificate is attached :)

Warm regards,
''',
        hintStyle: TextStyle(
          fontSize: 22.sp,
          color: Colors.black.withOpacity(0.4),
        ),
        labelText: "Body (plain)",
        labelStyle: TextStyle(fontSize: 18.sp),
        errorStyle: TextStyle(
          fontSize: 16.sp,
        ),
        border: InputBorder.none,
      ),
      validator: (value) {
        return null;
      },
      onSaved: (value) {
        setState(() {
          Config.bodyPlain = value;
        });
      },
      onFieldSubmitted: (value) {
        setState(() {
          Config.bodyPlain = value;
        });
      },
    );

    bodyHTMLArea = TextFormField(
      key: bodyHTMLKey,
      minLines: 5,
      maxLines: 10,
      initialValue: Config.bodyHTML,
      style: TextStyle(fontSize: 22.sp),
      decoration: InputDecoration(
        hintText: '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>
    <div style="max-width: 596px; margin: auto; text-align: center; align-content: center; justify-content: center;" >
        Hey {{name}},

        We are glad you attended our event and hope you enjoyed! 
        Your certificate is attached :)

        Warm regards,
        
    </div>
</body>

</html>''',
        hintStyle: TextStyle(
          fontSize: 22.sp,
          color: Colors.black.withOpacity(0.4),
        ),
        labelText: "Body (HTML)",
        labelStyle: TextStyle(fontSize: 18.sp),
        errorStyle: TextStyle(
          fontSize: 16.sp,
        ),
        border: InputBorder.none,
      ),
      validator: (value) {
        return null;
      },
      onSaved: (value) {
        setState(() {
          Config.bodyHTML = value;
        });
      },
      onFieldSubmitted: (value) {
        setState(() {
          Config.bodyHTML = value;
        });
      },
    );
    currentBodyTextFormField = bodyPlainArea;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validateAndSaveForm() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        colors: [Colors.purple, Colors.blue],
        child: ScreenWithGlassAppBar(
          appBarChild: Text(
            "Email Content",
            textScaleFactor: 1.5.sp,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(50.0.w, 30.0.r, 50.w, 10.0.r),
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    subjectTextFormField,
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10.0.r, 10.0.r, 10.0.r),
                      child: Row(
                        children: [
                          Text("Use HTML for body"),
                          Switch(
                            value: Config.bodyIsHTML,
                            onChanged: (newVal) {
                              setState(() {
                                Config.bodyIsHTML = newVal;
                                if (Config.bodyIsHTML) {
                                  currentBodyTextFormField = bodyHTMLArea;
                                } else {
                                  currentBodyTextFormField = bodyPlainArea;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    currentBodyTextFormField,
                    GlassTextButton(
                      text: "Done",
                      onPressed: () {
                        if (validateAndSaveForm()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ConfirmationPage(),
                            ),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.r),
                      child: Text(
                        "Pro tip: To include the recipients name in the subject/body, use '{{name}}' or '{{NAME}}'. For example, 'Hello {{name}}'.",
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
