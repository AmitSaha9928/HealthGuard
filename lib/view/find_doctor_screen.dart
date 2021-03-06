import 'dart:ui';

import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/view/doctor_detail_screen.dart';
import 'package:HealthGuard/widgets/doctor_card.dart';
import 'package:HealthGuard/widgets/medicalCategoryCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/helper/string_helper.dart';

import 'package:HealthGuard/helper/database_helper.dart';

/// Find doctor screen page widget class
class FindDoctor extends StatefulWidget {
  static const String id = "FindDoctor";
  @override
  State createState() => _findDoctorsPageState();
}

bool isSearching = false;

/// Find doctor screen page state class
class _findDoctorsPageState extends State<FindDoctor> {
  bool isSearching = false;
  Stream usersStream;
  TextEditingController searchUsernameEditingController =
  TextEditingController();

  onSearchBtnClick() async {
    isSearching = true;
    setState(() {});
    usersStream = await DatabaseMethods()
        .getUserByFirstName(searchUsernameEditingController.text.capitalize());
    setState(() {});
  }

  onBackArrowClick() async {
    isSearching = false;
    searchUsernameEditingController.text = "";
    setState(() {});
  }

  /// Displays the list of doctors when the user has entered the name of the doctor to be searched
  Widget searchUsersList() {
    return Container(
      height: 350,
      child: StreamBuilder(
        stream: usersStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container();
          }else if(snapshot.data.size == 0){
            return Container(
              color: Color(0xFFF6F8FC),
              child: Center(
                child: Text(
                  'There is no such doctor',
                  style: TextStyle(
                    fontSize: 24,
                    color: Constants.TEXT_SUPER_LIGHT,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }else{
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index){
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return DoctorCard(
                    doctor:  OurUser.User(
                      email: ds["email"],
                      firstName: ds["firstName"],
                      lastName: ds["lastName"],
                      active: ds["active"],
                      lastOnlineTimestamp: ds["lastOnlineTimestamp"],
                      settings: null,
                      phoneNumber: ds["phoneNumber"],
                      userID: ds["id"],
                      profilePictureURL: ds["profilePictureURL"],
                      userType: ds["userType"],
                      sex: ds["sex"],
                      birthday: ds["birthday"],
                      workPlace: ds["workPlace"],
                      speciality: ds["speciality"],
                      aboutYourself: ds["aboutYourself"],
                      doctorID: ds["doctorID"],
                    ),

                  );
                }
            );
          }
        },
      ),
    );
  }

  /// The card that contains the details of the doctor being searched by the user
  Widget searchListUserTile(
      {String profilePictureURL, firstName, userstate, email}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, DoctorDetail.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                profilePictureURL,
                height: 40,
                width: 40,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(firstName), Text(email)])
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Constants.BACKGROUND_COLOUR,
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomPaint(
              painter: pathPainter(),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppBar(
                  title: Text(
                    'Find a doctor',
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
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.FONTSTYLE,
                        ),
                      ),

                      SizedBox(height: 10),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[

                            medicalCategoryCard(
                                imageName:
                                "Cardiologist.png",
                                text: "Cardiologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Gynaecologist.png",
                                text: "Gynaecologist"
                            ),

                            medicalCategoryCard(
                              imageName: "CT-Scan.png",
                              text: "CT-Scan",
                            ),

                            medicalCategoryCard(
                                imageName:
                                "MRI-Scan.png",
                                text: "MRI - Scan"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Dentist.png",
                                text: "Dentist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Dermatologist.png",
                                text: "Dermatologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Emergency.png",
                                text: "Emergency"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "ENT.png",
                                text: "ENT"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Gastroenterologist.png",
                                text: "Gastroenterologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Hepatologist.png",
                                text: "Hepatologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Nephrologist.png",
                                text: "Nephrologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Neurologist.png",
                                text: "Neurologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Nutritionist.png",
                                text: "Nutritionist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Obsterician.png",
                                text: "Obsterician"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Orthopaedic.png",
                                text: "Orthopaedic"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Pharmacist.png",
                                text: "Pharmacist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Psychologist.png",
                                text: "Psychologist"
                            ),

                            medicalCategoryCard(
                                imageName:
                                "Surgeon.png",
                                text: "Surgeon"
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Search Doctor",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: Constants.FONTSTYLE,
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(children: [
                              isSearching
                                  ? GestureDetector(
                                onTap: () {
                                  onBackArrowClick();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.arrow_back),
                                ),
                              )
                                  : Container(),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 16.0),
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller:
                                          searchUsernameEditingController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Doctor's name",
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            if (searchUsernameEditingController
                                                .text !=
                                                "") {
                                              onSearchBtnClick();
                                            }
                                          },
                                          child: Icon(Icons.search)),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),

                      isSearching ? searchUsersList() : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "All Doctor",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              fontFamily: Constants.FONTSTYLE,
                            ),
                          ) ,
                          recommendDoctors()
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Container to display all the doctors available in our database
  Container recommendDoctors() {
    final db = FirebaseFirestore.instance;
    return Container(
      height: 350,
      child: StreamBuilder<QuerySnapshot>(
        stream: db.collection(Constants.USERS).where("userType", isEqualTo: "Doctor").snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Container();
          }else if(snapshot.data.size == 0){
            return Container(
              color: Color(0xFFF6F8FC),
              child: Center(
                child: Text(
                  'No Doctors available',
                  style: TextStyle(
                    fontSize: 24,
                    color: Constants.TEXT_SUPER_LIGHT,
                    fontFamily: Constants.FONTSTYLE,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }else{
            var doc = snapshot.data.documents;
            return new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: doc.length,
              itemBuilder: (context, index){
                return Container(
                  child: DoctorCard(
                    doctor: OurUser.User(
                      email: doc[index].get("email"),
                      firstName: doc[index].get("firstName"),
                      lastName: doc[index].get("lastName"),
                      active: doc[index].get("active"),
                      lastOnlineTimestamp: doc[index].get("lastOnlineTimestamp"),
                      settings: null,
                      phoneNumber: doc[index].get("phoneNumber"),
                      userID: doc[index].get("id"),
                      profilePictureURL: doc[index].get("profilePictureURL"),
                      userType: doc[index].get("userType"),
                      sex: doc[index].get("sex"),
                      birthday: doc[index].get("birthday"),
                      workPlace: doc[index].get("workPlace"),
                      speciality: doc[index].get("speciality"),
                      aboutYourself: doc[index].get("aboutYourself"),
                      doctorID: doc[index].get("doctorID"),
                    ),),
                );
              },
            );
          }
        },
      ),
    );
  }

}


/// For UI purposes
class pathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = new Paint();
    paint.color = Color(0xffcef4e8);

    Path path = new Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.3, 0);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.03,
        size.width * 0.42, size.height * 0.17);
    path.quadraticBezierTo(
        size.width * 0.35, size.height * 0.32, 0, size.height * 0.29);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
