import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:get/get.dart';

class LoginSignup extends StatefulWidget {
  @override

  LoginSignup({
    this.auth,
    this.onLoggedIn
  });

  final AuthImplementation auth;
  final VoidCallback onLoggedIn;

  _LoginSignupState createState() => _LoginSignupState();
}


enum FormType {
  login,
  signup
}

class _LoginSignupState extends State<LoginSignup> {

  var _formKey = GlobalKey<FormState>();

  var _name = "";
  var _email = "";
  var _password = "";
  var _confirmPassword = "";

  // Default value of Form Type when app is opened
  FormType _formType = FormType.login;

  // Input controller for validation
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()){
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if(_formType == FormType.login) {

          Get.snackbar(
            "Signing-in",
            "please wait...",
            duration: Duration(minutes: 5),
            backgroundColor: Color(0xfffCCF2F4),
            borderWidth: 2,
            borderColor: Color(0xfffA4EBF3),
            snackPosition: SnackPosition.BOTTOM,
            showProgressIndicator: true,
            progressIndicatorValueColor:  AlwaysStoppedAnimation<Color>(Color(0xfff7296CD)),
            progressIndicatorBackgroundColor: Color(0xfffCCF2F4),
            margin: EdgeInsets.all(20.0),
            borderRadius: 0.0,
            isDismissible: false,
          );

          String userId = await widget.auth.logIn(_email, _password);
          Get.back();
          print("Log in userId = $userId");
        }

        else {

          Get.snackbar(
            "Signing-up",
            "please wait...",
            duration: Duration(minutes: 5),
            backgroundColor: Color(0xfffCCF2F4),
            borderWidth: 2,
            borderColor: Color(0xfffA4EBF3),
            snackPosition: SnackPosition.BOTTOM,
            showProgressIndicator: true,
            progressIndicatorValueColor:  AlwaysStoppedAnimation<Color>(Color(0xfff7296CD)),
            progressIndicatorBackgroundColor: Color(0xfffCCF2F4),
            margin: EdgeInsets.all(20.0),
            borderRadius: 0.0,
            isDismissible: false,
          );

          String userId = await widget.auth.signUp(_email, _password);

          await widget.auth.userSetup(_name);
          Get.back();
          print("Sign-up userId = $userId");
        }
        widget.onLoggedIn();
      } catch (e) {
        Get.back();
        var textError = e.toString();
        showError(context, textError);
        print(e);
      }
    }
  }

  // Reset the Input field and Change the FormType to Sign-up
  void goToSignup() {
    _formKey.currentState.reset();

    setState(() {
      _formType = FormType.signup;
    });
  }

  // Reset the Input field and Change the FormType to Log in
  void goToLogin() {
    _formKey.currentState.reset();

    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: createForm(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createForm() {
    if (_formType == FormType.login) {
      return [
        Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                  child: Column(
                    children: [
                      getImageAsset(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "To-do App",
                        style: TextStyle(
                            fontSize: 30.0
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) => value.isEmpty ? "Please enter email.": null,
                  onSaved: (value) => _email = value,
                  decoration: InputDecoration(
                    labelText: "Email",
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
                  controller: passwordController,
                  validator: (value) => value.isEmpty ? "Please enter password.": null,
                  onSaved: (value) => _password = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
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
                validateAndSubmit();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)),
                backgroundColor:MaterialStateProperty.all(Color(0xfff7296CD)),
              ),
              child: Text(
                "Log in",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              Get.back();
              goToSignup();
            },
            child: Text(
              "Don't have an account? Create Account",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800]
              ),
            ))
      ];
    } else {
      return [
        Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                  child: Column(
                    children: [
                      getImageAsset(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "To-do App",
                        style: TextStyle(
                            fontSize: 30.0
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: nameController,
                  validator: (value) => value.isEmpty ? "Please enter your name.": null,
                  onSaved: (value) => _name = value,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: emailController,
                  validator: (value) => value.isEmpty ? "Please enter email.": null,
                  onSaved: (value) => _email = value,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) => value.isEmpty ? "Please enter password.": null,
                  onSaved: (value) => _password = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) => value.isEmpty ? "Please confirm password.": null,
                  onSaved: (value) => _confirmPassword = value,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    focusedBorder: OutlineInputBorder(
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
                if (passwordController.text == confirmPasswordController.text) {
                  validateAndSubmit();
                } else {
                  Get.snackbar(
                    "Password mismatch",
                    "Please enter correct password.",
                    icon: Icon(Icons.error_outline),
                    shouldIconPulse: false,
                    duration: Duration(seconds: 3),
                    backgroundColor: Color(0xfffFFC074),
                    borderWidth: 2,
                    borderColor: Color(0xfffEBA83A),
                    snackPosition: SnackPosition.BOTTOM,
                    margin: EdgeInsets.all(20.0),
                    borderRadius: 0.0,
                    isDismissible: false,
                  );
                }

              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),)),
                backgroundColor:MaterialStateProperty.all(Color(0xfff7296CD)),
              ),
              child: Text(
                "Sign-up",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              Get.back();
              goToLogin();
            },
            child: Text(
              "Have an account? Log in",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800]
              ),
            ))
      ];
    }
  }

  // ALERT DIALOG SHOWING ERROR
  void showError(BuildContext context, String errorMessage) {
    var alertDialog = AlertDialog(
      title: Text("Error"),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(errorMessage)
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () {
          return Navigator.pop(context);
        },
            child: Text("Close"))
      ],
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  // WIDGET FOR RETURNING AN IMAGE
  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/splash.png");
    Image image = Image(
      image: assetImage,
      width: 180.0,
      height: 180.0,
    );
    return Container(
      child: image,
    );
  }
}
