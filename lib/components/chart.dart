import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  double get _weekTotalValue {
    return recentTransactions.fold(0.0, (sum, tr) {
      return sum + tr.value;
    });
  }

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = recentTransactions.where((tr) {
        return tr.date.day == weekDay.day &&
            tr.date.month == weekDay.month &&
            tr.date.year == weekDay.year;
      }).fold<double>(0, (previous, current) => previous + current.value);

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
        'percentage': _weekTotalValue == 0 ? 0 : totalSum / _weekTotalValue
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((tr) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                tr['day'].toString(),
                double.parse(tr['value'].toString()),
                double.parse(tr['percentage'].toString()),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
