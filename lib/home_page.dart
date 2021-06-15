import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' as Path;

import 'authentication.dart';
import 'add_task_page.dart';
import 'edit_task_page.dart';
import 'firebase_query.dart';

import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  @override

  Home({this.auth, this.onLoggedOut});
  final AuthImplementation auth;
  final VoidCallback onLoggedOut;

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  CrudMethods crudMethods = new CrudMethods();

  var name;
  var displayName;
  var collectionId;

  Stream blogsStream;

  @override
  void initState() {

    crudMethods.getDisplayName().then((QuerySnapshot docs) {
      docs.docs.forEach((document) {
        name = document.data();
        setState(() {
          displayName = (name["name"]);
          collectionId = (name["uid"]);
        });
        print(displayName);
        print(collectionId);
      });
    });

    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
        print(result);
      });
      print("blogsStream: $blogsStream");
    });

    super.initState();
  }

  Widget tasksList() {
    return Container(
      child: blogsStream != null
          ? StreamBuilder(
        stream: blogsStream,
        builder: (context, snapshot) {
          return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Tasks(
                  taskId: snapshot.data.docs[index].reference.id,
                  title: snapshot.data.docs[index].data()['title'],
                  description: snapshot.data.docs[index].data()['description'],
                  dateTime: snapshot.data.docs[index].data()['createdOn'],
                );
              });
        },
      )
          : Container(
        alignment: Alignment.center,
        child: Center(
          child: Text(
            "No Tasks todo.",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _logoutUser() async {
    try {
      await widget.auth.logOut();
      widget.onLoggedOut();
    } catch (e) {
      print("Error = $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Image.asset(
            'images/splash.png'
          ),
          title: Text("To-do App", style: TextStyle(color: Colors.white)),
          backgroundColor: Color(0xfff343a40),
          actions: [
            Center(child: Text(displayName)),
            IconButton(
              tooltip: "Logout button",
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // _logoutUser();
                loggingOutDialog(context);
              },
              color: Color(0xfffdc3545),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Task",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return NewTask();
            }));
          },
          child: const Icon(Icons.add, color: Colors.white,),
          backgroundColor: Color(0xfff7296CD),
        ),
        body: tasksList(),
      ),
    );
  }

  void loggingOutDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Log-out"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [Text("Are you sure you want to log-out?")],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _logoutUser();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
            backgroundColor: MaterialStateProperty.all(Color(0xfffdc3545)),
          ),
          child: Text("Yes"),
        ),
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            )),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
          ),
          onPressed: () {
            return Navigator.pop(context);
          },
          child: Text("No"),
        )
      ],
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}

class Tasks extends StatelessWidget {

  String taskId, title, description;
  var dateTime;

  CrudMethods crudMethods = CrudMethods();

  Tasks(
      {
      @required this.taskId,
      @required this.title,
      @required this.description,
      @required this.dateTime,
      });


  @override
  Widget build(BuildContext context) {
    Timestamp dt = dateTime;
    DateTime dtd = dt.toDate();

    var strToDateTime = DateTime.parse(dtd.toString());
    var convertLocal = strToDateTime.toLocal();
    var newFormat = DateFormat("MM/dd/yyyy hh:mm:ss aaa");
    String datetimeFinal = newFormat.format(convertLocal);

    return Card(
      elevation:  10.0,
      margin: EdgeInsets.all(15.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {
                    //   return EditTask(taskId: taskId,);
                    // }));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditTask(taskId: taskId, title: title, description: description),
                        ));
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditTask(),
                    //     // Pass the arguments as part of the RouteSettings. The
                    //     // DetailScreen reads the arguments from these settings.
                    //     settings: RouteSettings(
                    //       arguments: taskId,
                    //     ),
                    //   ),
                    // );
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 5.0,
            ),
            Text(
              datetimeFinal,
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void deleteErrorDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Oops!"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [Text("Post not deleted. You're not the Author of this post.")],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
            backgroundColor: MaterialStateProperty.all(Colors.grey),
          ),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          child: Text("Close"),
        )
      ],
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}

