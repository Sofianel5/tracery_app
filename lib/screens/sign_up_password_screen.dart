import 'package:flutter/material.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/screens/sign_up_dob_screen.dart';

class SignUpPasswordScreen extends StatefulWidget {
  SignUpPasswordScreen({this.userRepo, this.json});
  Map<String, dynamic> json;
  UserRepository userRepo;
  @override
  _SignUpPasswordScreenState createState() => _SignUpPasswordScreenState();
}

class _SignUpPasswordScreenState extends State<SignUpPasswordScreen> {
  TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  FocusNode emailNode = FocusNode();
  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _password = TextEditingController(text: "");
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () async {
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> jsonData = widget.json;
            jsonData["password"] = _password.text;
            if (_formKey.currentState.validate()) {
              Map res = await widget.userRepo.signUp(jsonData: jsonData);
              if (!res["validity"]) {
                _key.currentState
                    .showSnackBar(SnackBar(content: Text(res["message"])));
              } else {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            }
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
              child: widget.userRepo.status == Status.Authenticating
                  ? CircularProgressIndicator()
                  : Text(
                      TraceryLocalizations.of(context).get("submit"),
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

  Widget _buildPasswordField() {
    return TextFormField(
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
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(
          focusColor: Theme.of(context).accentColor,
          hintText: TraceryLocalizations.of(context).get("password"),
          prefixIcon: Icon(Icons.lock_outline)),
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
                    _buildPasswordField(),
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
