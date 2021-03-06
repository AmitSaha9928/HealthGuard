import 'package:HealthGuard/model/user_medic_info_model.dart';
import 'package:HealthGuard/widgets/medical_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

/// User's medical information screen page widget class
class MyMedical extends StatefulWidget {
  static const String id = "MyMedicalPage";
  final String userID;

  const MyMedical({Key key, @required this.userID}) : super(key: key);
  @override
  _MyMedicalState createState() => _MyMedicalState(userID);
}

/// User's medical information screen page state class
class _MyMedicalState extends State<MyMedical> {
  final String userID;
  final db = FirebaseFirestore.instance;

  _MyMedicalState(this.userID);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Medical Information',
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
          stream: db
              .collection(Constants.USERS)
              .doc(userID)
              .collection(Constants.MED_INFO)
              .orderBy("uploadedDate", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data.size == 0) {
              return Container(
                color: Color(0xFFF6F8FC),
                child: Center(
                  child: Text(
                    'Nothing to be shown',
                    style: TextStyle(
                        fontSize: 24,
                        color: Constants.TEXT_SUPER_LIGHT,
                        fontFamily: Constants.FONTSTYLE,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              var doc = snapshot.data.documents;

              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: doc.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {

                    return MedicalCard(
                      medicInfo: new user_medic_info(
                        height: doc[index].get("height"),
                        weight: doc[index].get("weight"),
                        healthCondition: doc[index].get("healthCondition"),
                        currentMedication: doc[index].get("currentMedication"),
                        address: doc[index].get("address"),
                        emergencyContact: doc[index].get("emergencyContact"),
                        insuranceID: doc[index].get("insuranceID"),
                        uploadedDate: doc[index].get("uploadedDate"),
                        medicalReportImage: doc[index].get("medicalReportImage"),
                      ),
                    );
                  },
                ),
              );
            }
          }),
    );
  }
}