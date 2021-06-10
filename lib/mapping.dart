import 'package:flutter/material.dart';

import 'login_signup_page.dart';
import 'home_page.dart';
import 'authentication.dart';

class Mapping extends StatefulWidget {
  final AuthImplementation auth;

  Mapping({
    this.auth,
  });

  @override
  _MappingState createState() => _MappingState();
}

enum AuthStatus {
  loggedOut,
  loggedIn,
}

class _MappingState extends State<Mapping> {

  AuthStatus _authStatus = AuthStatus.loggedOut;

  void iniState() {
    super.initState();

    widget.auth.getCurrentUser().then((firebaseUserId) => setState(() {
      _authStatus = firebaseUserId == null ? AuthStatus.loggedOut : AuthStatus.loggedIn;
    }));

  }

  void _loggedIn() {
    setState(() {
      _authStatus = AuthStatus.loggedIn;
    });
  }

  void _loggedOut() {
    setState(() {
      _authStatus = AuthStatus.loggedOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(_authStatus) {
      case AuthStatus.loggedOut:
        return LoginSignup(
          auth: widget.auth,
          onLoggedIn: _loggedIn
      );

      case AuthStatus.loggedIn:

        return Home(
            auth: widget.auth,
            onLoggedOut: _loggedOut,
      );
    }
  }
}
