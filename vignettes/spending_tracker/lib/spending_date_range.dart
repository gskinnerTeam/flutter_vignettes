import 'package:flutter/material.dart';
import 'package:spending_tracker/main.dart';

import 'chart/chart.dart';
import 'components/text_transition.dart';

class SpendingDateRange extends StatelessWidget {
  static const int startYear = 2018;

  final Chart chart;

  SpendingDateRange({required this.chart});

  @override
  Widget build(context) {
    const monthNames = <String>[
      'January',
      'Febuary',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final range = chart.domainEnd - chart.domainStart;

    final start = chart.domainStart.ceil();
    final startYearOffset = start ~/ 12;
    final startMonth = monthNames[start % 12];

    final end = (chart.domainEnd - 0.1 * range).floor();
    final endYearOffset = end ~/ 12;
    final endMonth = monthNames[end % 12];

    final titleStyle = text2.copyWith(fontSize: 13);
    final dateStyle = text1.copyWith(fontSize: 14);

    return Padding(
      padding: EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('From', style: titleStyle),
              Padding(padding: EdgeInsets.all(3)),
              TextTransition(
                text: '${startYear + startYearOffset} $startMonth',
                textStyle: dateStyle,
                duration: Duration(milliseconds: 400),
                width: 120,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(15)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('To', style: titleStyle),
              Padding(padding: EdgeInsets.all(3)),
              TextTransition(
                text: '${startYear + endYearOffset} $endMonth',
                textStyle: dateStyle,
                duration: Duration(milliseconds: 400),
                width: 120,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
