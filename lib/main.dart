import 'package:flutter/material.dart';
import 'package:taskly/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart'; //import hive package
//Hive is a NO-SQl key based database

void main() async{      //marking the function asynchronous means that it will deal with async programming
  await Hive.initFlutter("Hive_boxes");   //initialises hive ("path of our directory") 
  //this is a future of void type
  //await means , wait for this thread to complete , then only move forward
  //we can create a splash screen that appears while this thread is running
  //we create another directory in root of our project , to store the information of our database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      theme: ThemeData(
        primarySwatch: Colors.red, //color of the app bars
      ),
      home: HomePage(),
    );
  }
}
