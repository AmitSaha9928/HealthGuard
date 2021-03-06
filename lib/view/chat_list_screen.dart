
import 'dart:ui';

import 'package:HealthGuard/main.dart';
import 'package:HealthGuard/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

import 'chat_with_patient.dart';


class ChatList extends StatefulWidget{
  /// screen ID for navigator routing
  static const String id = "ChatList";

  @override
  _ChatListState createState() => _ChatListState();
}


/// Chat with Patient screen page state class
class _ChatListState extends State<ChatList>{

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;
  final ScrollController listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //registerNotification();
    //configLocalNotification();
    listScrollController.addListener(scrollListener);
  }

  /// Setting the limit of number of doctor accounts to be shown per screen
  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Chat List',
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
      body: Stack(
        children: <Widget>[
          Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(Constants.USERS).where("userType", isEqualTo: accountInterested()).limit(_limit).snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Constants.CIRCULAR_PROGRESS_INDICATOR),
                    ),
                  );
                }else if(snapshot.data.size == 0){
                  return Container( color: Color(0xFFF6F8FC),
                    child: Center(
                      child:  Text(
                        'Chat with a Doctor Now!',
                        style: TextStyle(
                          fontSize: 24,
                          color: Constants.TEXT_SUPER_LIGHT,
                          fontFamily: Constants.FONTSTYLE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(context, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    controller: listScrollController,
                  );
                }
              },
            ),
          ),
          Positioned(
            child: isLoading ? const Loading() : Container(),
          )
        ],
      ),
    );
  }

  /// Handles the display of each doctor's account
  Widget buildItem(BuildContext context, DocumentSnapshot document){
    if(document.data()['userId'] == MyAppState.currentUser.userID){
      return Container();
    }else{
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document.data()['profilePictureURL'] != null
                    ? CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Constants.CIRCULAR_PROGRESS_INDICATOR),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ),
                  imageUrl: document.data()['profilePictureURL'],
                  width:50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ): Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.green,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${document.data()['firstName']} ${document.data()['lastName']}',
                            style:TextStyle(
                              color: Constants.TEXT_LIGHT,
                              fontFamily: Constants.FONTSTYLE,
                              fontWeight: Constants.APPBAR_TEXT_WEIGHT,
                              fontSize: 20.0,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    )
                ),
              )
            ],
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Chat(
                  peerId: document.id,
                  peerAvatar: document.data()['profilePictureURL'],
                ),
              ),
            );
          },
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  /// Determines which type of account to be displayed in the chat list screen
  String accountInterested(){
    if(MyAppState.currentUser.userType == "Doctor"){
      return "Patient";
    }else{
      return "Doctor";
    }
  }
}