import 'dart:ui';
import 'package:HealthGuard/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/widgets/custom_clipper.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// Medication reminder card that will be displayed in the Medication Reminder Screen
class MedicationReminderCardLarge extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String time;
  final ImageProvider image;
  bool isDone;

  MedicationReminderCardLarge(
      {Key key,
        @required this.title,
        @required this.value,
        @required this.unit,
        @required this.time,
        this.image,
        this.isDone,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 350,
          margin: EdgeInsets.only(top: 10),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            color: Colors.white,
          ),
          child: Stack(
            overflow: Overflow.clip,
            children: <Widget>[
              Positioned(
                child: ClipPath(
                  clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Constants.BUTTON_COLOUR.withOpacity(0.06),
                    ),
                    height: 110,
                    width: 110,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image(
                          image: image,
                          width: 24,
                          height: 24,
                          color: Color(0xFF3B72FF),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 15,
                            color: Constants.TEXT_LIGHT,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.TEXT_LIGHT,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '$value $unit',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Constants.TEXT_LIGHT,
                                  fontFamily: Constants.FONTSTYLE,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),

                        

                        /// Functions to delete the medicine to be added here
                        InkWell(
                            child: Container(
                              decoration: new BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                shape: BoxShape.rectangle,
                                color: isDone
                                    ? Color(0xFF3B72FF)
                                    : Color(0xFFF0F4F8),
                              ),
                              width: 44,
                              height: 44,
                              child: Center(
                                child: Icon(
                                  Icons.delete_outline_outlined,
                                  color:
                                  isDone ? Colors.white : Color(0xFF3B72FF),
                                ),
                              ),
                            ),
                            onTap: () async {
                              FirebaseFirestore.instance.collection(Constants.USERS).doc(MyAppState.currentUser.userID).collection(Constants.MEDICATION_INFO).where("medicineName", isEqualTo: this.title).get().then((value){value.docs.forEach((element){
                                FirebaseFirestore.instance.collection(Constants.USERS).doc(MyAppState.currentUser.userID).collection(Constants.MEDICATION_INFO).doc(element.id).delete();
                              });
                              });
                            },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
