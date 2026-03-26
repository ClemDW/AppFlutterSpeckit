import 'package:flutter/material.dart';
import 'screens/camera_view.dart';

void main() {
  runApp(const ObjectDetectionApp());
}

/// Main application entry point
/// Flutter object detection app with offline TFLite inference
class ObjectDetectionApp extends StatelessWidget {
  const ObjectDetectionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Détection d\'Objets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: const CameraView(),
    );
  }
}
