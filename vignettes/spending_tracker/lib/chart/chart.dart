import 'package:flutter/material.dart';

import 'chart_data_set.dart';

class Chart extends ChangeNotifier {
  List<ChartDataSet> _dataSets;
  double _domainStart;
  late double _domainEnd, _maxDomain, _rangeStart, _rangeEnd;

  final String xAxisUnit;
  final String yAxisUnit;

  int _selectedDataPoint = -1;

  Chart(List<ChartDataSet> dataSets, this.xAxisUnit, this.yAxisUnit)
      : _dataSets = dataSets,
        _domainStart = 0,
        _domainEnd = 0 {
    _maxDomain = double.maxFinite;
    for (var dataSet in _dataSets) {
      if (dataSet.values.length < _maxDomain) _maxDomain = dataSet.values.length.toDouble();
    }
    _domainEnd = _maxDomain;

    _rangeStart = min();
    _rangeEnd = max();
  }

  double min() {
    double result = double.maxFinite;
    for (var dataSet in _dataSets)
      for (var value in dataSet.values.sublist(_domainStart.round(), _domainEnd.round()))
        if (value < result) result = value;
    return result;
  }

  double max() {
    double result = 0;
    for (var dataSet in _dataSets)
      for (var value in dataSet.values.sublist(_domainStart.round(), _domainEnd.round()))
        if (value > result) result = value;
    return result;
  }

  double mean(int setIndex) {
    final values = _dataSets[setIndex].values.sublist(_domainStart.round(), _domainEnd.round());
    return values.fold<double>(0.0, (a, b) => a + b) / values.length;
  }

  double median(int setIndex) {
    assert(setIndex >= 0 && setIndex < _dataSets.length);

    final sortedValues = _dataSets[setIndex].values.sublist(_domainStart.round(), _domainEnd.round())..sort();

    double result;
    if (sortedValues.length < 2) {
      result = sortedValues[0];
    } else {
      final int mid = sortedValues.length ~/ 2;
      result = sortedValues[mid];
      if (sortedValues.length & 1 == 0) {
        result += sortedValues[mid - 1];
        result /= 2;
      }
    }

    return result;
  }

  set domainStart(double domainStart) {
    if (domainStart == _domainStart) return;

    _domainStart = domainStart.clamp(0, _domainEnd - 1.2);
    notifyListeners();
  }

  set domainEnd(double domainEnd) {
    if (domainEnd == _domainEnd) return;
    _domainEnd = domainEnd.clamp(_domainStart + 1.2, _maxDomain);

    notifyListeners();
  }

  set rangeStart(double rangeStart) {
    if (rangeStart < _rangeEnd) {
      _rangeStart = rangeStart;
      notifyListeners();
    }
  }

  set rangeEnd(double rangeEnd) {
    if (rangeEnd > _rangeStart) {
      _rangeEnd = rangeEnd;
      notifyListeners();
    }
  }

  set selectedDataPoint(int index) {
    if (index >= 0 && index < _maxDomain) {
      _selectedDataPoint = index;
      notifyListeners();
    }
  }

  double get domainStart => _domainStart;

  double get domainEnd => _domainEnd;

  double get maxDomain => _maxDomain;

  double get rangeStart => _rangeStart;

  double get rangeEnd => _rangeEnd;

  List<ChartDataSet> get dataSets => _dataSets;

  int get selectedDataPoint => _selectedDataPoint;

  double selectedX() {
    if (_selectedDataPoint == -1) return 0;
    final range = _domainEnd - _domainStart;
    final x = ((_selectedDataPoint.toDouble() - _domainStart) / range);
    return x;
  }

  double selectedY(int dataSetIndex) {
    if (_selectedDataPoint == -1) return 0;
    final y = ((_dataSets[dataSetIndex].values[_selectedDataPoint] - rangeStart) / rangeEnd);
    return y;
  }
}
