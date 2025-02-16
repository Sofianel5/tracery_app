import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:tracery_app/models/thread_from_venue_model.dart';
import 'package:tracery_app/widgets/risk_graph.dart';

class QRScreen extends StatefulWidget {
  QRScreen({this.userRepo});
  UserRepository userRepo;
  @override
  State<StatefulWidget> createState() => QRScreenState(userRepo: userRepo);
}

class QRScreenState extends State<QRScreen> {
  QRScreenState({this.userRepo});
  UserRepository userRepo;
  bool firstLoad = true;
  bool loading = false;
  ThreadFromVenue thread;
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
              while (!((await userRepo.checkForScan())["success"])) {
                if (userRepo.user.anonUser.isLocked) {
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
              ThreadFromVenue _threadRes =
                  (await userRepo.checkForScan())['Thread'];
              if (!userRepo.user.anonUser.isLocked) {
                userRepo.toggleLockState();
              }
              setState(() {
                thread = _threadRes;
                loading = false;
              });
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


  Widget _buildConfirmButton(UserRepository userRepo, Color backgroundColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        onPressed: () async {
          if (await userRepo.confirmThreadAsUser(thread.threadId, false)) {
            setState(() {
              thread = null;
            });
          }
        },
        elevation: 10,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              color: Colors.black,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              TraceryLocalizations.of(context).get("confirm-entry"),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorForValue(double value) {
    print(value);
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

  Widget _buildLockedInfo(UserRepository userRepo) {
    return thread == null
        ? Center(
            child: Text(TraceryLocalizations.of(context).get("no-scans") ?? "No pending scans"),
          )
        : Column(
            children: <Widget>[
              Text(
                TraceryLocalizations.of(context).get("assessable-risk") ?? "Assessable risk",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              RiskGraph(size: Size(200,200), riskValue: thread.from.securityValue),
              _buildConfirmButton(
                  userRepo, getColorForValue(thread.from.securityValue))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad) {
      if (!userRepo.user.anonUser.isLocked) {
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
                          TraceryLocalizations.of(context).get("me-title") ?? "Me",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Stack(
                        children: [
                          Center(
                            child: QrImage(
                              data: userRepo.user.anonUser.puid,
                              version: QrVersions.auto,
                              foregroundColor: Colors.black,
                              size: 200.0,
                            ),
                          ),
                          !userRepo.user.anonUser.isLocked
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
                    userRepo.user.anonUser.isLocked
                        ? _buildUnlockButton(userRepo)
                        : _buildLockButton(userRepo),
                    userRepo.user.anonUser.isLocked
                        ? _buildLockedInfo(userRepo)
                        : _buildUnlockedContents(userRepo),
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
