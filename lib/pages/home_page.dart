import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

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
  Box?
      _box; //the reference to the return value of the future (the Hive box future)

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
    //creating/opening(if already made) a box in hive with a  name , a box in hive is a container that stores data
    // Hive.openBox("tasks");  ---> it returns a box (this is a future , so we need to wait for it to complete , then only we can re-render the list on the screen)
    //but since UI can't be async , we can't use await here

    //so we use FutureBuilder method
    //it takes in a future and a builder function(that defines what happens when this future has been resolved or when it hasn't been resolved)
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      //snapshot contains information about the status of the future and the value that was obtained from the future
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          //we could have also used _snapshot.connectionState == ConnectionState.done
          //we used hasData(even if it already had data) here as the hive.openBox() future would return instantly when it has already been created
          //so we need not to wait for the future and wait for the scrolling animation to go ,IF YOU KNOW WHAT I MEAN
          //whether the snapshot's future is done or not

          _box = _snapshot
              .data; //holds what is returned when the future is completed
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
    // Task _newTask = new Task(
    //     content: "Learn Flutter", timestamp: DateTime.now(), done: false); //creating a task object

    // _box?.add(_newTask.toMap());  //added this in our database(used null safety as box is nullable , if it is null then don't run this method)
    // //we have to convert it toMap (using our custom method) as hive is a key-value pair database

    List tasks = _box!.values
        .toList(); //this gives us all the tasks stored in our database in list form
    //this '!' is a null safety operator , which means that we ignore null safety here (if it is null , it will give an error tho)
    //we ignore null safety here as we only return this widget when our box' future has been resolved

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (BuildContext _context, int _index) {
        //we have to return each tile

        var task =
            Task.fromMap(tasks[_index]); //this is each task from the tasks list

        return ListTile(
          //a prebuilt item tile for a list
          title: Text(
            task.content, //we extract content from the task variable
            style: TextStyle(
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ), //lineThrough -> to basically cut a line

          subtitle:
              Text(task.timestamp.toString()), //another property of listTile
          //DateTime.now() -> current date and time

          trailing: Icon(
            task.done
                ? Icons.check_box_outlined //ticks the box
                : Icons
                    .check_box_outline_blank_outlined, //doesn't ticks the box
            color: Colors.red,
          ), //a widget to display after the title(mostly an icon) that is right aligned
          //Icon widget

          onTap: () {
            //what happens when we tap/click on the list tile
            task.done = !task.done; //opposite of what it was
            _box!.putAt(_index,
                task.toMap()); //putAt function is used to change an existing value in the map
            setState(() {
              //to re render the screen
            });
          },

          onLongPress: () {
            //what happens on long press on tile
            _box!.deleteAt(_index);  //delete the one long pressed
            setState(() {
              //to re render
            });
          },
        );
      },
    ); //this builds us a list view
    //item builder is : how this builder is going to build the list view
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
            onSubmitted: (_) {
              if (_newTaskContent != null) {
                Task _task = Task(
                    content:
                        _newTaskContent!, //added ! to ignore null safety as we already checked it in if statement
                    timestamp: DateTime.now(),
                    done: false);
                _box?.add(_task.toMap()); //then add it to the hive box
                setState(() {
                  //re render the screen
                  _newTaskContent = null; //also set it to null again
                  Navigator.pop(
                      _context); //this is to go to the page when we press done after typing in the textfield
                });
              }
            },
            onChanged: (_value) {
              //this value parameter is the string that we type in the textfield
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
