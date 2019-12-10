import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'chart/chart.dart';
import 'components/scaling_info.dart';
import 'app_colors.dart';
import 'components/circle_percentage_widget.dart';

class SpendingCategoryList extends StatefulWidget {
  final Listenable updateNotifier;

  SpendingCategoryList({this.updateNotifier});

  @override
  State createState() => _SpendingCategoryListState();
}

class _SpendingCategoryListState extends State<SpendingCategoryList> {
  int _currentStart = 0;

  @override
  void initState() {
    widget.updateNotifier?.addListener(() {
      if (widget.updateNotifier is Chart) {
        if ((widget.updateNotifier as Chart).domainStart.round() != _currentStart) {
          setState(() {
            _currentStart = (widget.updateNotifier as Chart).domainStart.round();
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(context) {
    final rng = math.Random();

    double percent0 = rng.nextDouble();
    double percent1 = rng.nextDouble();
    double percent2 = rng.nextDouble();
    double sum = percent0 + percent1 + percent2;
    percent0 /= sum;
    percent1 /= sum;
    percent2 /= sum;

    return Container(
      height: 120 * ScalingInfo.scaleY,
      color: AppColors.colorBg1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'EXPENSE CATEGORIES',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CirclePercentageWidget(
                title: 'Bills',
                percent: percent0,
                color0: Color(0xFFA577E4),
                color1: Color(0xFF775F99),
              ),
              CirclePercentageWidget(
                title: 'Personal',
                percent: percent1,
                color0: Color(0xFF8DE4CA),
                color1: Color(0xFF509983),
              ),
              CirclePercentageWidget(
                title: 'Restaurants',
                percent: percent2,
                color0: Color(0xFFE38C8C),
                color1: Color(0xFF995E5E),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
