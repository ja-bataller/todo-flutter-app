import 'package:todo_app/firebase_query.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'firebase_query.dart';
import 'package:get/get.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  CrudMethods crudMethods = CrudMethods();

  var _formKey = GlobalKey<FormState>();

  var title = "";
  var description = "";

  // Input controller for validation
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var name;
  var displayName;

  var id;
  var deleteId;

  var uid;

  @override
  void initState() {

    crudMethods.getDisplayName().then((QuerySnapshot docs) {
      docs.docs.forEach((document) {
        name = document.data();
        displayName = (name["name"]);
        print(displayName);
      });
    });

    uid = crudMethods.getUsersUid();
    print(uid);

    super.initState();
  }


  void saveToDatabase() {
    var userUID = uid;
    var author = displayName;

    print(userUID);
    print(author);
    print(title);
    print(description);

    var data = {
      "uid": uid,
      "author": author,
      "title": title,
      "description": description,
    };

    crudMethods.addData(data);
  }

  bool validateAndSave() {
    final form = _formKey.currentState;

    if(form.validate()) {
      form.save();
      return true;
    }
    else {
      return false;
    }
  }

  void addTask() async {
    if (validateAndSave()) {

      Navigator.pop(context);

      saveToDatabase();
      Get.snackbar('Success', 'Your task has been added.', colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, backgroundColor: Color(0xfff343a40));
    }
  }

  void goToHomePage() {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Home();
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("New Task", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xfff343a40),
        ),
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: titleController,
                          validator: (value) => value.isEmpty ? "Please enter task title.": null,
                          onSaved: (value) => title = value,
                          decoration: InputDecoration(
                            labelText: "Title",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.brown),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                        child: TextFormField(
                          controller: descriptionController,
                          validator: (value) => value.isEmpty ? "Please enter task description.": null,
                          onSaved: (value) => description = value,
                          decoration: InputDecoration(
                            labelText: "Description",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            focusedBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.brown),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  child: SizedBox(
                    height: 50.0,
                    width: 250.0,
                    child: ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)),
                        backgroundColor:MaterialStateProperty.all(Color(0xfff7296CD)),
                      ),
                      child: Text(
                        "Add task",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
