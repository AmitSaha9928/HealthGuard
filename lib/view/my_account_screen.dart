import 'package:HealthGuard/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// User's account information screen page widget class
class MyAccount extends StatefulWidget{
  static const String id = "MyAccountPage";
  const MyAccount({Key key}) : super(key: key);
  @override
  _MyAccountState createState() => _MyAccountState();
}

/// My account screen page state class
class _MyAccountState extends State<MyAccount>{
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'My Account',
          style: TextStyle(
            color: Colors.white,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: Constants.APPBAR_TEXT_WEIGHT,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Constants.APPBAR_COLOUR,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        /// Creating a stream connecting to the database (collection is to access the collection, doc is to access the document within the collection)
          stream: db.collection(Constants.USERS).doc(MyAppState.currentUser.userID).collection(Constants.ACC_INFO).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              var doc = snapshot.data.documents;
              return new ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index){
                    return Column(
                      children: <Widget>[
                        /// Full Name
                        Text("Name: " + MyAppState.currentUser.fullName(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                            fontSize: 15,
                          ),
                        ),

                        /// User id
                        Text("User ID: " + MyAppState.currentUser.userID,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                            fontSize: 15,
                          ),
                        ),

                        /// Email Address
                        Text("Email Address: " + MyAppState.currentUser.email,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                            fontSize: 15,
                          ),
                        ),

                        /// Phone Number
                        Text("Phone Number: " + MyAppState.currentUser.phoneNumber,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                            fontSize: 15,
                          ),
                        ),

                        /// Sex
                        Text("Gender: " + MyAppState.currentUser.sex,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                            fontSize: 15,
                          ),
                        ),

                        /// Birthday
                        Text("Birthday: " + MyAppState.currentUser.birthday,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: Constants.FONTSTYLE,
                            fontSize: 15,
                          ),
                        ),

                      ],
                    );
                  }
              );
            }else{
              return Column(
                children: <Widget>[
                  LinearProgressIndicator(),
                  Text("Nothing To Show",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: Constants.FONTSTYLE,
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            }
          }
      ),
    );
  }
}