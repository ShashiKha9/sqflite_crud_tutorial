import 'package:flutter/material.dart';
import 'package:sqflite_crud_tutorial/screens/add_note.dart';
import 'package:sqflite_crud_tutorial/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sqflite Crud',
      theme: ThemeData(
        primaryColor: Colors.red
      ),
      home: HomeScreen(),



    );
  }
}
