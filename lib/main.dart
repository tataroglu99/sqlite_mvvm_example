import 'package:flutter/material.dart';
import 'package:sqlite_mvvm_example/view/home_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: const Color(0xff00bfa5),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.green,
                  titleTextStyle: TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                    color: Colors.white,
                    fontSize: 20,
                  ))),
      home: HomeView(),
    );
  }
}
