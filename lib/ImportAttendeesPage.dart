import 'dart:math';
import 'dart:typed_data';

import 'package:certs/EmailContentPage.dart';
import 'package:certs/CustomUI/GlassButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart';
import 'Config.dart';
import 'package:recase/recase.dart';
import 'ScreenWithGlassAppBar.dart';
import 'CustomUI/GradientContainer.dart';

class ImportAttendeesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ImportAttendeesPageState();
  }
}

class ImportAttendeesPageState extends State<ImportAttendeesPage> {
  ValueNotifier<int> nameColumnNumberNotifier = ValueNotifier(0);
  ValueNotifier<int> emailColumnNumberNotifier = ValueNotifier(0);
  // int positionColumnNumber = 0;
  ValueNotifier<int> startingRowNumberNotifier = ValueNotifier(0);
  // List<String> positionsList = [];

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
      resizeToAvoidBottomInset: false,
      floatingActionButton: GlassTextButton(
        text: "Done",
        borderRadius: 10.0.r,
        paddingAll: 30.0.r,
        onPressed: () {
          if (Config.namesList.value.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please add some rows to proceed"),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EmailContentPage(),
              ),
            );
          }
        },
      ),
      body: GradientContainer(
        colors: [Colors.purple, Colors.blue],
        child: ScreenWithGlassAppBar(
          appBarChild: Text(
            "Import .xlsx sheet",
            textScaleFactor: 1.5.sp,
          ),
          trailingChild: GlassTextButton(
            paddingAll: 25.0.r,
            onPressed: () {
              setState(() {
                // positionsList.clear();
                Config.namesList.value = [];
                Config.emailsList.value = [];
                // Config.positionsList.clear();
              });
            },
            text: "Clear",
          ),
          child: OrientationBuilder(builder: (context, orientation) {
            return orientation == Orientation.landscape
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: EntryForm(
                          orientation: orientation,
                          emailColumnNumberNotifier: emailColumnNumberNotifier,
                          nameColumnNumberNotifier: nameColumnNumberNotifier,
                          startingRowNumberNotifier: startingRowNumberNotifier,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: AttendeesList(
                          orientation: orientation,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: EntryForm(
                          orientation: orientation,
                          emailColumnNumberNotifier: emailColumnNumberNotifier,
                          nameColumnNumberNotifier: nameColumnNumberNotifier,
                          startingRowNumberNotifier: startingRowNumberNotifier,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: AttendeesList(
                          orientation: orientation,
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}

class EntryForm extends StatefulWidget {
  EntryForm({
    @required this.orientation,
    @required this.emailColumnNumberNotifier,
    @required this.nameColumnNumberNotifier,
    @required this.startingRowNumberNotifier,
  });
  final orientation;
  final emailColumnNumberNotifier;
  final nameColumnNumberNotifier;
  final startingRowNumberNotifier;
  @override
  _EntryFormState createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int emailColumnNumber;
  int nameColumnNumber;
  int startingRowNumber;
  List<String> namesList = [];
  List<String> emailsList = [];
  Widget nameColumnNumberWidget;
  Widget emailColumnNumberWidget;
  Widget startingRowNumberWidget;
  Widget importFileButtonWidget;
  Widget proTipWidget;
  // Widget positionColumnNumberWidget;

  Future<PlatformFile> getFile() async {
    // final file = OpenFilePicker()..title = "Select a certificate template";
    // return file.getFile();
    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xlsx"],
    );
    if (filePickerResult == null) {
      return null;
    }
    return filePickerResult.files.single;
  }

  @override
  void initState() {
    super.initState();
    widget.emailColumnNumberNotifier.addListener(() {
      setState(() {
        emailColumnNumber = widget.emailColumnNumberNotifier.value;
      });
    });
    widget.nameColumnNumberNotifier.addListener(() {
      setState(() {
        nameColumnNumber = widget.nameColumnNumberNotifier.value;
      });
    });
    widget.startingRowNumberNotifier.addListener(() {
      setState(() {
        startingRowNumber = widget.startingRowNumberNotifier.value;
      });
    });
  }

  bool validateAndSaveForm() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  void populateLists(Uint8List bytes) {
    var excel = Excel.decodeBytes(bytes);
    int temp = 0;
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        if (max(
              emailColumnNumber,
              // max(
              nameColumnNumber,
              // positionColumnNumber,
              // ),
            ) >=
            row.length) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Your name/email column is out of bounds"),
            ),
          );

          return;
        }
        temp++;
        if (temp < startingRowNumber) continue;
        setState(() {
          emailsList.add(row[emailColumnNumber].toString().trim());
          namesList.add(ReCase(row[nameColumnNumber].toString()).titleCase);
          // if (positionColumnNumber == -1) {
          //   positionsList.add("");
          // } else {
          //   positionsList.add(row[positionColumnNumber].toString().trim());
          // }
          Config.namesList.value = namesList;
          Config.emailsList.value = emailsList;
          // Config.positionsList = positionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    nameColumnNumberWidget = Padding(
      padding: EdgeInsets.fromLTRB(20.0.r, 20.0.r, 20.0.r, 10.0.r),
      child: TextFormField(
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 4.sp,
        ),
        decoration: InputDecoration(
          hintText: "1",
          hintStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 4.sp,
            color: Theme.of(context).hintColor.withOpacity(0.4),
          ),
          labelText: "Name column number",
          errorStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.sp,
          ),
          labelStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.sp,
          ),
          border: InputBorder.none,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value.isEmpty) return "Can't be empty";
          return null;
        },
        onSaved: (value) {
          setState(() {
            nameColumnNumber = int.parse(value) - 1;
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            nameColumnNumber = int.parse(value) - 1;
          });
        },
      ),
    );
    emailColumnNumberWidget = Padding(
      padding: EdgeInsets.fromLTRB(20.0.r, 10.0.r, 20.0.r, 10.0.r),
      child: TextFormField(
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 4.sp,
        ),
        decoration: InputDecoration(
          hintText: "1",
          hintStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 4.sp,
            color: Theme.of(context).hintColor.withOpacity(0.4),
          ),
          labelText: "Email column number",
          labelStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.sp,
          ),
          errorStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.sp,
          ),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return "Can't be empty";
          return null;
        },
        onSaved: (value) {
          setState(() {
            emailColumnNumber = int.parse(value) - 1;
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            emailColumnNumber = int.parse(value) - 1;
          });
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
    // positionColumnNumberWidget = Padding(
    //   padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
    //   child: TextFormField(
    //     style: TextStyle(fontSize: 60),
    //     decoration: InputDecoration(
    //       hintText: "1",
    //       hintStyle: TextStyle(
    //         fontSize: 60,
    //         color: Theme.of(context).hintColor.withOpacity(0.4),
    //       ),
    //       labelText: "Position column number (left most column is 1)",
    //       labelStyle: TextStyle(fontSize: 20),
    //       border: InputBorder.none,
    //     ),
    //     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    //     validator: (value) {
    //       if (value.isEmpty) return "Can't be empty";
    //       return null;
    //     },
    //     onSaved: (value) {
    //       setState(() {
    //         positionColumnNumber = int.parse(value) - 1;
    //       });
    //     },
    //     onFieldSubmitted: (value) {
    //       setState(() {
    //         positionColumnNumber = int.parse(value) - 1;
    //       });
    //     },
    //   ),
    // );
    startingRowNumberWidget = Padding(
      padding: EdgeInsets.fromLTRB(20.0.r, 10.0.r, 20.0.r, 10.0.r),
      child: TextFormField(
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 4.sp,
        ),
        decoration: InputDecoration(
          hintText: "1",
          hintStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 4.sp,
            color: Theme.of(context).hintColor.withOpacity(0.4),
          ),
          labelText: "Starting row number",
          labelStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.sp,
          ),
          errorStyle: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 1.sp,
          ),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value.isEmpty) return "Can't be empty";
          return null;
        },
        onSaved: (value) {
          setState(() {
            startingRowNumber = int.parse(value);
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            startingRowNumber = int.parse(value);
          });
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
    importFileButtonWidget = Padding(
      padding: EdgeInsets.fromLTRB(20.0.r, 10.0.r, 20.0.r, 10.0.r),
      child: GlassTextButton(
        text: "Import file (.xlsx)",
        textScale: 1.25.r,
        onPressed: () async {
          if (validateAndSaveForm()) {
            final file = await getFile();
            if (file == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Please select a .xlsx file"),
                ),
              );
              return;
            }
            populateLists(file.bytes);
          }
        },
      ),
    );
    proTipWidget = Padding(
      padding: EdgeInsets.fromLTRB(20.0.r, 10.0.r, 20.0.r, 10.0.r),
      child: Text(
        "Pro tip: You can import multiple times",
        textScaleFactor: 0.8.sp,
        style: TextStyle(color: Theme.of(context).hintColor),
      ),
    );
    return Form(
      key: formKey,
      child: widget.orientation == Orientation.landscape
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                nameColumnNumberWidget,
                emailColumnNumberWidget,
                //positionColumnNumberWidget,
                startingRowNumberWidget,
                importFileButtonWidget,
                proTipWidget,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        nameColumnNumberWidget,
                        emailColumnNumberWidget,
                        //positionColumnNumberWidget,
                        startingRowNumberWidget,
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      importFileButtonWidget,
                      proTipWidget,
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class AttendeesList extends StatefulWidget {
  AttendeesList({@required this.orientation});
  final orientation;
  @override
  _AttendeesListState createState() => _AttendeesListState();
}

class _AttendeesListState extends State<AttendeesList> {
  List<String> namesList = Config.namesList.value;
  List<String> emailsList = Config.emailsList.value;

  @override
  void initState() {
    super.initState();
    Config.namesList.addListener(() {
      setState(() {
        namesList = Config.namesList.value;
      });
    });
    Config.emailsList.addListener(() {
      setState(() {
        emailsList = Config.emailsList.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0.r, 5.r, 20.r, 5.r),
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
            title: widget.orientation == Orientation.landscape
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Names",
                        textScaleFactor: 1.25.sp,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Emails",
                        textScaleFactor: 1.25.sp,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Text(
                      //   "Positions",
                      //   textScaleFactor: 1.25,
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  )
                : ListTile(
                    title: Text(
                      "Names",
                      textScaleFactor: 1.sp,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Emails",
                      textScaleFactor: 0.75.sp,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          Expanded(
            flex: 1,
            child: Scrollbar(
              child: ListView.builder(
                itemCount: namesList.length,
                itemBuilder: (builder, index) {
                  return ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      textScaleFactor: 1.25.sp,
                    ),
                    title: widget.orientation == Orientation.landscape
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                namesList[index],
                                textScaleFactor: 1.25.sp,
                              ),
                              Text(
                                emailsList[index],
                                textScaleFactor: 1.25.sp,
                              ),
                              // Text(
                              //   positionsList[index],
                              //   textScaleFactor: 1.25,
                              // ),
                            ],
                          )
                        : ListTile(
                            title: Text(
                              namesList[index],
                              textScaleFactor: 1.sp,
                            ),
                            subtitle: Text(
                              emailsList[index],
                              textScaleFactor: 0.75.sp,
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
