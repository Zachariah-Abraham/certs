import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:window_size/window_size.dart';
import 'HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   setWindowMinSize(const Size(1250, 700));
  //   setWindowMaxSize(Size.infinite);
  // }
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(380, 770),
      builder: () => MaterialApp(
        title: 'Certificates',
        theme: ThemeData(
          hintColor: Colors.white.withOpacity(0.8),
          errorColor: Colors.white.withOpacity(0.8),
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          textTheme: Typography.whiteRedwoodCity,
          appBarTheme: AppBarTheme(
            elevation: 0.0,
          ),
        ),
        home: Banner(
          message: "Beta",
          location: BannerLocation.topEnd,
          child: HomePage(title: 'Certificates'),
        ),
      ),
    );
  }
}
