import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class hourQty {
  hourQty({required this.hour, required this.qty});

  final String hour;
  final int qty;
}

class StatusHourBarChart extends StatelessWidget {
  StatusHourBarChart({required this.data});

  List<dynamic> data;

  @override
  Widget build(BuildContext context) {
    List<hourQty> desktopDalsesData = [];

    data.forEach((val) {
      desktopDalsesData
          .add(hourQty(hour: val['hour'].toString() + '時', qty: val['count']));
    });

    List<charts.Series<dynamic, String>> seriesList = [
      charts.Series<hourQty, String>(
          id: 'Sales',
          domainFn: (hourQty hourqty, _) => hourqty.hour,
          measureFn: (hourQty hourqty, _) => hourqty.qty,
          data: desktopDalsesData,
          labelAccessorFn: (hourQty hourqty, _) =>
              '\$${hourqty.qty.toString()}',
          colorFn: (_, __) =>
              charts.ColorUtil.fromDartColor(Colors.red.shade500))
    ];

    return SizedBox(
      height: 220,
      child: charts.BarChart(seriesList, animate: true, vertical: true),
    );
  }
}
