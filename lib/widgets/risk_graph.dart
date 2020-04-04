import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class RiskGraph extends StatefulWidget {
  RiskGraph({this.size, this.riskValue});
  Size size;
  double riskValue;
  RiskGraphState createState() => RiskGraphState();
}

class RiskGraphState extends State<RiskGraph> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  Color getColorForValue(double value) {
    print(value);
    Color dialColor;
    if (value > 90) {
      dialColor = Colors.red[900];
    } else if (value > 75) {
      dialColor = Colors.red[700];
    } else if (value > 50) {
      dialColor = Colors.red[400];
    } else if (value > 40) {
      dialColor = Colors.red[200];
    } else if (value > 30) {
      dialColor = Colors.deepOrange;
    } else if (value > 20) {
      dialColor = Colors.deepOrange[200];
    } else if (value > 10) {
      dialColor = Colors.yellow;
    } else {
      dialColor = Colors.greenAccent[700];
    }
    return dialColor;
  }

  List<CircularStackEntry> _generateChartData(double value) {
    Color dialColor = getColorForValue(value);
    List<CircularStackEntry> data = <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            value,
            dialColor,
            rankKey: 'percentage',
          )
        ],
        rankKey: 'percentage',
      ),
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            100 - value,
            Colors.greenAccent[700],
            rankKey: 'percentage',
          )
        ],
        rankKey: 'percentage',
      ),
    ];
    return data;
  }

  Widget _buildResults(double securityValue) {
    return Center(
      child: Stack(
        children: <Widget>[
          AnimatedCircularChart(
            key: _chartKey,
            initialChartData: _generateChartData(securityValue),
            chartType: CircularChartType.Radial,
            edgeStyle: SegmentEdgeStyle.round,
            percentageValues: true,
            holeLabel: '$securityValue%',
            labelStyle:
                TextStyle(color: getColorForValue(securityValue), fontSize: widget.size.width/7),
            size: widget.size,
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return _buildResults(widget.riskValue);
  }
  
}