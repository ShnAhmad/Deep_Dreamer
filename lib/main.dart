import 'package:deep_dreamer/screens/image_creator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Image Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageCreatorScreen(),
    );
  }
}
