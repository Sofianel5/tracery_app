import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/localizations.dart';
import 'package:tracery_app/models/vp_handshake_model.dart';
import 'package:intl/intl.dart';
import 'package:tracery_app/widgets/risk_graph.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<VenuePeerHandshake> handshakes;
  _fetchHandShakes(UserRepository user) async {
    List<VenuePeerHandshake> result = await user.getPVHandshakes();
    if(mounted) {
      setState(() {
        handshakes = result;
      });
    }
  }

  Widget _buildList(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    if (handshakes == null) {
      _fetchHandShakes(userRepo);
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: handshakes == null ? 0 : handshakes.length,
      itemBuilder: (BuildContext context, int index) {
        VenuePeerHandshake handshake = handshakes[index];
        final formatter = new DateFormat('hh:mm aaa EEEE, LLLL d, y');
        return Container(
          margin: EdgeInsets.all(10.0),
          width: 400.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RiskGraph(size: Size(70,70), riskValue: handshake.venue.securityValue,),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(handshake.venue.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Text(formatter.format(handshake.time))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 70,),
        Text(TraceryLocalizations.of(context).get("history-title") ?? "History", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25)),
        Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 20), child: _buildList(context),),
      ],
    );
  }
}
