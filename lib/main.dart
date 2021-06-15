import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'authentication.dart';
import 'mapping.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CyclingWorldBlogs());
}


class CyclingWorldBlogs extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "To Do",
      home: Mapping(
        auth: Auth(),
      ),
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Color(0xfff7296CD)
      ),
    );
  }
}


