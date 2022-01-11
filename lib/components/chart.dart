import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

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
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        children: groupedTransactions.map((tr) {
          return Text('${tr['day']}: ${tr['value']}');
        }).toList(),
      ),
    );
  }
}
