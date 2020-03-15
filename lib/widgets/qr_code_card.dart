import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeCard extends StatelessWidget {
  QRCodeCard({this.data});
  String data;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
          child: QrImage(
            data: this.data,
            version: QrVersions.auto,
            size: 200.0,
            foregroundColor: Theme.of(context).accentColor
          ),
        );
  }
  
}