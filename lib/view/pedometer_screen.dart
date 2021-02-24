import 'dart:async';

import 'package:HealthGuard/helper/shared_preferences_services.dart';
import 'package:HealthGuard/helper/time_helper.dart';
import 'package:HealthGuard/model/pedometer_model.dart';
import 'package:HealthGuard/net/PedometerService.dart';
import 'package:HealthGuard/view/pedometer_history_screen.dart';
import 'package:HealthGuard/widgets/navigating_card.dart';
import 'package:HealthGuard/widgets/round_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pedometer/pedometer.dart';
import 'package:HealthGuard/constants.dart' as Constants;
import 'package:HealthGuard/helper/math_helper.dart';

/// pedometer screen page widget class
class PedometerScreen extends StatefulWidget {
  /// screen ID for navigator routing
  static const String id = "PedometerScreen";
  static const String documentID = "staticData";

  @override
  _PedometerScreenState createState() => _PedometerScreenState();
}

/// pedometer screen page state class
class _PedometerScreenState extends State<PedometerScreen> {
  /// variables
  int _steps = 0;
  double _calories = 0; // cal
  int _water = 0; // ml
  int _goal = 10000;
  Stream<StepCount> _stepCountStream;
  final String previousStepKey = "preStep"; // shared preferences keys
  final String previousDayNoKey = "preDayNo";
  PedometerService pedometerService = PedometerService();

  /// step count stream error
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 0;
    });
  }

  /// additional init for pedometer
  Future<void> initPlatformState() async {
    /// check previous goal settings
    PedometerData initialData = await pedometerService.receiveFromServer(PedometerScreen.documentID);
    print(initialData.toJson());
    if(initialData.steps != -1){
      setState(() {
        _goal = initialData.goal;
      });
    }
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    if (!mounted) return;
  }

  /// override init
  @override
  initState(){
    super.initState();
    initPlatformState();
  }

  /// step count event handler
  void onStepCount(StepCount event) async {
    /// variable
    int todayDayNo = Jiffy(event.timeStamp).dayOfYear;
    SharedPrefService sharedPrefService = SharedPrefService();
    int preSteps = await sharedPrefService.read(previousStepKey) ?? 0;
    int previousDayNo =
        await sharedPrefService.read(previousDayNoKey) ?? todayDayNo;

    /// if reboot then
    if (event.steps < preSteps) {
      preSteps = 0;
      sharedPrefService.saveInt(previousStepKey, preSteps);
    }

    /// if new day
    if (previousDayNo != todayDayNo) {
      PedometerData sentData = PedometerData(
          goal: _goal,
          water: _water,
          calories: _calories,
          steps: event.steps - preSteps,
          date: Timestamp.fromDate(TimeHelper.getYesterdayDate()));
      await pedometerService.sendToServer(sentData);
      preSteps = event.steps;
      previousDayNo = todayDayNo;
    }

    /// save all
    sharedPrefService.saveInt(previousStepKey, preSteps);
    sharedPrefService.saveInt(previousDayNoKey, previousDayNo);

    if (mounted) {
      setState(() {
        _steps = event.steps - preSteps;
        _calories = _steps.toDouble() * 0.04;
        _water = (_steps.toDouble() * 0.1282).toInt();
      });
    } else {
      _steps = event.steps - preSteps;
      _calories = _steps.toDouble() * 0.04;
      _water = (_steps.toDouble() * 0.1282).toInt();
    }

    PedometerData currentData = PedometerData(
        goal: _goal,
        steps: _steps,
        water: _water,
        calories: _calories,
        date: Timestamp.now());
    await pedometerService.sendToServer(
        currentData, PedometerScreen.documentID);
  }

  // /// send data to database
  // _sendToServer(PedometerData data, [String docID]) async {
  //
  //   /// variable
  //   // PedometerData oldPedometerData;
  //   // String oldDataId;
  //
  //   /// database reference
  //   var pedometerRef = db
  //       .collection(Constants.USERS)
  //       .doc(MyAppState.currentUser.userID)
  //       .collection(Constants.PEDOMETER_INFO);
  //
  //   // /// construct updated data
  //   // PedometerData pedometerData = PedometerData(
  //   //     goal: goal,
  //   //     steps: steps,
  //   //     water: water,
  //   //     calories: calories,
  //   //     date: Timestamp.fromDate(TimeHelper.getYesterdayDate())
  //   // );
  //
  //   if (docID == null){
  //     await pedometerRef.add(data.toJson());
  //   } else {
  //     await pedometerRef.doc(docID).set(data.toJson());
  //   }
  //
  //   // await pedometerRef
  //   //     .orderBy("date",descending: true)
  //   //     .limit(1)
  //       // timestamp query not working
  //       // .where("lastUpdate", isGreaterThanOrEqualTo: Timestamp.fromDate(TimeHelper.getLastMidnightDate()))
  //       // .where("lastUpdate", isLessThan: Timestamp.fromDate(TimeHelper.getNextMidnightDate()))
  //   //     .get()
  //   //     .then((value){
  //   //       if(value.docs.isNotEmpty){
  //   //
  //   //         /// get data
  //   //         oldDataId = value.docs.single.id;
  //   //         oldPedometerData = PedometerData.fromJson(value.docs.single.data());
  //   //
  //   //         /// display incoming data
  //   //         print("Existing pedometer document found, id : $oldDataId");
  //   //         print(oldPedometerData.toJson());
  //   //
  //   //         DateTime oldDate = oldPedometerData.date.toDate();
  //   //         Duration dateDiff = newTimestamp.toDate().difference(oldDate);
  //   //
  //   //         print("old date");
  //   //         print(oldDate);
  //   //         print("new date");
  //   //         print(newTimestamp.toDate());
  //   //         print("diff date");
  //   //         print(dateDiff);
  //   //
  //   //         if(dateDiff.inDays >= 1){
  //   //           oldDataId = null;
  //   //           print("old data id set to null : $oldDataId");
  //   //         }
  //   //
  //   //       } else {
  //   //         print("No existing pedometer document found");
  //   //       }
  //   //       print("new data : ${pedometerData.toJson()}");
  //   // }).catchError((e)=> print("error fetching old pedometer data : $e"));
  //
  //   // await pedometerRef
  //   //     .orderBy("lastUpdate", descending: true)
  //   //     .get()
  //   //     .then((value){
  //   //       if(value.docs.isNotEmpty){
  //   //         oldDataId = value.docs.first.id;
  //   //         print("${oldDataId} is the id of documents");
  //   //         oldPedometerData = PedometerData.fromJson(value.docs.first.data());
  //   //         print(oldPedometerData.toJson());
  //   //       }
  //   // });
  //
  //   // if (oldDataId != null){
  //   //   await pedometerRef.doc(oldDataId).update(pedometerData.toJson());
  //   // } else {
  //   //   await pedometerRef.add(pedometerData.toJson());
  //   // }
  //
  // }

  Widget _PopUpDialog(BuildContext context){
    return AlertDialog(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      title: Text(
        'Set Goal',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Constants.TEXT_DARK,
            fontFamily: Constants.FONTSTYLE,
            fontWeight: FontWeight.w900),
      ),
      content: Container(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: double.infinity),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: TextFormField(
              onChanged: (String val) {
                setState(() {
                  _goal = int.parse(val);
                });
              },
              textCapitalization: TextCapitalization.words,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              obscureText: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Steps Number",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// GUI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.BACKGROUND_COLOUR,
      appBar: AppBar(
        title: Text(
          'Pedometer',
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
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text(_steps?.toString() ?? '0'),
            Card(
              elevation: 2,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RoundProgressBar(
                      value: (_calories < 2000) ? _calories : 2000,
                      max: 2000,
                      size: 100,
                      color: Colors.orangeAccent,
                      innerWidget: (value) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_fire_department),
                            Text("${MathHelper.toPrecision(_calories, 2)} cal"),
                          ],
                        );
                      }),
                  RoundProgressBar(
                      value: (_water < 3000) ? _water.toDouble() : 3000,
                      max: 3000,
                      size: 100,
                      color: Colors.blue[300],
                      innerWidget: (value) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.opacity),
                            Text(_water.toString() + " ml"),
                          ],
                        );
                      }),
                ],
              ),
            ),
            RoundProgressBar(
                value: ((_steps ?? 0) < _goal)
                    ? _steps?.toDouble()
                    : _goal.toDouble(),
                max: _goal.toDouble(),
                size: 300,
                color: Colors.lightGreenAccent,
                innerWidget: (double value) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_run,
                        size: 80,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("$_steps / $_goal steps"),
                      Text(
                          "${MathHelper.toPrecision(value / _goal.toDouble() * 100, 2)} %"),
                    ],
                  );
                }),
            Row(
              children: [
                Expanded(
                  child: NavigatingCard(
                    imageName: "assets/Pedometer.png",
                    text: "Goal",
                    screenID: PedometerHistoryScreen.id,
                  ),
                  // child: ,
                ),
                Expanded(
                  child: NavigatingCard(
                    imageName: "assets/Pedometer.png",
                    text: "History",
                    screenID: PedometerHistoryScreen.id,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
