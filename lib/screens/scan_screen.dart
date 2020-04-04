import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/models/thread_from_person_model.dart';
import 'package:tracery_app/models/thread_from_venue_model.dart';
import 'package:tracery_app/widgets/risk_graph.dart';

class ScanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScanScreenState();
}

class ScanScreenState extends State<ScanScreen> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  UserRepository userRepo;
  bool isWaiting = false;
  bool isOpen = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      if (!isWaiting && !isOpen) {
        _showDiologue();
      }
    });
  }

  void _showDiologue() async {
    String title;
    double value;
    if (isOpen || isWaiting) {
      return;
    }
    isOpen = true;
    try {
      if (userRepo.user.isVenueAdmin) {
        isWaiting = true;
        ThreadFromVenue res = await userRepo.scanPerson(qrText);
        if (res == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                    TraceryLocalizations.of(context).get("error") ?? "Error"),
                content: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(TraceryLocalizations.of(context).get("try-again") ??
                          "Try again"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      "Dismiss",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () {
                      isOpen = false;
                      isWaiting = false;
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
        value = res.to.securityValue;
        isWaiting = false;
        title = "Anonymous user";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    RiskGraph(
                      size: Size(200, 200),
                      riskValue: value,
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    isOpen = false;
                    isWaiting = false;
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                new FlatButton(
                  child: new Text(
                    "Confirm",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    isOpen = false;
                    isWaiting = false;
                    Navigator.of(context, rootNavigator: true).pop();
                    userRepo.confirmThreadAsVenue(res.threadId, true);
                  },
                ),
              ],
            );
          },
        );
      } else {
        isWaiting = true;
        ThreadFromPerson res = await userRepo.scanVenue(qrText);
        if (res == null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                    TraceryLocalizations.of(context).get("error") ?? "Error"),
                content: Container(
                  height: 100,
                  child: Column(
                    children: <Widget>[
                      Text(TraceryLocalizations.of(context).get("try-again") ??
                          "Try again"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                    onPressed: () {
                      isWaiting = false;
                      isOpen = false;
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }
        isWaiting = false;
        value = res.to.securityValue;
        title = res.to.title;
        isOpen = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Container(
                height: 300,
                child: Column(
                  children: <Widget>[
                    RiskGraph(
                      size: Size(200, 200),
                      riskValue: value,
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    isOpen = false;
                    isWaiting = false;
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
                new FlatButton(
                  child: new Text(
                    "Confirm",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    isOpen = false;
                    isWaiting = false;
                    Navigator.of(context, rootNavigator: true).pop();
                    userRepo.confirmThreadAsUser(res.threadId, true);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text(TraceryLocalizations.of(context).get("error") ?? "Error"),
            content: Container(
              height: 100,
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Dismiss",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  isOpen = false;
                  isWaiting = false;
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userRepo == null) {
      userRepo = Provider.of<UserRepository>(context);
    }
    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
      ],
    );
  }
}
