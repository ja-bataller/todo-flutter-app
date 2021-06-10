import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthImplementation {
  Future <String> logIn (String email, String password);
  Future <String> signUp (String email, String password);
  Future<void> userSetup(String displayName);
  Future <String> getCurrentUser();
  Future <void> logOut();
}

class Auth implements AuthImplementation {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  Future <String> logIn (String email, String password) async {
    User user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  Future <String> signUp (String email, String password) async {
    User user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  Future<void> userSetup(String displayName) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser.uid.toString();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(uid).set({'name': displayName, 'uid': uid});
    return;
  }

  Future <String> getCurrentUser() async {
    User user =  _firebaseAuth.currentUser;
    return user.uid;
  }

  Future <void> logOut() async {
    _firebaseAuth.signOut();
  }
}
