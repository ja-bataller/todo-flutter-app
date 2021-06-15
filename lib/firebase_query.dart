import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrudMethods {

  Future<void> addData(newTask) async {
    FirebaseFirestore.instance
        .collection("tasks")
        .add(newTask)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> updateData(updateTask, taskId) async {
    FirebaseFirestore.instance
        .collection("tasks")
        .doc(taskId)
        .update(updateTask)
        .catchError((e) {
      print(e);
    });
  }

  Future getData() async {
    User user = FirebaseAuth.instance.currentUser;
    String uid = user.uid.toString();
    return await FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .orderBy("createdOn", descending: true)
        .snapshots();
  }

  getDisplayName()  {
    User user = FirebaseAuth.instance.currentUser;
    String uid = user.uid.toString();

    return FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();
  }

  getUsersUid() {
    User user = FirebaseAuth.instance.currentUser;
    String uid = user.uid.toString();
    return uid;
  }

}
