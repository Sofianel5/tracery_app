import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:tracery_app/models/thread_from_person_model.dart';
import 'package:tracery_app/models/thread_from_venue_model.dart';
import 'package:tracery_app/widgets/risk_graph.dart';

class QRScreenVenue extends StatefulWidget {
  QRScreenVenue({this.userRepo});
  UserRepository userRepo;
  @override
  State<StatefulWidget> createState() => QRScreenVenueState(userRepo: userRepo);
}

class QRScreenVenueState extends State<QRScreenVenue> {
  QRScreenVenueState({this.userRepo});
  UserRepository userRepo;
  bool firstLoad = true;
  bool isLocked = true;
  bool shouldContinue = true;
  bool loading = false;
  ThreadFromPerson thread;
  bool scanSuccessful = false;
  @override
  void dispose() {
    shouldContinue = false;
    super.dispose();
  }

  Widget _buildUnlockButton(UserRepository userRepo) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: Stack(
        children: [
          RaisedButton(
            onPressed: () async {
              setState(() {
                isLocked = false;
              });
              print("unlocking after pressing unlock button");
              int counter = 0;
              loading = true;
              while (shouldContinue &&
                  !((await userRepo.checkForPersonScan())["success"])) {
                if (isLocked) {
                  print("user locked. exiting loop.");
                  loading = false;
                  return;
                }
                counter++;
                print(counter);
                if (counter == 600) {
                  loading = false;
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(TraceryLocalizations.of(context)
                          .get("load-scan-fail"))));
                  isLocked = true;
                  print("locking after too many failures");
                  counter = 0;
                  return;
                }
              }
              ThreadFromPerson _threadRes = userRepo.currentThreadFromPerson;
              if (!isLocked) {
                isLocked = !isLocked;
              }
              if (shouldContinue) {
                setState(() {
                  thread = _threadRes;
                  loading = false;
                });
              }
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
        onPressed: () => setState(() {
          isLocked = true;
        }),
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
          if (await userRepo.confirmThreadAsVenue(thread.threadId, false)) {
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
            child: Text(TraceryLocalizations.of(context).get("no-scans") ??
                "No pending scans"),
          )
        : Column(
            children: <Widget>[
              Text(
                TraceryLocalizations.of(context).get("assessable-risk") ??
                    "Assessable risk",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              RiskGraph(
                  size: Size(200, 200), riskValue: thread.from.securityValue),
              _buildConfirmButton(
                  userRepo, getColorForValue(thread.from.securityValue))
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad) {
      if (!isLocked) {
        print("locking user when entering page.");
        setState(() {
          isLocked = !isLocked;
        });
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
                          TraceryLocalizations.of(context).get("me-title") ??
                              "Me",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w700),
                        ),
                      ),
                      userRepo.venue == null
                          ? CircularProgressIndicator()
                          : Stack(
                              children: [
                                Center(
                                  child: QrImage(
                                    data: userRepo.venue.publicId,
                                    version: QrVersions.auto,
                                    foregroundColor: Colors.black,
                                    size: 200.0,
                                  ),
                                ),
                                !isLocked
                                    ? Container()
                                    : Center(
                                        child: ClipRect(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 6.0, sigmaY: 6.0),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0),
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
                    isLocked
                        ? _buildUnlockButton(userRepo)
                        : _buildLockButton(userRepo),
                    isLocked
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
