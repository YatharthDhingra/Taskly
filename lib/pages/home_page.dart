import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//because the state of this widget will change in our app, so stateful
class HomePage extends StatefulWidget {
  //for stateful widgets , we don't use build method , we use createState method

  HomePage(); //empty constructor
  @override
  State<StatefulWidget> createState() {
    //returns a state
    return _HomePageState();
  }
}

//this class maintains the state
class _HomePageState extends State<HomePage> {
  //extend from State<HomePageName>

  late double _deviceHeight, _deviceWidth;

  _HomePageState(); //empty constructor
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.15 * _deviceHeight, //to set the height of appBar
        title: const Text(
          "Taskly!",
          style: TextStyle(fontSize: 25),
        ), //to set the title
      ), //top bar of the page
      body: _tasksList(), //set the body to list View
      floatingActionButton: _addTaskButton(),  //to add a floatingActionButton on our scaffold
    );
  }

  //a function to create a list view
  Widget _tasksList() {
    return ListView(
      //It is like a column but SCROLLABLE
      children: [
        //a list of widgets
        ListTile(
          //a prebuilt item tile for a list
          title: const Text(
            "Do Laundry!",
            style: TextStyle(
              decoration: TextDecoration.lineThrough,
            ),
          ), //lineThrough -> to basically cut a line

          subtitle:
              Text(DateTime.now().toString()), //another property of listTile
          //DateTime.now() -> current date and time

          trailing: const Icon(
            Icons.check_box_outlined,
            color: Colors.red,
          ), //a widget to display after the title(mostly an icon) that is right aligned
          //Icon widget
        ),
      ],
    );
  }

  Widget _addTaskButton() {
    //button for adding a task in our list
    return FloatingActionButton(onPressed: () {  //by default it appears on right-bottom corner and stays there irrespective of if we scroll
      //what happens when we click on button
      
    },
    child: Icon(Icons.add), //'+' icon added
    );
  }
}
