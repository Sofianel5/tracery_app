import 'package:flutter/material.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/screens/sign_up_dob_screen.dart';
import 'package:tracery_app/screens/sign_up_password_screen.dart';

class SignUpAddressScreen extends StatefulWidget {
  SignUpAddressScreen({this.userRepo, this.json});
  Map<String, dynamic> json;
  UserRepository userRepo;
  @override
  _SignUpAddressScreenState createState() => _SignUpAddressScreenState();
}

class _SignUpAddressScreenState extends State<SignUpAddressScreen> {
  TextEditingController _address = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  FocusNode emailNode = FocusNode();
  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _address = TextEditingController(text: "");
  }

  Widget _buildAddressField() {
    return TextFormField(
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _address,
      validator: (value) {
        if (value == null) {
          return TraceryLocalizations.of(context).get("invalid-info") ??
              "Invalid info";
        }
        if (value.trim() == "") {
          return TraceryLocalizations.of(context).get("invalid-info") ??
              "Invalid info";
        }
        return null;
      },
      focusNode: emailNode,
      decoration: InputDecoration(
        focusColor: Colors.black,
        hintText: TraceryLocalizations.of(context).get("address") ?? "Address",
        prefixIcon: Icon(Icons.home),
      ),
      textInputAction: TextInputAction.continueAction,
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () async {
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> jsonData = widget.json;
            jsonData["address"] = _address.text;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    SignUpPasswordScreen(userRepo: widget.userRepo, json: jsonData),
              ),
            );
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
        onPressed: () => Navigator.pop(context),
        child: Text(TraceryLocalizations.of(context).get("back")) ?? "Back",
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
                            TraceryLocalizations.of(context).get("sign-up") ??
                                "Sign up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    _buildAddressField(),
                    SizedBox(
                      height: 30,
                    ),
                    _buildNextButton(),
                    SizedBox(
                      height: 50,
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
