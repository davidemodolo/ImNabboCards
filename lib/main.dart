import 'dart:io';

import 'package:flutter/material.dart';
import 'package:imnabbo/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // open c.txt file
    final File cFile = File('data/flutter_assets/assets/colorRGB.txt');
    // the file is like 233, 3, 5, that's the RGB value for the background color
    // split the string by the comma
    final List<String> c = cFile.readAsStringSync().split(',');
    // create a Color object with the RGB values
    final Color cColor =
        Color.fromRGBO(int.parse(c[0]), int.parse(c[1]), int.parse(c[2]), 1.0);
    return MaterialApp(
      title: 'Nabbo Cards',
      home: Scaffold(
        backgroundColor: cColor, // Set the background color to purple
        body: const HomeScreen(),
      ),
    );
  }
}
