import 'package:flutter/material.dart';
import 'package:pilot/pages/home_page.dart';
import 'package:pilot/pages/senator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Můj senátor",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        "/senator": (context) => SenatorPage(),
        "/home": (context) => HomePage()
      },
    );
  }
}
