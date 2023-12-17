import 'dart:io';

import 'package:flutter/material.dart';
import 'package:imnabbo/home.dart';

import 'package:imnabbo/globals.dart' as globals;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final File cFile = File(globals.bgColorFile);
    // the file is like 233, 3, 5, that's the RGB value for the background color
    // split the string by the comma
    final List<String> c = cFile.readAsStringSync().split(',');
    // create a Color object with the RGB values
    final Color cColor =
        Color.fromRGBO(int.parse(c[0]), int.parse(c[1]), int.parse(c[2]), 1.0);
    globals.bgColor = cColor;

    return const MaterialApp(
      title: 'Nabbo Cards',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: HomeScreen(),
      ),
    );
  }
}
