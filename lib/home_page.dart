import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import 'package:path/path.dart' as Path;

import 'authentication.dart';
import 'add_task_page.dart';
import 'firebase_query.dart';

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
                  title: snapshot.data.docs[index].data()['title'],
                  description: snapshot.data.docs[index].data()['description'],
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
              return Upload();
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

  String title, description;

  CrudMethods crudMethods = CrudMethods();

  Tasks(
      {
      @required this.title,
      @required this.description,
      });


  @override
  Widget build(BuildContext context) {

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
                Text(
                  title,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteDialog(context);
                  },
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              description,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void deleteDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Delete post?"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [Text("Are you sure you want to delete this post?")],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: ()   {
            //  DELETE POST
            // User user = FirebaseAuth.instance.currentUser;
            // String userUid = user.uid.toString();
            //
            // var data;
            // var dbUid;
            //
            // var imgUrl;
            //
            // FirebaseFirestore.instance
            //     .collection('blogs')
            //     .doc(id)
            //     .get()
            //     .then((DocumentSnapshot documentSnapshot) async {
            //   data = documentSnapshot.data();
            //   dbUid = (data["uid"]);
            //   imgUrl = (data["image"]);
            //
            //   print("dbUid: $dbUid");
            //   print("userUid: $userUid");
            //   print("image: $imgUrl");
            //
            //   var url = (data["image"]);
            //
            //   var fileUrl = Uri.decodeFull(Path.basename(url)).replaceAll(new RegExp(r'(\?alt).*'), '');
            //
            //   if (userUid == dbUid) {
            //
            //     Reference storageReference = FirebaseStorage.instance.ref(fileUrl);
            //     await storageReference.delete();
            //
            //     await FirebaseFirestore.instance.collection("blogs").doc(id).delete();
            //
            //     Get.back();
            //     Get.snackbar('Deleted', 'Your post has been deleted.');
            //   } else {
            //     deleteErrorDialog(context);
            //   }
            // });
            // crudMethods.deletePost(id);

          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
            backgroundColor: MaterialStateProperty.all(Colors.redAccent),
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

