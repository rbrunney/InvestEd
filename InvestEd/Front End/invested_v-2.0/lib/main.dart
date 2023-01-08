import 'package:flutter/material.dart';
import '../util/global_styling.dart' as global_style;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(global_style.whiteBackgroundColor)
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: const [
                Card(
                  color: Color(0xFFFFFFFF),
                  child: Text("testing color"),
                ),
                Text("Hello World")
              ],
            ),
          ),
        )
    );
  }
}

