/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:p7_async/weather.dart';

class TempBar extends StatelessWidget {
  final List<charts.Series<TempretureModel, String>> seriesList;
  final bool animate;

  const TempBar(this.seriesList, {super.key, required this.animate});

  factory TempBar.withSampleData() {
    return TempBar(
      _createSampleData(),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec:
            charts.BasicNumericTickProviderSpec(desiredTickCount: 5),
      ),
    );
  }

  static List<charts.Series<TempretureModel, String>> _createSampleData() {
    final data = [
      TempretureModel("City", Weather.getTemp),
    ];

    return [
      charts.Series<TempretureModel, String>(
        id: 'Tempretures',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TempretureModel sales, _) => sales.city,
        measureFn: (TempretureModel sales, _) => sales.tempreture,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class TempretureModel {
  final String city;
  final double tempreture;

  TempretureModel(this.city, this.tempreture);
}
