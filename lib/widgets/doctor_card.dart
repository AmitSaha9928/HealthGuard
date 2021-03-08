import 'package:HealthGuard/helper/validation_tool.dart';
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/view/doctor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/constants.dart' as Constants;

class DoctorCard extends StatelessWidget{
  final OurUser.User doctor;

  DoctorCard({Key key,
  @required this.doctor})
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            color: Color(0xffECF0F5),
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[

                displayCircleImage(doctor.profilePictureURL, 70, true),

                SizedBox(width: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5,),

                    Text(
                      doctor.fullNameDr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: Constants.FONTSTYLE,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 250,
                      height: 50,
                      child: Text(
                        doctor.aboutYourself,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          fontFamily: Constants.FONTSTYLE,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetail(doctor: doctor,)));
        },
      ),
    );
  }
}