import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor extends User{

  String workPlace = '';
  String speciality = '';
  String aboutYourself = "";
  String doctorID = "";

  Doctor({String email, String firstName, String lastName, OurUser.Settings settings, String phoneNumber, bool active, Timestamp lastOnlineTimestamp, String userID, String profilePictureURL, String userType, this.workPlace, this.speciality, this.aboutYourself, this.doctorID}) :
        super(email: email, firstName: firstName, lastName: lastName, settings: settings, phoneNumber: phoneNumber,
          active: active, lastOnlineTimestamp: lastOnlineTimestamp, userID: userType, profilePictureURL: profilePictureURL, userType: "Doctor");

  factory Doctor.fromJson(Map<String, dynamic> parsedJson){
    return new Doctor(
      email: parsedJson['email'] ?? "",
      firstName: parsedJson['firstName'] ?? '',
      lastName: parsedJson['lastName'] ?? '',
      active: parsedJson['active'] ?? false,
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      settings: OurUser.Settings.fromJson(
          parsedJson['settings'] ?? {'allowPushNotifications': true}),
      phoneNumber: parsedJson['phoneNumber'] ?? "",
      userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
      profilePictureURL: parsedJson['profilePictureURL'] ?? "",
      userType: parsedJson['userType'] ?? "",
      workPlace: parsedJson['workPlace'] ?? "",
      speciality: parsedJson['speciality'] ?? "",
      aboutYourself: parsedJson['aboutYourself'] ?? "",
      doctorID: parsedJson['doctorID'] ?? "",
    );
  }

  Map<String, dynamic> toJson(){
    return{
      "email": this.email,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "settings": this.settings.toJson(),
      "phoneNumber": this.phoneNumber,
      "id": this.userID,
      'active': this.active,
      'lastOnlineTimestamp': this.lastOnlineTimestamp,
      "profilePictureURL": this.profilePictureURL,
      'appIdentifier': this.appIdentifier,
      "userType": this.userType,
      "workPlace": this.workPlace,
      "speciality": this.speciality,
      "aboutYourself": this.aboutYourself,
      "doctorID": this.doctorID,
    };
  }
}



