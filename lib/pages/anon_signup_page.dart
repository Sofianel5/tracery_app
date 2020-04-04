import 'package:flutter/material.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/pages/login_page.dart';

class DefaultAuthPage extends StatefulWidget {
  @override
  _DefaultAuthPageState createState() => _DefaultAuthPageState();
}

class _DefaultAuthPageState extends State<DefaultAuthPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildAnonSignupButton(UserRepository user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () async {
          user.openAnonymousAccount();
        },
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
              color: Colors.black12, borderRadius: BorderRadius.circular(15)),
          width: 200,
          height: 70,
          child: Center(
            child: user.status == Status.Authenticating
                ? CircularProgressIndicator()
                : Text(
                    TraceryLocalizations.of(context).get("anon-signup"),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildVenueAuthBtn(UserRepository userRepo) {
    return FlatButton(
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => LoginPage(userRepo: userRepo,))),
      child: Text(
        TraceryLocalizations.of(context).get("venue-login") ??
            "Authenticate as venue",
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.black, fontSize: 17),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
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
                            TraceryLocalizations.of(context).get("welcome") ??
                                "Welcome to Tracery",
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
                        ],
                      ),
                    ),
                    _buildAnonSignupButton(user),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      TraceryLocalizations.of(context).get("or") ?? "or",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _buildVenueAuthBtn(user),
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
