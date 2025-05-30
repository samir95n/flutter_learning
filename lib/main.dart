import 'package:flutter/material.dart';
import 'package:new_app/navigation/bottom_navigator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Учебное приложение',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BottomNavApp(), // <-- тут главное
    );
  }
}
