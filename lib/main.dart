import 'package:Gkktcaa/datas/app_theme.dart';
import 'package:Gkktcaa/datas/user_options.dart';
import 'package:Gkktcaa/view_file.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainPage(),
        '/viewer': (context) => ViewFile(),
      },
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
    );
  }

}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  void getTheme() {
    AppTheme.getOptionsFromDevice().then((value) {
      UserOptions.getOptionsFromDevice();
      Navigator.pushReplacementNamed(context, '/main');
    });
  }

  @override
  void initState() {
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 250,
        height: 250,
        child: Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}