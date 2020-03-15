import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class QRScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QRScreenState();
}

class QRScreenState extends State<QRScreen> {
  bool firstLoad = true;
  bool loading = false;
  bool scanSuccessful = false;
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  Widget _buildUnlockButton(UserRepository userRepo) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Stack(
        children: [
          RaisedButton(
            onPressed: () async {
              await userRepo.toggleLockState();
              print("unlocking after pressing unlock button");
              int counter = 0;
              loading = true;
              while (!await userRepo.checkForScan()) {
                if (userRepo.user.isLocked) {
                  print("user locked. exiting loop.");
                  loading = false;
                  return;
                }
                // Waiting
                counter++;
                print(counter);
                if (counter == 600) {
                  loading = false;
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(TraceryLocalizations.of(context)
                          .get("load-scan-fail"))));
                  userRepo.toggleLockState();
                  print("locking after too many failures");
                  counter = 0;
                  return;
                }
              }
              loading = false;
            },
            elevation: 10,
            padding: EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Theme.of(context).accentColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.lock, color: Colors.white),
                SizedBox(
                  width: 20,
                ),
                Text(
                  TraceryLocalizations.of(context).get("unlock-btn"),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLockButton(UserRepository userRepo) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () => userRepo.toggleLockState(),
        elevation: 10,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Theme.of(context).accentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lock_open,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              TraceryLocalizations.of(context).get("lock-btn"),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedContents(UserRepository userRepo) {
    return loading
        ? Center(
            child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SpinKitWave(color: Theme.of(context).accentColor, size: 150),
          ))
        : Container();
  }

  Widget _buildLockedContents(UserRepository userRepo) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SpinKitWave(color: Theme.of(context).accentColor, size: 150),
      ),
    );
  }
  Color getColorForValue(double value) {
    Color dialColor;
    if (value > 90) {
      dialColor = Colors.red[900];
    } else if (value > 75) {
      dialColor = Colors.red[700];
    } else if (value > 50) {
      dialColor = Colors.red[400];
    } else if (value > 40) {
      dialColor = Colors.red[200];
    } else if (value > 30) {
      dialColor = Colors.deepOrange;
    } else if (value > 20) {
      dialColor = Colors.deepOrange[200];
    } else if (value > 10) {
      dialColor = Colors.yellow;
    } else {
      dialColor = Colors.greenAccent[700];
    }
    return dialColor;
  }
  List<CircularStackEntry> _generateChartData(double value) {
    Color dialColor = getColorForValue(value);
    List<CircularStackEntry> data = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            value,
            dialColor,
            rankKey: 'percentage',
          )
        ],
        rankKey: 'percentage',
      ),
    ];
    return data;
  }
  Widget _buildResults(double securityValue) {
    return Center(
      child: Stack(
        children: <Widget>[
          AnimatedCircularChart(
            key: _chartKey,
            initialChartData: _generateChartData(securityValue),
            chartType: CircularChartType.Radial,
            edgeStyle: SegmentEdgeStyle.round,
            percentageValues: true,
            holeLabel: 'securityValue%',
            labelStyle: TextStyle(color: getColorForValue(securityValue)),
            size: Size(200.0, 200.0),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedInfo() {
    
  }
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    if (firstLoad) {
      if (!userRepo.user.isLocked) {
        print("locking user when entering page.");
        userRepo.toggleLockState();
      }
      firstLoad = false;
    }
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          TraceryLocalizations.of(context).get("me-title"),
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Stack(
                        children: [
                          Center(
                            child: QrImage(
                              data: userRepo.user.puid,
                              version: QrVersions.auto,
                              foregroundColor: Colors.black,
                              size: 200.0,
                            ),
                          ),
                          !userRepo.user.isLocked
                              ? Container()
                              : Center(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 6.0, sigmaY: 6.0),
                                      child: Container(
                                        color: Colors.black.withOpacity(0),
                                        width: 200,
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 500,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -10),
                  ),
                ],
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
                color: Color(0xFFF3F5F7),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                child: Column(
                  children: <Widget>[
                    userRepo.user.isLocked
                        ? _buildUnlockButton(userRepo)
                        : _buildLockButton(userRepo),
                    _buildUnlockedContents(userRepo),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
