import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  String? _newTaskContent; //for what we input in textfield

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
      body: _tasksView(), //set the body to list View
      floatingActionButton:
          _addTaskButton(), //to add a floatingActionButton on our scaffold
    );
  }

//This function can't be async as UI can't be async -> something needs to be rendered on the screen
  Widget _tasksView() {
    //creating a box in hive with a  name , a box in hive is a container that stores data
    // Hive.openBox("tasks");  ---> it returns a box (this is a future , so we need to wait for it to complete , then only we can re-render the list on the screen)
    //but since UI can't be async , we can't use await here

    //so we use FutureBuilder method
    //it takes in a future and a builder function(that defines when this future has been resolved or when it hasn't been resolved)
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      //snapshot contains information about the status of the future and the value that was obtained from the future
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.connectionState == ConnectionState.done) {
          //whether the snapshot's future is done or not
          
          return _tasksList(); //return the list to re-render
        } else {
          //Center(child: ) widget centers the child widget it has
          return const Center(
              child:
                  CircularProgressIndicator()); //render a loading circular indicator
        }
      },
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
    //by default it appears on right-bottom corner and stays there irrespective of if we scroll
    return FloatingActionButton(
      onPressed: _displayTaskPopup, //what happens when we click on button,
      //passing the function that we created

      child: const Icon(Icons.add), //'+' icon added
    );
  }

  void _displayTaskPopup() {
    //kind of like a toast
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        //builder is responsible for rendering the dialog
        return AlertDialog(
          //widget that alerts the user
          title: const Text("Add new task!"),
          content: TextField(
            //where the user can input a text
            onSubmitted:
                (_value) {}, //when we submit (the _value is a string parameter)
            onChanged: (_value) {
              setState(() {
                //if we don't use setState function , the variable _newTaskContent would still be set to _value , but it won't re-render the app and our changes wouldn't be visible on the screen
                _newTaskContent = _value;
              });
            }, //what happens when we start typing
          ),
        );
      },
    );
  }
}
