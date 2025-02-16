import 'package:flutter/material.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/urls.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/screens/sign_up_name_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.userRepo});
  UserRepository userRepo;
  @override
  _LoginPageState createState() => _LoginPageState(userRepo: userRepo);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({this.userRepo});
  UserRepository userRepo;
  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  TextEditingController _password = TextEditingController();
  String focusedNode = "email";
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  Widget _buildEmailField() {
    return TextField(
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _email,
      onEditingComplete: () {
        print("editing complete");
        FocusScope.of(context).requestFocus(passwordNode);
      },
      onSubmitted: (value) {
        print("submitted");
        if (value != null && value != "") {
          FocusScope.of(context).requestFocus(passwordNode);
        }
      },
      focusNode: emailNode,
      decoration: InputDecoration(
          focusColor: Colors.black,
          hintText: TraceryLocalizations.of(context).get("email"),
          prefixIcon: Icon(Icons.email)),
      textInputAction: TextInputAction.continueAction,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      style: TextStyle(color: Colors.black38),
      cursorColor: Theme.of(context).accentColor,
      controller: _password,
      onSubmitted: (value) {},
      focusNode: passwordNode,
      obscureText: true,
      decoration: InputDecoration(
          focusColor: Theme.of(context).accentColor,
          hintText: TraceryLocalizations.of(context).get("password"),
          prefixIcon: Icon(passwordNode.hasFocus
              ? Icons.lock_open
              : Icons.lock_outline)),
    );
  }

  Widget _buildSubmitButton(UserRepository user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () async {
          print("tapped");
          if (_formKey.currentState.validate()) {
            if (!await user.signIn(
                email: _email.text, password: _password.text)) {
              _key.currentState.showSnackBar(SnackBar(
                content: Text("Something is wrong."),
              ));
            } else {
              Navigator.pop(context);
            }
          }
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15)),
            width: 200,
            height: 70,
            child: Center(
              child: user.status == Status.Authenticating ? CircularProgressIndicator() : Text(
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

  Widget _buildSignUpBtn(UserRepository userRepo) {
    return FlatButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpNameScreen(userRepo: userRepo,))),
      child: Text(
        TraceryLocalizations.of(context).get("sign-up") ?? "Sign up",
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
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

  Widget _buildForgotPasswordBtn() {
    return Container(
      child: FlatButton(
        onPressed: () =>
            _launchURL(), //Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordResetScreen(user))),
        child: Text(TraceryLocalizations.of(context).get("forgot-password") ?? "Forgot password?"),
      ),
    );
  }

  _launchURL() async {
    var url = Urls.PASSWORD_RESET_URL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                            TraceryLocalizations.of(context).get("welcome") ?? "Welcome to Tracery",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            TraceryLocalizations.of(context).get("sign-in") ?? "Sign in",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    _buildEmailField(),
                    SizedBox(
                      height: 30,
                    ),
                    _buildPasswordField(),
                    SizedBox(
                      height: 50,
                    ),
                    _buildSubmitButton(userRepo),
                    SizedBox(
                      height: 50,
                    ),
                    _buildSignUpBtn(userRepo),
                    SizedBox(
                      height: 20,
                    ),
                    _buildForgotPasswordBtn(),
                    SizedBox(
                      height: 30,
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
