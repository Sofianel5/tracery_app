import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/widgets/risk_graph.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  void _showLogoutDialog(UserRepository user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Are you sure you want to sign out?"),
          content: new Text("You must be logged back in"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                user.signOut();
              },
            ),
          ],
        );
      },
    );
  }

  _buildLogoutWidget(UserRepository user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _showLogoutDialog(user),
          child: Text(
            "Log out",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 700,
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
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 120,
                        ),
                        Text(
                          TraceryLocalizations.of(context)
                                  .get("your-account") ??
                              "Your account",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                          ),
                        ),
                        userRepo.user.isPrivate
                            ? Container()
                            : Text(
                                userRepo.user.firstName +
                                    " " +
                                    userRepo.user.lastName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 24),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                        _buildLogoutWidget(userRepo),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(children: [
                  Center(
                    child: Container(
                      width: 210,
                      height: 210,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(105),
                          color: Color(0xFFF3F5F7)),
                    ),
                  ),
                  RiskGraph(
                      size: Size(200, 200),
                      riskValue: userRepo.user.anonUser.securityValue)
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
