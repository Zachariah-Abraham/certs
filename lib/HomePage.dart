import 'package:flutter/material.dart';
// import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:file_picker/file_picker.dart';
import 'TemplatePage.dart';
import 'Config.dart';
import 'CustomUI/GradientContainer.dart';
import 'CustomUI/GlassButtons.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  void getFile() async {
    // final file = OpenFilePicker()..title = "Select a certificate template";
    // final result = file.getFile();
    FilePickerResult filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (filePickerResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an image"),
        ),
      );
      return;
    }
    final result = filePickerResult.files.single;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an image"),
        ),
      );
      return;
    }
    Config.imageFile = result.bytes;
    var decodedImage = await decodeImageFromList(result.bytes);
    Config.imageHeight = decodedImage.height.toDouble();
    Config.imageWidth = decodedImage.width.toDouble();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TemplatePage(templateImage: result.bytes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientContainer(
        colors: [Colors.purple, Colors.blue],
        child: Center(
          child: GlassTextButton(
            text: "Import Template",
            onPressed: getFile,
          ),
        ),
      ),
    );
  }
}
