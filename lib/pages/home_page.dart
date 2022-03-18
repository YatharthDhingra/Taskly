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
        toolbarHeight: 0.15 * _deviceHeight,  //to set the height of appBar
        title: const Text("Taskly!" , style: TextStyle(fontSize: 25 ),),  //to set the title
      ), //top bar of the page
    );
  }
}
