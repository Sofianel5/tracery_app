import 'package:flutter/material.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/urls.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/screens/sign_up_email_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpNameScreen extends StatefulWidget {
  SignUpNameScreen({this.userRepo});
  UserRepository userRepo;
  @override
  _SignUpNameScreenState createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  FocusNode firstNamelNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  String focusedNode = "email";
  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: "");
    _lastName = TextEditingController(text: "");
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      validator: (value) {
        if (value == null) {   
          return TraceryLocalizations.of(context).get("invalid-info") ?? "Invalid info";
        } if (value.trim() == "") {
          return TraceryLocalizations.of(context).get("invalid-info") ?? "Invalid info";
        } return null;
      },
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _firstName,
      onEditingComplete: () {
        print("editing complete");
        FocusScope.of(context).requestFocus(lastNameNode);
      },

      focusNode: firstNamelNode,
      decoration: InputDecoration(
        focusColor: Colors.black,
        hintText: TraceryLocalizations.of(context).get("first-name") ?? "First name",
      ),
      textInputAction: TextInputAction.continueAction,
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      validator: (value) {
        if (value == null) {   
          return TraceryLocalizations.of(context).get("invalid-info") ?? "Invalid info";
        } if (value.trim() == "") {
          return TraceryLocalizations.of(context).get("invalid-info") ?? "Invalid info";
        } return null;
      },
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _lastName,
      focusNode: lastNameNode,
      decoration: InputDecoration(
        focusColor: Colors.black,
        hintText: TraceryLocalizations.of(context).get("last-name") ?? "Last name",
      ),
      textInputAction: TextInputAction.continueAction,
    );
  }

  Widget _buildNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(width: 100, child: _buildFirstNameField(),),
        Container(width: 100, child: _buildLastNameField(),),
      ],
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () async {
          if (_formKey.currentState.validate()) {
           Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpEmailScreen(userRepo: widget.userRepo, json: {"first_name": _firstName.text, "last_name": _lastName.text})));
          }
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            width: 200,
            height: 70,
            child: Center(
              child: Text(
                      TraceryLocalizations.of(context).get("next") ?? "Next",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            )),
      ),
    );
  }

  Widget _buildBackBtn() {
    return Container(
      child: FlatButton(
        onPressed: () =>
            Navigator.pop(context), //Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordResetScreen(user))),
        child: Text(TraceryLocalizations.of(context).get("back") ?? "Back"),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Theme.of(context).bottomAppBarColor,
          ),
          Form(
            key: _formKey,
            child: Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 100,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      height: 75,
                      width: 75,
                      image: AssetImage("assets/tracery1.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 40),
                      child: Column(
                        children: <Widget>[
                          Text(
                            TraceryLocalizations.of(context).get("sign-up") ?? "Sign up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    _buildNameRow(),
                    SizedBox(
                      height: 30,
                    ),                   
                    _buildNextButton(),
                    SizedBox(
                      height: 100,
                    ),
                    _buildBackBtn(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
