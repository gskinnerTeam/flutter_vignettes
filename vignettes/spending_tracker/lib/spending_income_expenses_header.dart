import 'package:flutter/material.dart';

import 'chart/chart.dart';
import 'components/text_transition.dart';
import 'globals.dart';
import 'app_colors.dart';


class SpendingIncomeExpensesHeader extends StatelessWidget {
  final Chart chart;

  SpendingIncomeExpensesHeader({this.chart});

  @override
  Widget build(context) {
    final start = chart.domainStart.round();
    final end = chart.domainEnd.round();

    final values0 = chart.dataSets[0].values.sublist(start, end);
    final values1 = chart.dataSets[1].values.sublist(start, end);

    final sum0 = values0.fold(0, (a, b) => a + b) * 1000;
    final sum1 = values1.fold(0, (a, b) => a + b) * 1000;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SummaryColumn(
            title: 'Income',
            colors: [
              Color(0xFF4A78ED),
              Color(0xFF5DB391),
            ],
            sum: sum0.round(),
            mean: (sum0 / values0.length).round()),
        Padding(padding: EdgeInsets.all(8)),
        Container(width: 1, height: 32, color: AppColors.colorAccent1),
        Padding(padding: EdgeInsets.all(8)),
        _SummaryColumn(
            title: 'Expense',
            colors: [
              Color(0xFFA74CBA),
              Color(0xFFF287A6),
            ],
            sum: sum1.round(),
            mean: (sum1 / values1.length).round()),
      ],
    );
  }
}

class _SummaryColumn extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final int sum;
  final int mean;

  _SummaryColumn({this.title, this.colors, this.sum, this.mean});

  @override
  Widget build(context) {
    return Column(children: [
      Row(children: [
        Container(
          width: 8,
          height: 8,
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: AppColors.colorText2,
            fontFamily: 'Lato',
            fontWeight: FontWeight.w200,
            fontSize: 11,
          ),
        ),
      ]),
      Padding(padding: EdgeInsets.all(2)),
      TextTransition(
        text: '\$${numberToPriceString(sum)}',
        textStyle: TextStyle(
          color: AppColors.colorText1,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w200,
          fontSize: 19,
          letterSpacing: 0.7,
        ),
        duration: Duration(milliseconds: 400),
      ),
      Padding(padding: EdgeInsets.all(4)),
      Text(
        'Monthly Average: \$${numberToPriceString(mean)}',
        style: TextStyle(
          color: AppColors.colorText1,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w200,
          fontSize: 8,
        ),
      ),
    ]);
  }
}
