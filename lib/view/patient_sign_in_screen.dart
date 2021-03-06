import 'dart:async';
import 'package:HealthGuard/view/doctor_sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:HealthGuard/view/patient_sign_up_screen.dart';
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/home.dart';
import 'package:HealthGuard/main.dart';
import 'forgot_password_screen.dart';

final _fireStoreUtils = FireStoreUtils();

/// Login screen page widget class
class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// Login screen page state class
class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String email, password;
  bool _validate = false;
  GlobalKey<FormState> _key = new GlobalKey();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Widget> buildInputs() {
    return [
      /// Displaying the logo on the login screen page
      SizedBox(
        height: 155.0,
        child: Image.asset(
          "assets/Logo.png",
          fit: BoxFit.contain,
        ),
      ),
      SizedBox(height: 40.0),

      /// Field for user's email input
      TextFormField(
        validator: validateEmail,
        onSaved: (String val) {
          email = val;
        },
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        controller: _emailController,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Patient's Email Address",
          icon: Icon(Icons.mail, color: Constants.TEXT_LIGHT),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),

      SizedBox(height: 20.0),

      /// Field for user's password input
      TextFormField(
        validator: validatePassword,
        onSaved: (String val) {
          password = val;
        },
        controller: _passwordController,
        obscureText: true,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            icon: Icon(Icons.vpn_key, color: Constants.TEXT_LIGHT),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      ),
      SizedBox(
        height: 10.0,
      ),
      forgetPassword(),
    ];
  }

  /// Button for user to submit their login credentials
  List<Widget> buildSubmitButtons() {
    return [
      Padding(
        padding: const EdgeInsets.only(right: 40.0, left: 40.0, top: 20.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: RaisedButton(
            color: Constants.BUTTON_COLOUR,
            child: Text('Login',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: Constants.FONTSTYLE,
                )),
            textColor: Colors.white,
            splashColor: Constants.BUTTON_SPLASH_COLOUR,
            onPressed: () async {
              await onClick(_emailController.text, _passwordController.text);
            },
            padding: EdgeInsets.only(top: 12, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(color: Constants.BUTTON_COLOUR)),
          ),
        ),
      ),

      /// Sign up here wording (User tap to redirect them to sign up page)
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Don't have an account?",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                push(context, new signup_page());
                print("Routing to Sign Up screen");
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Constants.BUTTON_COLOUR),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
      ),
      Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Constants.BUTTON_COLOUR,
                            Colors.black,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      "Or",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontFamily: Constants.FONTSTYLE,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.black,
                            Constants.BUTTON_COLOUR,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Are you a doctor?",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, DoctorSignIn.id);
              },
              child: Text(
                "Yes!",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Constants.BUTTON_COLOUR),
              ),
            )
          ],
        ),
        padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
      ),
    ];
  }

  /// Forget password
  Widget forgetPassword() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ForgotPassword.id);
            },
            child: Text(
              "Forgot your password?",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Constants.BUTTON_COLOUR),
            ),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 0.0, bottom: 15.0),
    );
  }

  /// Directing user to their account
  onClick(String email, String password) async {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      showProgress(context, 'Logging in, please wait...', false);
      OurUser.User user =
          await loginWithUserNameAndPassword(email.trim(), password.trim());

      /// Checking if the user is a patient or a doctor
      if (user != null && user.userType == 'Patient') {
        pushAndRemoveUntil(context, home(), false);
      } else {
        user.active = false;
        _fireStoreUtils.updateCurrentUser(user, context);
        await FirebaseAuth.instance.signOut();
        MyAppState.currentUser = null;
        pushAndRemoveUntil(context, LoginPage(), false);
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  /// Checking if user's input credential's validity
  /// If valid, allow access to account
  /// Else display error
  Future<OurUser.User> loginWithUserNameAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot documentSnapshot = await FireStoreUtils.firestore
          .collection(Constants.USERS)
          .doc(result.user.uid)
          .get();
      OurUser.User user;
      if (documentSnapshot != null && documentSnapshot.exists) {
        user = OurUser.User.fromJson(documentSnapshot.data());
        user.active = true;
        await _fireStoreUtils.updateCurrentUser(user, context);
        hideProgress();
        MyAppState.currentUser = user;
      }
      return user;
    } catch (exception) {
      hideProgress();

      switch ((exception as FirebaseException).code) {
        case 'ERROR_INVALID_EMAIL':
          showAlertDialog(context, 'Error', 'Email address is malformed.');
          break;
        case 'ERROR_USER_NOT_FOUND':
          showAlertDialog(context, 'Error',
              'Password does not match. Please type in the correct password.');
          break;
        case 'ERROR_USER_NOT_FOUND':
          showAlertDialog(context, 'Error',
              'No user corresponding to the given email address.');
          break;
        case 'ERROR_USER_DISABLED':
          showAlertDialog(context, 'Error', 'This user has been disabled.');
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          showAlertDialog(
              context, 'Error', 'There were too many attempts to sign in.');
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          showAlertDialog(
              context, 'Error', 'Email and Password are not enabled');
          break;
      }
      print(exception.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      body: Form(
        key: _key,
        autovalidate: _validate,
        child: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              children: buildInputs() + buildSubmitButtons(),
            ),
          ),
        ]),
      ),
    );
  }
}
