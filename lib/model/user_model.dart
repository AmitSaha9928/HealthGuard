import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:HealthGuard/helper/string_helper.dart';

/// Acting as a frame for the creation of user instances
class User {

  ///variables
  String email = '';
  String firstName = '';
  String lastName = '';
  Settings settings = Settings(allowPushNotifications: true);
  String phoneNumber = '';
  bool active = false;
  Timestamp lastOnlineTimestamp = Timestamp.now();
  String userID;
  String profilePictureURL = '';
  bool selected = false;
  String appIdentifier = 'HealthGuard ${Platform.operatingSystem}';
  String userType = '';
  String sex = '';
  String birthday = '';
  String chattingWith = '';

  String workPlace = '';
  String speciality = '';
  String aboutYourself = "";
  String doctorID = "";

  /// User class Constructor
  User(
      {this.email,
        this.firstName,
        this.phoneNumber,
        this.lastName,
        this.active,
        this.lastOnlineTimestamp,
        this.settings,
        this.userID,
        this.profilePictureURL,
        this.userType,
        this.sex,
        this.birthday,
        this.chattingWith,
        this.workPlace,
        this.speciality,
        this.aboutYourself,
        this.doctorID,}
      );

  /// helper function combining user's first name and last name to form full name
  String fullName() {
    return firstName.capitalize() + " " + lastName.capitalize();
  }

  /// Passing user input data, then creating a new user containing these data
  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
      email: parsedJson['email'] ?? "",
      firstName: parsedJson['firstName'] ?? '',
      lastName: parsedJson['lastName'] ?? '',
      active: parsedJson['active'] ?? false,
      lastOnlineTimestamp: parsedJson['lastOnlineTimestamp'],
      settings: Settings.fromJson(
          parsedJson['settings'] ?? {'allowPushNotifications': true}),
      phoneNumber: parsedJson['phoneNumber'] ?? "",
      userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
      profilePictureURL: parsedJson['profilePictureURL'] ?? "",
      userType: parsedJson['userType'] ?? "",
      sex: parsedJson['sex'] ?? "",
      birthday: parsedJson['birthday'] ?? "",
      chattingWith: parsedJson['chattingWith'] ?? "",
      workPlace: parsedJson['workPlace'] ?? "",
      speciality: parsedJson['speciality'] ?? "",
      aboutYourself: parsedJson['aboutYourself'] ?? "",
      doctorID: parsedJson['doctorID'] ?? "",
    );
  }

  /// Convert to json
  Map<String, dynamic> toJson() {
    return {
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
      'userType': this.userType,
      'sex': this.sex,
      'birthday': this.birthday,
      'chattingWith': this.chattingWith,
      "workPlace": this.workPlace,
      "speciality": this.speciality,
      "aboutYourself": this.aboutYourself,
      "doctorID": this.doctorID,
    };
  }

  /// helper function combining user's first name and last name to form full name
  String fullNameDr() {
    return 'Dr. '+ fullName();
  }
}

class Settings {
  bool allowPushNotifications = true;
  Settings({this.allowPushNotifications});

  factory Settings.fromJson(Map<dynamic, dynamic> parsedJson) {
    return new Settings(
        allowPushNotifications: parsedJson['allowPushNotifications'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {'allowPushNotifications': this.allowPushNotifications};
  }
}



