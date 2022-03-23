//class that models a task of the list view

import 'dart:html';

class Task {
  String content; //title
  DateTime timestamp; //time and date
  bool done; //ticked or not(done or not)

  Task(
      {required this.content,
      required this.timestamp,
      required this.done}); //constructor

//factory constructors take up some arguments and returns an instance of the class
  factory Task.fromMap(Map task) {
    return Task(
        content: task["content"],
        timestamp: task["timestamp"],
        done: task["done"]);
  }

  Map toMap() {
    //converts our content to a map , that we will store in hive database
    //as hive is key-value pair database
    return {
      "content": content,
      "timestamp": timestamp,
      "done": done,
    };
  }
}
