import 'package:flutter/material.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:tracery_app/screens/sign_up_address_screen.dart';

class SignUpDobScreen extends StatefulWidget {
  SignUpDobScreen({this.userRepo, this.json});
  Map<String, dynamic> json;
  UserRepository userRepo;
  @override
  _SignUpDobScreenState createState() => _SignUpDobScreenState();
}

class _SignUpDobScreenState extends State<SignUpDobScreen> {
  DateTime dob;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final submitFormatter = new DateFormat('y-M-d');
  final formatter = new DateFormat('LLLL d, y');

  @override
  void initState() {
    super.initState();
  }

  Widget _buildDobField() {
    return DateTimeField(
      textAlign: TextAlign.center,
      key: UniqueKey(),
      initialValue: DateTime.now().subtract(Duration(days: 2000)),
      onChanged: (DateTime newVal) {},
      format: formatter,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now().subtract(Duration(days: 36000)),
            initialDate:
                currentValue ?? DateTime.now().subtract(Duration(days: 2000)),
            lastDate: DateTime(2020));
        if (date != null) {
          dob = date;
          return date;
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () async {
          if (_formKey.currentState.validate()) {
            Map<String, dynamic> jsonData = widget.json;
            jsonData["dob"] = submitFormatter.format(dob);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpAddressScreen(userRepo: widget.userRepo, json: jsonData)));
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
        child: Text(TraceryLocalizations.of(context).get("back")),
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
                    Text(
                      TraceryLocalizations.of(context).get("dob") ?? "Date of birth",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _buildDobField(),
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
