import 'package:todo_app/firebase_query.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'firebase_query.dart';
import 'package:get/get.dart';

class EditTask extends StatefulWidget {

  EditTask({@required this.taskId, @required this.title, @required this.description});
  final String taskId;
  final String title;
  final String description;

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {

  CrudMethods crudMethods = CrudMethods();

  var _formKey = GlobalKey<FormState>();

  var title = "";
  var description = "";

  // Input controller for validation
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  var name;
  var displayName;

  var data;
  var gotData;

  var gotTaskId;
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

    print("gotTaskId: $gotTaskId");

    super.initState();
  }


  void saveToDatabase(taskId) {
    print(title);
    print(description);

    var data = {
      "title": title,
      "description": description,
    };

    crudMethods.updateData(data, taskId);
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

  void saveEditedTask(taskId) async {
    if (validateAndSave()) {
      Navigator.pop(context);
      saveToDatabase(taskId);

      Get.snackbar(
        "Updated",
        "Your task has been updated.",
        icon: Icon(Icons.edit),
        shouldIconPulse: false,
        duration: Duration(seconds: 3),
        backgroundColor: Color(0xfffCCF2F4),
        borderWidth: 2,
        borderColor: Color(0xfffA4EBF3),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(20.0),
        borderRadius: 0.0,
        isDismissible: false,
      );

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
          title: Text("Edit Task", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xfff343a40),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Delete Task",
          onPressed: () {
            deleteDialog(context, widget.taskId);
          },
          child: const Icon(Icons.delete, color: Colors.white,),
          backgroundColor: Color(0xfffdc3545),
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
                          controller: titleController..text = widget.title,
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
                          controller: descriptionController..text = widget.description,
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
                        saveEditedTask(widget.taskId);
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)),
                        backgroundColor:MaterialStateProperty.all(Color(0xfff7296CD)),
                      ),
                      child: Text(
                        "Update task",
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

  void deleteDialog(BuildContext context, taskId) {
    var alertDialog = AlertDialog(
      title: Text("Delete task?"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [Text("Are you sure you want to delete this task?")],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: ()  async {
              await FirebaseFirestore.instance.collection("tasks").doc(taskId).delete();
              Navigator.pop(context);
              Navigator.pop(context);

              Get.snackbar(
                "Deleted",
                "Your task has been deleted.",
                icon: Icon(Icons.delete),
                shouldIconPulse: false,
                duration: Duration(seconds: 3),
                backgroundColor: Color(0xfffF56A79),
                borderWidth: 2,
                borderColor: Color(0xfffFF4B5C),
                snackPosition: SnackPosition.BOTTOM,
                margin: EdgeInsets.all(20.0),
                borderRadius: 0.0,
                isDismissible: false,
              );

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
}
