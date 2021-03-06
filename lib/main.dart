

import 'package:HealthGuard/view/add_medication_screen.dart';
import 'package:HealthGuard/view/chat_list_screen.dart';
import 'package:HealthGuard/view/doctor_detail_screen.dart';
import 'package:HealthGuard/view/doctor_sign_in_screen.dart';
import 'package:HealthGuard/view/doctor_sign_up_screen.dart';
import 'package:HealthGuard/view/find_doctor_screen.dart';
import 'package:HealthGuard/view/help_center_screen.dart';
import 'package:HealthGuard/view/hospital_suggestions_screen.dart';
import 'package:HealthGuard/view/medical_feed_screen.dart';
import 'package:HealthGuard/view/medication_reminder_screen.dart';
import 'package:HealthGuard/view/my_account_screen.dart';
import 'package:HealthGuard/view/user_profile_screen.dart';
import 'package:HealthGuard/view/forgot_password_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:HealthGuard/model/user_model.dart' as OurUser;
import 'package:HealthGuard/net/authentication.dart';
import 'package:HealthGuard/home.dart';
import 'package:HealthGuard/view/patient_sign_in_screen.dart';
import 'package:HealthGuard/view/e-medical_report_screen.dart';
import 'package:HealthGuard/view/pedometer_screen.dart';
import 'package:HealthGuard/view/blood_pressure_history_screen.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static OurUser.User currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        home.id: (context) => home(),
        UserProfile.id: (context) => UserProfile(),
        MyAccount.id: (context) => MyAccount(),
        HelpCenter.id: (context) => HelpCenter(),
        PedometerScreen.id: (context) => PedometerScreen(),
        MedicalFeed.id: (context) => MedicalFeed(),
        EMedicalReport.id: (context) => EMedicalReport(),
        MedicationForm.id: (context) => MedicationForm(),
        MedicationReminder.id: (context) => MedicationReminder(),
        ForgotPassword.id: (context) => ForgotPassword(),
        FindDoctor.id: (context) => FindDoctor(),
        DoctorDetail.id: (context) => DoctorDetail(),
        DoctorSignIn.id: (context) => DoctorSignIn(),
        DoctorSignUp.id: (context) => DoctorSignUp(),
        ChatList.id: (context) => ChatList(),
        HospitalSuggestions.id: (context) => HospitalSuggestions(),
        BloodPressureHistory.id: (context) => BloodPressureHistory(),
      },
      theme: ThemeData(accentColor: Colors.white),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (FirebaseAuth.instance.currentUser != null && currentUser != null) {
      if (state == AppLifecycleState.paused) {
        //user offline
        currentUser.active = false;
        currentUser.lastOnlineTimestamp = Timestamp.now();
        FireStoreUtils.currentUserDocRef.update(currentUser.toJson());
      } else if (state == AppLifecycleState.resumed) {
        //user online
        currentUser.active = true;
        FireStoreUtils.currentUserDocRef.update(currentUser.toJson());
      }
    }
  }
}

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.red,
    body: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ),
    ),
  );
}
