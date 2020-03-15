import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';

class QRScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QRScreenState();
}

class QRScreenState extends State<QRScreen> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50),
        Text(TraceryLocalizations.of(context).get("me-title")),
        SizedBox(height: 50),
        Image(image: NetworkImage(user.user.qrImgUrl), height: 100, width: 100,)
      ],
    );
  }
}
